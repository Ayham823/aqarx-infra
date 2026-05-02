const FRONTEND_URL = process.env.FRONTEND_URL || "http://localhost:3000"
const ADMIN_URL = process.env.ADMIN_URL || "http://localhost:3002"

const frontendRoutes = [
  "/",
  "/listings",
  "/explore",
  "/login",
  "/register",
  "/forgot-password",
  "/messages",
  "/settings",
]

const adminRoutes = [
  "/login",
  "/overview",
  "/listings",
  "/users",
  "/leads",
  "/ai",
  "/metrics",
  "/audit",
]

function log(message) {
  console.log(`[ui-smoke] ${message}`)
}

async function checkRoute(baseUrl, route, expectedStatus = 200) {
  const response = await fetch(`${baseUrl}${route}`, {
    redirect: "manual",
  })

  if (response.status !== expectedStatus) {
    throw new Error(
      `${baseUrl}${route} expected ${expectedStatus}, got ${response.status}`
    )
  }

  const body = await response.text()

  if (expectedStatus === 200 && !body.includes("<html")) {
    throw new Error(`${baseUrl}${route} did not return an HTML document`)
  }

  log(`ok ${baseUrl}${route} ${response.status}`)
}

async function main() {
  log(`frontend ${FRONTEND_URL}`)
  for (const route of frontendRoutes) {
    await checkRoute(FRONTEND_URL, route)
  }

  await checkRoute(FRONTEND_URL, "/admin/analytics", 404)

  log(`admin ${ADMIN_URL}`)
  for (const route of adminRoutes) {
    await checkRoute(ADMIN_URL, route)
  }

  log("all UI smoke checks passed")
}

main().catch((error) => {
  console.error(error)
  process.exit(1)
})
