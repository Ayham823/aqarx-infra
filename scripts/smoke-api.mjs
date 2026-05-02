const API_URL = process.env.API_URL || "http://localhost:3001/api"
const TEST_MODE = process.env.SMOKE_TEST_MODE !== "false"

const runId = `${Date.now()}-${Math.random().toString(16).slice(2)}`
const ownerEmail = `e2e-owner-${runId}@example.com`
const buyerEmail = `e2e-buyer-${runId}@example.com`
const password = "Test123456"

const state = {
  ownerToken: "",
  buyerToken: "",
  listingId: "",
  savedSearchId: "",
  conversationId: "",
  paymentId: "",
}

function log(message) {
  console.log(`[api-smoke] ${message}`)
}

async function request(path, options = {}) {
  const headers = {
    "Content-Type": "application/json",
    "x-session-id": `smoke-${runId}`,
    ...(TEST_MODE ? { "x-aqarx-test-mode": "true" } : {}),
    ...(options.token ? { Authorization: `Bearer ${options.token}` } : {}),
    ...(options.headers || {}),
  }

  const response = await fetch(`${API_URL}${path}`, {
    method: options.method || "GET",
    headers,
    body:
      options.body === undefined ? undefined : JSON.stringify(options.body),
  })
  const text = await response.text()
  let payload = null

  try {
    payload = text ? JSON.parse(text) : null
  } catch {
    payload = text
  }

  if (!response.ok || payload?.success === false) {
    const message =
      payload?.error?.message || payload?.message || text || response.statusText
    throw new Error(`${options.method || "GET"} ${path} failed: ${response.status} ${message}`)
  }

  if (payload && typeof payload === "object" && "data" in payload && "meta" in payload) {
    return {
      data: payload.data,
      meta: payload.meta,
    }
  }

  if (payload && typeof payload === "object" && "data" in payload) {
    return payload.data
  }

  return payload
}

async function step(name, fn) {
  try {
    await fn()
    log(`ok ${name}`)
  } catch (error) {
    console.error(`[api-smoke] failed ${name}`)
    throw error
  }
}

async function main() {
  log(`target ${API_URL}`)

  await step("public listings endpoint", async () => {
    const result = await request("/listings?limit=3")
    if (!Array.isArray(result.data) || !result.meta) {
      throw new Error("Listings response must include data[] and meta")
    }
  })

  await step("billing plans endpoint", async () => {
    const plans = await request("/billing/plans")
    if (!Array.isArray(plans) || plans.length < 3) {
      throw new Error("Expected at least three billing plans")
    }
  })

  await step("register owner and buyer", async () => {
    const owner = await request("/auth/register", {
      method: "POST",
      body: {
        name: "Smoke Owner",
        email: ownerEmail,
        password,
        phone: "0500000000",
      },
    })
    const buyer = await request("/auth/register", {
      method: "POST",
      body: {
        name: "Smoke Buyer",
        email: buyerEmail,
        password,
        phone: "0500000001",
      },
    })

    state.ownerToken = owner.access_token
    state.buyerToken = buyer.access_token

    if (!state.ownerToken || !state.buyerToken) {
      throw new Error("Registration did not return both access tokens")
    }
  })

  await step("login owner", async () => {
    const login = await request("/auth/login", {
      method: "POST",
      body: { email: ownerEmail, password },
    })

    if (!login.access_token) {
      throw new Error("Login did not return access_token")
    }
  })

  await step("create listing", async () => {
    const listing = await request("/listings", {
      method: "POST",
      token: state.ownerToken,
      body: {
        title: `Smoke listing ${runId}`,
        description:
          "A clean smoke-test listing created by the API E2E suite.",
        price: 4200,
        city: "Haifa",
        neighborhood: "Carmel",
        latitude: 32.794,
        longitude: 34.989,
        type: "APARTMENT",
        mode: "RENT",
        status: "PUBLISHED",
        rooms: 3,
        bathrooms: 2,
        area: 92,
        images: ["https://example.com/smoke-listing.jpg"],
      },
    })

    state.listingId = listing.id

    if (!state.listingId) {
      throw new Error("Listing create did not return id")
    }
  })

  await step("view, favorite, lead, report, and trust endpoints", async () => {
    await request(`/listings/${state.listingId}/view`, {
      method: "POST",
      token: state.buyerToken,
    })
    await request("/favorites", {
      method: "POST",
      token: state.buyerToken,
      body: { listingId: state.listingId },
    })
    await request("/leads", {
      method: "POST",
      token: state.buyerToken,
      body: {
        listingId: state.listingId,
        name: "Smoke Buyer",
        phone: "0500000001",
        message: "I am interested in this smoke-test listing.",
        source: "smoke-test",
      },
    })
    await request(`/listings/${state.listingId}/report`, {
      method: "POST",
      token: state.buyerToken,
      body: {
        reason: "OTHER",
        message: "Smoke test report.",
      },
    })
    const trust = await request(`/listings/${state.listingId}/trust-summary`)

    if (!trust.owner || !trust.listing) {
      throw new Error("Trust summary is missing owner/listing sections")
    }
  })

  await step("saved search lifecycle", async () => {
    const savedSearch = await request("/saved-searches", {
      method: "POST",
      token: state.buyerToken,
      body: {
        name: "Smoke Haifa rentals",
        filters: {
          city: "Haifa",
          mode: "RENT",
          maxPrice: "5000",
        },
      },
    })
    state.savedSearchId = savedSearch.id
    const searches = await request("/saved-searches", {
      token: state.buyerToken,
    })

    if (!searches.some((item) => item.id === state.savedSearchId)) {
      throw new Error("Saved search was not returned by list endpoint")
    }

    await request(`/saved-searches/${state.savedSearchId}`, {
      method: "DELETE",
      token: state.buyerToken,
    })
  })

  await step("messaging lifecycle", async () => {
    const conversation = await request("/messages/conversations", {
      method: "POST",
      token: state.buyerToken,
      body: {
        listingId: state.listingId,
        message: "Hello, is this listing still available?",
      },
    })

    state.conversationId = conversation.id

    await request(`/messages/conversations/${state.conversationId}/messages`, {
      method: "POST",
      token: state.ownerToken,
      body: {
        message: "Yes, it is available.",
      },
    })

    const unread = await request("/messages/unread-count", {
      token: state.buyerToken,
    })

    if (typeof unread.count !== "number") {
      throw new Error("Unread count response must include count")
    }

    await request(`/messages/conversations/${state.conversationId}/read`, {
      method: "PATCH",
      token: state.buyerToken,
    })
  })

  await step("payments lifecycle", async () => {
    const checkout = await request("/billing/checkout", {
      method: "POST",
      token: state.ownerToken,
      body: {
        purpose: "BOOST_LISTING",
        listingId: state.listingId,
      },
    })

    state.paymentId = checkout.payment.id

    const confirmation = await request(
      `/billing/payments/${state.paymentId}/confirm`,
      {
        method: "POST",
        token: state.ownerToken,
      }
    )

    if (!confirmation.applied) {
      throw new Error("Payment confirmation did not apply payment")
    }
  })

  await step("owner can delete smoke listing", async () => {
    await request(`/listings/${state.listingId}`, {
      method: "DELETE",
      token: state.ownerToken,
    })
  })

  log("all API smoke checks passed")
}

main().catch((error) => {
  console.error(error)
  process.exit(1)
})
