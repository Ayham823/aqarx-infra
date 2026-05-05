--
-- PostgreSQL database dump
--

\restrict vslfMWgKYaYCkrIhw237B9v4CrrVOHI8TkWVka493RcfPgrkJTjTOHn7skSPIDW

-- Dumped from database version 16.13 (Debian 16.13-1.pgdg13+1)
-- Dumped by pg_dump version 16.13 (Debian 16.13-1.pgdg13+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


--
-- Name: AiApprovalFeedback; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."AiApprovalFeedback" AS ENUM (
    'APPROVE',
    'REJECT'
);


--
-- Name: AiCorrectnessFeedback; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."AiCorrectnessFeedback" AS ENUM (
    'CORRECT',
    'INCORRECT'
);


--
-- Name: AiUsefulnessFeedback; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."AiUsefulnessFeedback" AS ENUM (
    'USEFUL',
    'NOT_USEFUL'
);


--
-- Name: EventType; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."EventType" AS ENUM (
    'LISTING_VIEWED',
    'SEARCH_PERFORMED',
    'INQUIRY_CREATED',
    'FAVORITE_ADDED',
    'FAVORITE_REMOVED',
    'SAVED_SEARCH_CREATED',
    'SAVED_SEARCH_DELETED',
    'LISTING_CREATED',
    'LISTING_UPDATED',
    'LISTING_DELETED',
    'LEAD_STATUS_CHANGED',
    'AI_SUGGESTION_ACCEPTED',
    'AI_SUGGESTION_REJECTED',
    'VERIFICATION_REQUESTED',
    'LISTING_REPORTED',
    'PAYMENT_COMPLETED',
    'LISTING_PROMOTED',
    'SUBSCRIPTION_CHANGED',
    'EXPERIMENT_EXPOSED'
);


--
-- Name: ExperimentStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ExperimentStatus" AS ENUM (
    'DRAFT',
    'RUNNING',
    'PAUSED',
    'COMPLETED'
);


--
-- Name: LeadStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."LeadStatus" AS ENUM (
    'NEW',
    'CONTACTED',
    'CLOSED'
);


--
-- Name: ListingMode; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ListingMode" AS ENUM (
    'RENT',
    'SALE'
);


--
-- Name: ListingReportReason; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ListingReportReason" AS ENUM (
    'FAKE_LISTING',
    'WRONG_DETAILS',
    'SUSPICIOUS_OWNER',
    'DUPLICATE',
    'OTHER'
);


--
-- Name: ListingStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ListingStatus" AS ENUM (
    'DRAFT',
    'PUBLISHED',
    'ARCHIVED'
);


--
-- Name: ListingType; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ListingType" AS ENUM (
    'APARTMENT',
    'HOUSE',
    'VILLA'
);


--
-- Name: ModerationReviewStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."ModerationReviewStatus" AS ENUM (
    'OPEN',
    'UNDER_REVIEW',
    'RESOLVED',
    'DISMISSED'
);


--
-- Name: NotificationType; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."NotificationType" AS ENUM (
    'SAVED_SEARCH_MATCH',
    'PRICE_DROP',
    'INQUIRY_CREATED',
    'RECOMMENDATIONS_READY',
    'SYSTEM'
);


--
-- Name: PaymentPurpose; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."PaymentPurpose" AS ENUM (
    'SUBSCRIPTION',
    'FEATURED_LISTING',
    'BOOST_LISTING'
);


--
-- Name: PaymentStatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."PaymentStatus" AS ENUM (
    'PENDING',
    'PAID',
    'FAILED',
    'CANCELED'
);


--
-- Name: PlanType; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."PlanType" AS ENUM (
    'FREE',
    'AGENT',
    'PREMIUM'
);


--
-- Name: RankingFeedbackQuality; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."RankingFeedbackQuality" AS ENUM (
    'GOOD',
    'BAD'
);


--
-- Name: RankingFeedbackRelevance; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."RankingFeedbackRelevance" AS ENUM (
    'RELEVANT',
    'NOT_RELEVANT'
);


--
-- Name: RecommendationStrategy; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public."RecommendationStrategy" AS ENUM (
    'DEFAULT',
    'POPULARITY',
    'BEHAVIOR',
    'AI'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: AiFeedback; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."AiFeedback" (
    id text NOT NULL,
    "requestLogId" text NOT NULL,
    "actorUserId" text,
    endpoint text NOT NULL,
    provider text,
    model text,
    "latencyMs" integer NOT NULL,
    "fallbackUsed" boolean DEFAULT false NOT NULL,
    "inputJson" jsonb,
    "outputJson" jsonb,
    correctness public."AiCorrectnessFeedback",
    usefulness public."AiUsefulnessFeedback",
    approval public."AiApprovalFeedback",
    "reviewerNote" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "expectedOutputJson" jsonb
);


--
-- Name: AiRequestLog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."AiRequestLog" (
    id text NOT NULL,
    endpoint text NOT NULL,
    provider text,
    model text,
    success boolean NOT NULL,
    "fallbackUsed" boolean DEFAULT false NOT NULL,
    "cacheHit" boolean DEFAULT false NOT NULL,
    "latencyMs" integer NOT NULL,
    "inputJson" jsonb,
    "outputJson" jsonb,
    "errorMessage" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: AuditLog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."AuditLog" (
    id text NOT NULL,
    "actorUserId" text,
    "targetType" text NOT NULL,
    "targetId" text NOT NULL,
    action text NOT NULL,
    "beforeJson" jsonb,
    "afterJson" jsonb,
    "metadataJson" jsonb,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: Conversation; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Conversation" (
    id text NOT NULL,
    "listingId" text NOT NULL,
    "buyerUserId" text NOT NULL,
    "ownerUserId" text NOT NULL,
    "lastMessageAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: EmailLog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."EmailLog" (
    id text NOT NULL,
    "userId" text,
    "to" text NOT NULL,
    subject text NOT NULL,
    type text NOT NULL,
    status text NOT NULL,
    provider text NOT NULL,
    "errorMessage" text,
    metadata jsonb,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: Event; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Event" (
    id text NOT NULL,
    "userId" text,
    "sessionId" text,
    type public."EventType" NOT NULL,
    "entityId" text,
    "entityType" text,
    metadata jsonb,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: Experiment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Experiment" (
    key text NOT NULL,
    name text NOT NULL,
    description text,
    status public."ExperimentStatus" DEFAULT 'RUNNING'::public."ExperimentStatus" NOT NULL,
    "controlVariant" text DEFAULT 'A'::text NOT NULL,
    "treatmentVariant" text DEFAULT 'B'::text NOT NULL,
    "treatmentPercentage" integer DEFAULT 50 NOT NULL,
    "primaryMetric" text DEFAULT 'conversion'::text NOT NULL,
    "winnerVariant" text,
    "configJson" jsonb,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: Favorite; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Favorite" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "listingId" text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: Lead; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Lead" (
    id text NOT NULL,
    "listingId" text NOT NULL,
    name text NOT NULL,
    phone text NOT NULL,
    message text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "ownerUserId" text NOT NULL,
    "senderUserId" text,
    source text,
    status public."LeadStatus" DEFAULT 'NEW'::public."LeadStatus" NOT NULL
);


--
-- Name: Listing; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Listing" (
    id text NOT NULL,
    title text NOT NULL,
    description text NOT NULL,
    price double precision NOT NULL,
    city text NOT NULL,
    neighborhood text,
    type public."ListingType" NOT NULL,
    mode public."ListingMode" NOT NULL,
    rooms integer NOT NULL,
    bathrooms integer NOT NULL,
    area double precision NOT NULL,
    image text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "createdById" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    status public."ListingStatus" DEFAULT 'PUBLISHED'::public."ListingStatus" NOT NULL,
    "boostedUntil" timestamp(3) without time zone,
    "featuredUntil" timestamp(3) without time zone,
    latitude double precision,
    longitude double precision
);


--
-- Name: ListingImage; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ListingImage" (
    id text NOT NULL,
    "listingId" text NOT NULL,
    url text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "sortOrder" integer DEFAULT 0 NOT NULL
);


--
-- Name: ListingReport; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ListingReport" (
    id text NOT NULL,
    "listingId" text NOT NULL,
    "userId" text,
    "sessionId" text,
    reason public."ListingReportReason" NOT NULL,
    message text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "adminNotes" text,
    "reviewStatus" public."ModerationReviewStatus" DEFAULT 'OPEN'::public."ModerationReviewStatus" NOT NULL,
    "reviewedAt" timestamp(3) without time zone,
    "reviewedById" text
);


--
-- Name: ListingView; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."ListingView" (
    id text NOT NULL,
    "listingId" text NOT NULL,
    "userId" text,
    "viewedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: Message; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Message" (
    id text NOT NULL,
    "conversationId" text NOT NULL,
    "senderUserId" text NOT NULL,
    "recipientUserId" text NOT NULL,
    body text NOT NULL,
    "readAt" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: Notification; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Notification" (
    id text NOT NULL,
    "userId" text NOT NULL,
    type public."NotificationType" NOT NULL,
    title text NOT NULL,
    message text NOT NULL,
    "entityType" text,
    "entityId" text,
    metadata jsonb,
    "readAt" timestamp(3) without time zone,
    "dedupeKey" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: OwnerRating; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."OwnerRating" (
    id text NOT NULL,
    "ownerUserId" text NOT NULL,
    "raterUserId" text NOT NULL,
    "listingId" text,
    score integer NOT NULL,
    comment text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: PasswordResetToken; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."PasswordResetToken" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "tokenHash" text NOT NULL,
    "expiresAt" timestamp(3) without time zone NOT NULL,
    "usedAt" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: Payment; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."Payment" (
    id text NOT NULL,
    "userId" text NOT NULL,
    "listingId" text,
    purpose public."PaymentPurpose" NOT NULL,
    status public."PaymentStatus" DEFAULT 'PENDING'::public."PaymentStatus" NOT NULL,
    plan public."PlanType",
    amount double precision NOT NULL,
    currency text DEFAULT 'USD'::text NOT NULL,
    provider text DEFAULT 'local'::text NOT NULL,
    metadata jsonb,
    "paidAt" timestamp(3) without time zone,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: RankingDecision; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."RankingDecision" (
    id text NOT NULL,
    objective text NOT NULL,
    "queryText" text,
    strategy text,
    "filtersJson" jsonb,
    "viewerJson" jsonb,
    "engineVersion" text NOT NULL,
    "weightsJson" jsonb,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: RankingDecisionItem; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."RankingDecisionItem" (
    id text NOT NULL,
    "decisionId" text NOT NULL,
    "listingId" text NOT NULL,
    "listingTitle" text NOT NULL,
    city text NOT NULL,
    price double precision NOT NULL,
    rank integer NOT NULL,
    score double precision NOT NULL,
    "baseScore" double precision NOT NULL,
    "aiScore" double precision NOT NULL,
    reason text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: RankingFeedback; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."RankingFeedback" (
    id text NOT NULL,
    "decisionItemId" text NOT NULL,
    "actorUserId" text,
    quality public."RankingFeedbackQuality",
    relevance public."RankingFeedbackRelevance",
    "reviewerNote" text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: SavedSearch; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."SavedSearch" (
    id text NOT NULL,
    "userId" text NOT NULL,
    name text,
    "filtersJson" jsonb NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: SearchOverride; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."SearchOverride" (
    id text NOT NULL,
    query text NOT NULL,
    "normalizedQuery" text NOT NULL,
    "rewrittenQuery" text,
    "filtersJson" jsonb NOT NULL,
    note text,
    active boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: SearchSynonym; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."SearchSynonym" (
    id text NOT NULL,
    term text NOT NULL,
    synonym text NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: SystemSetting; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."SystemSetting" (
    key text NOT NULL,
    "valueJson" jsonb NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


--
-- Name: User; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public."User" (
    id text NOT NULL,
    name text,
    email text NOT NULL,
    phone text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "isVerified" boolean DEFAULT false NOT NULL,
    "passwordHash" text NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    role text DEFAULT 'USER'::text NOT NULL,
    plan public."PlanType" DEFAULT 'FREE'::public."PlanType" NOT NULL,
    "planExpiresAt" timestamp(3) without time zone
);


--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


--
-- Data for Name: AiFeedback; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."AiFeedback" (id, "requestLogId", "actorUserId", endpoint, provider, model, "latencyMs", "fallbackUsed", "inputJson", "outputJson", correctness, usefulness, approval, "reviewerNote", "createdAt", "updatedAt", "expectedOutputJson") FROM stdin;
f599bb25-9f01-47c6-a1c0-b527cae07bf7	ba07bf2b-622a-4213-bf41-e4ba3be5a1f7	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	/ai/neighborhood/summary	\N	\N	3216	f	{"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}	{"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	CORRECT	USEFUL	\N	\N	2026-04-25 13:48:00.194	2026-04-25 13:48:12.955	\N
3867d13d-e077-4b71-9eab-109e302bb160	4bfd5858-3717-46d9-88b6-a6db6a21f9c5	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	/ai/content/listing	\N	\N	3355	f	{"mode": "RENT", "language": "en", "property_type": "APARTMENT"}	{"cta": "Contact the owner to schedule a viewing.", "title": "Apartment in a convenient location", "language": "en", "description": "This listing offers a practical option in the area. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent."}	\N	USEFUL	\N	\N	2026-04-24 21:54:38.458	2026-04-25 13:48:25.99	{}
a653133e-2307-46b1-922b-ebaa20cb043c	345af401-6788-4577-b479-e328cdb7599d	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	/ai/neighborhood/summary	\N	\N	4084	f	{"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}	{"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	\N	REJECT	\N	2026-04-25 13:49:42.638	2026-04-25 13:49:42.638	\N
b21f45a4-39a6-48c2-97f4-7be255ee9020	12004a18-d3b2-4ff7-88dc-9f2cdabe80b7	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	/ai/neighborhood/summary	\N	\N	4977	f	{"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}	{"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	CORRECT	\N	\N	\N	2026-04-25 21:10:03.33	2026-04-25 21:10:03.33	\N
cf32e0cb-b3d7-48a5-b947-eb01ab96057a	465e0b4c-7d2d-4d6d-a110-70c8f3026e8d	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	/ai/search/parse	\N	\N	4509	f	{"query": "شقة للطلاب في حيفا للايجار"}	{"filters": {"q": "students", "city": "Haifa", "mode": "RENT", "sort": "price_low", "type": "APARTMENT", "rooms": null, "maxArea": null, "minArea": null, "maxPrice": null, "minPrice": null, "bathrooms": null}, "confidence": 0.83, "explanation": "Parsed search intent with local fallback rules."}	\N	USEFUL	\N	\N	2026-04-25 21:10:20.924	2026-04-25 21:10:20.924	\N
83b1a72e-28dd-4233-97dd-e54aaed1411e	923f56eb-1650-4cf0-a4ae-858c821bba1e	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	/ai/search/parse	\N	\N	5992	f	{"query": "شقة للطلاب في حيفا"}	{"filters": {"q": "students", "city": "Haifa", "mode": null, "sort": "price_low", "type": "APARTMENT", "rooms": null, "maxArea": null, "minArea": null, "maxPrice": null, "minPrice": null, "bathrooms": null}, "confidence": 0.73, "explanation": "Parsed search intent with local fallback rules."}	CORRECT	\N	\N	\N	2026-04-25 21:10:22.259	2026-04-25 21:10:22.259	\N
74da0587-ac50-4a64-a800-b5751685f144	03b05cf8-bb2f-47bc-9806-7a587be64778	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	/ai/search/parse	\N	\N	4928	f	{"query": "apartment in Haifa"}	{"filters": {"q": null, "city": "Haifa", "mode": null, "sort": null, "type": "APARTMENT", "rooms": null, "maxArea": null, "minArea": null, "maxPrice": null, "minPrice": null, "bathrooms": null}, "confidence": 0.65, "explanation": "Parsed search intent with local fallback rules."}	CORRECT	\N	\N	\N	2026-04-25 21:10:29.186	2026-04-25 21:10:29.186	\N
4addf63a-41e9-45fb-b9a7-d933b8354cfc	45d971cf-eb2f-40a1-bea1-e163b62e7f26	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	/ai/content/listing	\N	\N	6551	f	{"mode": "RENT", "language": "en", "property_type": "APARTMENT"}	{"cta": "Contact the owner to schedule a viewing.", "title": "Apartment in a convenient location", "language": "en", "description": "This listing offers a practical option in the area. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent."}	\N	USEFUL	\N	\N	2026-04-25 21:10:30.306	2026-04-25 21:10:30.306	\N
a9419a1f-ce5f-4b6d-a8b9-e30f877ccbb6	ca15fc8e-dcf6-44da-af85-a78c54bf1811	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	/ai/search/parse	\N	\N	5111	f	{"query": "شقة للطلاب في حيفا للايجار يوجد فيها اكثر من غرفتين"}	{"filters": {"q": "students", "city": "Haifa", "mode": "RENT", "sort": "price_low", "type": "APARTMENT", "rooms": null, "maxArea": null, "minArea": null, "maxPrice": null, "minPrice": null, "bathrooms": null}, "confidence": 0.83, "explanation": "Parsed search intent with local fallback rules."}	INCORRECT	\N	\N	\N	2026-04-25 21:10:46.129	2026-04-25 21:10:46.129	\N
\.


--
-- Data for Name: AiRequestLog; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."AiRequestLog" (id, endpoint, provider, model, success, "fallbackUsed", "cacheHit", "latencyMs", "inputJson", "outputJson", "errorMessage", "createdAt") FROM stdin;
60c23513-14f3-472a-b2f4-c12317662739	/ai/neighborhood/summary	\N	\N	t	f	f	4995	{"city": "Tel Aviv", "mode": "RENT", "listing_type": "HOUSE", "neighborhood": null}	{"summary": "Tel Aviv may be worth considering for people renting in Tel Aviv. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-23 16:23:58.278
bf059ea6-233a-46d9-af71-fa904b5327e4	/ai/neighborhood/summary	\N	\N	t	f	f	5215	{"city": "Tel Aviv", "mode": "RENT", "listing_type": "HOUSE", "neighborhood": null}	{"summary": "Tel Aviv may be worth considering for people renting in Tel Aviv. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-23 16:23:58.751
513cbab0-23ff-4844-8652-3ca77604ff29	/ai/neighborhood/summary	\N	\N	t	f	f	4639	{"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": "Downtown"}	{"summary": "Downtown may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-23 16:58:18.562
7f13e0a7-6436-4ac5-9e86-73067abff7d7	/ai/neighborhood/summary	\N	\N	t	f	f	6587	{"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": "Downtown"}	{"summary": "Downtown may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-23 16:58:20.481
d6f00de0-b556-46d6-a2c3-079663f16a53	/ai/neighborhood/summary	\N	\N	t	f	f	3914	{"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}	{"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-23 16:58:24.722
345af401-6788-4577-b479-e328cdb7599d	/ai/neighborhood/summary	\N	\N	t	f	f	4084	{"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}	{"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-23 16:58:24.86
45d971cf-eb2f-40a1-bea1-e163b62e7f26	/ai/content/listing	\N	\N	t	f	f	6551	{"mode": "RENT", "language": "en", "property_type": "APARTMENT"}	{"cta": "Contact the owner to schedule a viewing.", "title": "Apartment in a convenient location", "language": "en", "description": "This listing offers a practical option in the area. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent."}	\N	2026-04-23 16:59:17.006
03b05cf8-bb2f-47bc-9806-7a587be64778	/ai/search/parse	\N	\N	t	f	f	4928	{"query": "apartment in Haifa"}	{"filters": {"q": null, "city": "Haifa", "mode": null, "sort": null, "type": "APARTMENT", "rooms": null, "maxArea": null, "minArea": null, "maxPrice": null, "minPrice": null, "bathrooms": null}, "confidence": 0.65, "explanation": "Parsed search intent with local fallback rules."}	\N	2026-04-24 07:42:18.573
e9a01592-2b4d-451b-a543-9080828b5335	/ai/neighborhood/summary	\N	\N	t	f	f	3024	{"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}	{"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-24 07:44:21.05
ba07bf2b-622a-4213-bf41-e4ba3be5a1f7	/ai/neighborhood/summary	\N	\N	t	f	f	3216	{"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}	{"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-24 07:44:21.205
4bfd5858-3717-46d9-88b6-a6db6a21f9c5	/ai/content/listing	\N	\N	t	f	f	3355	{"mode": "RENT", "language": "en", "property_type": "APARTMENT"}	{"cta": "Contact the owner to schedule a viewing.", "title": "Apartment in a convenient location", "language": "en", "description": "This listing offers a practical option in the area. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent."}	\N	2026-04-24 07:47:35.797
923f56eb-1650-4cf0-a4ae-858c821bba1e	/ai/search/parse	\N	\N	t	f	f	5992	{"query": "شقة للطلاب في حيفا"}	{"filters": {"q": "students", "city": "Haifa", "mode": null, "sort": "price_low", "type": "APARTMENT", "rooms": null, "maxArea": null, "minArea": null, "maxPrice": null, "minPrice": null, "bathrooms": null}, "confidence": 0.73, "explanation": "Parsed search intent with local fallback rules."}	\N	2026-04-25 21:05:38.674
465e0b4c-7d2d-4d6d-a110-70c8f3026e8d	/ai/search/parse	\N	\N	t	f	f	4509	{"query": "شقة للطلاب في حيفا للايجار"}	{"filters": {"q": "students", "city": "Haifa", "mode": "RENT", "sort": "price_low", "type": "APARTMENT", "rooms": null, "maxArea": null, "minArea": null, "maxPrice": null, "minPrice": null, "bathrooms": null}, "confidence": 0.83, "explanation": "Parsed search intent with local fallback rules."}	\N	2026-04-25 21:05:57.827
ca15fc8e-dcf6-44da-af85-a78c54bf1811	/ai/search/parse	\N	\N	t	f	f	5111	{"query": "شقة للطلاب في حيفا للايجار يوجد فيها اكثر من غرفتين"}	{"filters": {"q": "students", "city": "Haifa", "mode": "RENT", "sort": "price_low", "type": "APARTMENT", "rooms": null, "maxArea": null, "minArea": null, "maxPrice": null, "minPrice": null, "bathrooms": null}, "confidence": 0.83, "explanation": "Parsed search intent with local fallback rules."}	\N	2026-04-25 21:06:26.925
796dd4e6-e3b0-4762-ad15-564857c87d38	/ai/neighborhood/summary	\N	\N	t	f	f	3950	{"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}	{"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-25 21:07:16.155
12004a18-d3b2-4ff7-88dc-9f2cdabe80b7	/ai/neighborhood/summary	\N	\N	t	f	f	4977	{"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}	{"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-25 21:07:17.148
5027ba88-a852-4a89-8934-107142fee146	/ai/content/listing	\N	\N	t	f	f	4166	{"mode": "RENT", "language": "en", "property_type": "APARTMENT"}	{"cta": "Contact the owner to schedule a viewing.", "title": "Apartment in a convenient location", "language": "en", "description": "This listing offers a practical option in the area. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent."}	\N	2026-04-25 21:08:00.03
cac59d04-264f-4feb-9ad5-f72db648c694	/ai/neighborhood/summary	\N	\N	t	f	f	5437	{"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}	{"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-25 22:38:59.871
e36aee13-0258-47e6-bd68-be8aed91e494	/ai/neighborhood/summary	\N	\N	t	f	f	5676	{"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}	{"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-25 22:39:00.176
8cc7a613-73f8-41cc-ba50-57c2c2bd1280	/ai/neighborhood/summary	\N	\N	t	f	f	3434	{"city": "Tel Aviv", "mode": "SALE", "listing_type": "HOUSE", "neighborhood": null}	{"summary": "Tel Aviv may be worth considering for people buying in Tel Aviv. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-25 22:39:04.447
c8c6a67c-4ed2-4917-ae19-c252c08c08ea	/ai/neighborhood/summary	\N	\N	t	f	f	3569	{"city": "Tel Aviv", "mode": "SALE", "listing_type": "HOUSE", "neighborhood": null}	{"summary": "Tel Aviv may be worth considering for people buying in Tel Aviv. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-25 22:39:04.524
acf3aed2-fb6a-4b05-8fa1-e5298ff598b8	/ai/ranking/listings	openai	gpt-5.4	t	t	f	5250	{"filters": {}, "listings": [{"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "c901de33-674a-444d-8892-259897e9e4a9", "area": 125, "city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "leads": 2, "price": 120000, "rooms": 5, "title": "Modern property with strong potential", "views": 25, "reports": 0, "bathrooms": 3, "favorites": 2, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "objective": "SEARCH"}	{"model": "gpt-5.4", "scores": [{"score": 48.15, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 40.699999999999996, "reason": "hybrid fallback", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 45.65, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 47.800000000000004, "reason": "hybrid fallback", "listingId": "c901de33-674a-444d-8892-259897e9e4a9"}, {"score": 40.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 44.699999999999996, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 40.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 42.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 30.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:09:45.131
87d8653f-8af4-4448-ab2a-47be6e8aff3e	/ai/ranking/listings	openai	gpt-5.4	t	t	f	5193	{"filters": {}, "listings": [{"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "c901de33-674a-444d-8892-259897e9e4a9", "area": 125, "city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "leads": 2, "price": 120000, "rooms": 5, "title": "Modern property with strong potential", "views": 25, "reports": 0, "bathrooms": 3, "favorites": 2, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "objective": "SEARCH"}	{"model": "gpt-5.4", "scores": [{"score": 48.15, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 40.699999999999996, "reason": "hybrid fallback", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 45.65, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 47.800000000000004, "reason": "hybrid fallback", "listingId": "c901de33-674a-444d-8892-259897e9e4a9"}, {"score": 40.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 44.699999999999996, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 40.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 42.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 30.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:09:45.137
86989a4d-67d6-4d38-ade6-1ea0f93348b4	/ai/ranking/listings	openai	gpt-5.4	t	t	f	5565	{"filters": {}, "listings": [{"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "c901de33-674a-444d-8892-259897e9e4a9", "area": 125, "city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "leads": 2, "price": 120000, "rooms": 5, "title": "Modern property with strong potential", "views": 25, "reports": 0, "bathrooms": 3, "favorites": 2, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "objective": "SEARCH"}	{"model": "gpt-5.4", "scores": [{"score": 48.15, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 40.699999999999996, "reason": "hybrid fallback", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 45.65, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 47.800000000000004, "reason": "hybrid fallback", "listingId": "c901de33-674a-444d-8892-259897e9e4a9"}, {"score": 40.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 44.699999999999996, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 40.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 42.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 30.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:09:45.449
199d55c1-b4cf-4250-92a3-797e659f9efe	/ai/ranking/listings	openai	gpt-5.4	t	t	f	5676	{"filters": {}, "listings": [{"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "c901de33-674a-444d-8892-259897e9e4a9", "area": 125, "city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "leads": 2, "price": 120000, "rooms": 5, "title": "Modern property with strong potential", "views": 25, "reports": 0, "bathrooms": 3, "favorites": 2, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "objective": "SEARCH"}	{"model": "gpt-5.4", "scores": [{"score": 48.15, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 40.699999999999996, "reason": "hybrid fallback", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 45.65, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 47.800000000000004, "reason": "hybrid fallback", "listingId": "c901de33-674a-444d-8892-259897e9e4a9"}, {"score": 40.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 44.699999999999996, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 40.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 42.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 30.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:09:45.786
640c360a-1753-4b4f-81c6-b5d0249fa848	/ai/ranking/listings	openai	gpt-5.4	t	t	f	5749	{"filters": {}, "listings": [{"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "c901de33-674a-444d-8892-259897e9e4a9", "area": 125, "city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "leads": 2, "price": 120000, "rooms": 5, "title": "Modern property with strong potential", "views": 25, "reports": 0, "bathrooms": 3, "favorites": 2, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "objective": "SEARCH"}	{"model": "gpt-5.4", "scores": [{"score": 48.15, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 40.699999999999996, "reason": "hybrid fallback", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 45.65, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 47.800000000000004, "reason": "hybrid fallback", "listingId": "c901de33-674a-444d-8892-259897e9e4a9"}, {"score": 40.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 44.699999999999996, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 40.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 42.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 30.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:09:45.846
ce6bb565-8725-49b1-a498-18b6d4722e08	/ai/ranking/listings	openai	gpt-5.4	t	t	f	6023	{"filters": {}, "listings": [{"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "c901de33-674a-444d-8892-259897e9e4a9", "area": 125, "city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "leads": 2, "price": 120000, "rooms": 5, "title": "Modern property with strong potential", "views": 25, "reports": 0, "bathrooms": 3, "favorites": 2, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "objective": "SEARCH"}	{"model": "gpt-5.4", "scores": [{"score": 48.15, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 40.699999999999996, "reason": "hybrid fallback", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 45.65, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 47.800000000000004, "reason": "hybrid fallback", "listingId": "c901de33-674a-444d-8892-259897e9e4a9"}, {"score": 40.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 44.699999999999996, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 40.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 42.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 30.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:09:45.973
fd88ad87-4a58-4729-b885-91780ea87810	/ai/ranking/listings	\N	\N	f	f	f	45	{"filters": {}, "listings": [{"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "c901de33-674a-444d-8892-259897e9e4a9", "area": 125, "city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "leads": 2, "price": 120000, "rooms": 5, "title": "Modern property with strong potential", "views": 25, "reports": 0, "bathrooms": 3, "favorites": 2, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "objective": "SEARCH"}	{"message": "Internal AI service error", "success": false}	AI service failed	2026-04-26 09:10:41.025
fac070af-e6bc-4045-8042-7bedcd45a3f4	/ai/ranking/listings	\N	\N	f	f	f	98	{"filters": {}, "listings": [{"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "c901de33-674a-444d-8892-259897e9e4a9", "area": 125, "city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "leads": 2, "price": 120000, "rooms": 5, "title": "Modern property with strong potential", "views": 25, "reports": 0, "bathrooms": 3, "favorites": 2, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "objective": "SEARCH"}	{"message": "Internal AI service error", "success": false}	AI service failed	2026-04-26 09:10:41.078
3c4f5029-7da6-4e41-8e0c-4da8299c537b	/ai/content/listing	\N	\N	t	f	f	3894	{"area": 55, "city": "Tbilisi", "mode": "RENT", "price": 70000, "rooms": 2, "title": "apartment1", "language": "en", "bathrooms": 1, "neighborhood": "good", "property_type": "APARTMENT"}	{"cta": "Contact the owner to schedule a viewing.", "title": "Apartment in good", "language": "en", "description": "This listing offers a practical option in good. It includes 2 rooms, 1 bathrooms, and 55.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent."}	\N	2026-04-26 09:12:05.857
a9660816-9757-4cbe-b544-186a6c92c9c7	/ai/content/listing	\N	\N	t	f	f	4289	{"area": 55, "city": "Tbilisi", "mode": "RENT", "price": 70000, "rooms": 2, "title": "apartment1", "language": "en", "bathrooms": 1, "neighborhood": "Green", "property_type": "APARTMENT"}	{"cta": "Contact the owner to schedule a viewing.", "title": "Apartment in Green", "language": "en", "description": "This listing offers a practical option in Green. It includes 2 rooms, 1 bathrooms, and 55.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent."}	\N	2026-04-26 09:12:36.684
62109961-68fb-4cd8-8069-6260ce06e804	/ai/content/quality	\N	\N	t	f	f	3656	{"area": 55, "city": "Tbilisi", "mode": "RENT", "price": 70000, "rooms": 2, "title": "Apartment1 in Green", "bathrooms": 1, "description": "This listing offers a practical option in Green. It includes 2 rooms, 1 bathrooms, and 55.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "image_count": 2, "neighborhood": "Green", "property_type": "APARTMENT"}	{"level": "excellent", "score": 95, "strengths": ["Title length is healthy.", "Description has enough depth for buyers.", "City is present.", "Price is clear."], "risk_flags": ["Low photo count can make the listing look suspicious."], "suggestions": ["Add more photos to build trust."], "duplicate_risk": "low", "owner_suggestions": []}	\N	2026-04-26 09:12:51.703
6e46bd59-e11c-4c75-8100-102fac464686	/ai/ranking/listings	openai	gpt-5.4	t	t	f	3930	{"viewer": {"preferredModes": [], "preferredTypes": [], "preferredCities": []}, "listings": [{"id": "959feec8-ec17-4e75-8d29-af4f57913c84", "area": 55, "city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 70000, "rooms": 2, "title": "Apartment1 in Green", "views": 0, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 2 rooms, 1 bathrooms, and 55.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "c901de33-674a-444d-8892-259897e9e4a9", "area": 125, "city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "leads": 2, "price": 120000, "rooms": 5, "title": "Modern property with strong potential", "views": 25, "reports": 0, "bathrooms": 3, "favorites": 2, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "strategy": "AI", "objective": "RECOMMENDATION"}	{"model": "gpt-5.4", "scores": [{"score": 53, "reason": "hybrid fallback", "listingId": "959feec8-ec17-4e75-8d29-af4f57913c84"}, {"score": 45.65, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 47.800000000000004, "reason": "hybrid fallback", "listingId": "c901de33-674a-444d-8892-259897e9e4a9"}, {"score": 40.699999999999996, "reason": "hybrid fallback", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 40.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 44.699999999999996, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 48.15, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 40.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 42.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 30.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:12:54.522
c80f9bfc-5a7e-45a0-881a-3ae14885211a	/ai/neighborhood/summary	\N	\N	t	f	f	4184	{"city": "Tbilisi", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": "Green"}	{"summary": "Green may be worth considering for people renting in Tbilisi. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-26 09:12:54.696
74ea2c5c-eb75-4d8e-b988-d6de43278589	/ai/ranking/listings	openai	gpt-5.4	t	t	f	3939	{"viewer": {"maxArea": 74.25, "minArea": 35.75, "maxPrice": 94500, "minPrice": 45500, "preferredModes": ["RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tbilisi"]}, "listings": [{"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "strategy": "AI", "objective": "RECOMMENDATION"}	{"model": "gpt-5.4", "scores": [{"score": 49.65, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 56.699999999999996, "reason": "hybrid fallback", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 54.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 58.7, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 58.150000000000006, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 54.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 52.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 44.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:12:54.855
ad48a383-9cb9-47e5-b6d4-6c653064bb38	/ai/neighborhood/summary	\N	\N	t	f	f	3982	{"city": "Tbilisi", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": "Green"}	{"summary": "Green may be worth considering for people renting in Tbilisi. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-26 09:12:54.893
a653725c-4910-441a-8efc-8a3a5978a936	/ai/content/quality	\N	\N	t	f	f	4363	{"area": 80, "city": "Tbilisi", "mode": "RENT", "price": 90000, "rooms": 3, "bathrooms": 2, "image_count": 2, "neighborhood": "Green", "property_type": "APARTMENT"}	{"level": "fair", "score": 57, "strengths": ["City is present.", "Price is clear."], "risk_flags": ["Short descriptions reduce trust.", "Low photo count can make the listing look suspicious."], "suggestions": ["Use a clear title between 18 and 90 characters.", "Write a richer description with practical property highlights.", "Add more photos to build trust."], "duplicate_risk": "low", "owner_suggestions": ["Rewrite the title so it is specific and easy to scan.", "Expand the description before publishing."]}	\N	2026-04-26 09:14:01.579
1ad83715-2be1-4f57-8a26-4f45ffbc0499	/ai/content/listing	\N	\N	t	f	f	4913	{"area": 80, "city": "Tbilisi", "mode": "RENT", "price": 90000, "rooms": 3, "language": "en", "bathrooms": 2, "neighborhood": "Green", "property_type": "APARTMENT"}	{"cta": "Contact the owner to schedule a viewing.", "title": "Apartment in Green", "language": "en", "description": "This listing offers a practical option in Green. It includes 3 rooms, 2 bathrooms, and 80.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent."}	\N	2026-04-26 09:14:11.962
5d426bc7-acd2-4ab6-8962-4aeec4460832	/ai/content/quality	\N	\N	t	f	f	4058	{"area": 80, "city": "Tbilisi", "mode": "RENT", "price": 90000, "rooms": 3, "title": "Apartment in Green", "bathrooms": 2, "description": "This listing offers a practical option in Green. It includes 3 rooms, 2 bathrooms, and 80.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "image_count": 2, "neighborhood": "Green", "property_type": "APARTMENT"}	{"level": "excellent", "score": 95, "strengths": ["Title length is healthy.", "Description has enough depth for buyers.", "City is present.", "Price is clear."], "risk_flags": ["Low photo count can make the listing look suspicious."], "suggestions": ["Add more photos to build trust."], "duplicate_risk": "low", "owner_suggestions": []}	\N	2026-04-26 09:14:24.015
4c611b2f-7525-4ae7-9ce7-b4c1ab2bb8fe	/ai/neighborhood/summary	\N	\N	t	f	f	87	{"city": "Tbilisi", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": "Green"}	{"summary": "Green may be worth considering for people renting in Tbilisi. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-26 09:14:36.719
3db197dc-3d2e-49dc-b5b9-51158dc0e8aa	/ai/neighborhood/summary	\N	\N	t	f	f	85	{"city": "Tbilisi", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": "Green"}	{"summary": "Green may be worth considering for people renting in Tbilisi. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-26 09:14:36.795
52df97b6-99df-4566-9f6e-f3a8050eaff5	/ai/ranking/listings	openai	gpt-5.4	t	t	f	3867	{"viewer": {"maxArea": 74.25, "minArea": 35.75, "maxPrice": 94500, "minPrice": 45500, "preferredModes": ["RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tbilisi"]}, "listings": [{"id": "7f8bd3c9-8044-4ac4-bce0-9934871cc100", "area": 80, "city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 90000, "rooms": 3, "title": "Apartment in Green", "views": 0, "reports": 0, "bathrooms": 2, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 3 rooms, 2 bathrooms, and 80.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "strategy": "AI", "objective": "RECOMMENDATION"}	{"model": "gpt-5.4", "scores": [{"score": 79, "reason": "city preference", "listingId": "7f8bd3c9-8044-4ac4-bce0-9934871cc100"}, {"score": 49.65, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 56.699999999999996, "reason": "hybrid fallback", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 54.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 58.7, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 58.150000000000006, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 54.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 52.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 44.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:14:40.631
a6aadd7b-e03a-46e3-ad62-ab5e45bd1d8e	/ai/ranking/listings	openai	gpt-5.4	t	t	f	4007	{"viewer": {"maxArea": 74.25, "minArea": 35.75, "maxPrice": 94500, "minPrice": 45500, "preferredModes": ["RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tbilisi"]}, "listings": [{"id": "7f8bd3c9-8044-4ac4-bce0-9934871cc100", "area": 80, "city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 90000, "rooms": 3, "title": "Apartment in Green", "views": 1, "reports": 0, "bathrooms": 2, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 3 rooms, 2 bathrooms, and 80.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "strategy": "AI", "objective": "RECOMMENDATION"}	{"model": "gpt-5.4", "scores": [{"score": 79.15, "reason": "city preference", "listingId": "7f8bd3c9-8044-4ac4-bce0-9934871cc100"}, {"score": 49.65, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 56.699999999999996, "reason": "hybrid fallback", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 54.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 58.7, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 58.150000000000006, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 54.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 52.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 44.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:14:40.831
37167c3a-ab57-4837-a1d3-5a82ce2647cd	/ai/ranking/listings	openai	gpt-5.4	t	t	f	3570	{"viewer": {"maxArea": 91.125, "minArea": 43.875, "maxPrice": 108000, "minPrice": 52000, "preferredModes": ["RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tbilisi"]}, "listings": [{"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "strategy": "AI", "objective": "RECOMMENDATION"}	{"model": "gpt-5.4", "scores": [{"score": 53.65, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 56.699999999999996, "reason": "hybrid fallback", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 50.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 58.7, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 62.150000000000006, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 54.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 52.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 44.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:14:47.621
d87c6aa8-3b1b-4fde-bde0-029d4e7d1bea	/ai/ranking/listings	openai	gpt-5.4	t	t	f	3609	{"viewer": {"maxArea": 91.125, "minArea": 43.875, "maxPrice": 108000, "minPrice": 52000, "preferredModes": ["RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tbilisi"]}, "listings": [{"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "strategy": "AI", "objective": "RECOMMENDATION"}	{"model": "gpt-5.4", "scores": [{"score": 53.65, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 56.699999999999996, "reason": "hybrid fallback", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 50.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 58.7, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 62.150000000000006, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 54.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 52.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 44.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:14:47.677
7e2534b4-15af-421f-b9b3-0cd35de957b4	/ai/content/listing	\N	\N	t	f	f	3806	{"area": 120, "city": "Um Al Fahm", "mode": "RENT", "price": 140000, "rooms": 5, "title": "House", "language": "en", "bathrooms": 3, "property_type": "APARTMENT"}	{"cta": "Contact the owner to schedule a viewing.", "title": "Apartment in Um Al Fahm", "language": "en", "description": "This listing offers a practical option in Um Al Fahm. It includes 5 rooms, 3 bathrooms, and 120.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent."}	\N	2026-04-26 09:16:15.73
a29e9311-7146-44cf-a411-f59b66d2da7b	/ai/content/quality	\N	\N	t	f	f	3988	{"area": 120, "city": "Um Al Fahm", "mode": "RENT", "price": 140000, "rooms": 5, "title": "House", "bathrooms": 3, "image_count": 2, "property_type": "APARTMENT"}	{"level": "fair", "score": 50, "strengths": ["City is present.", "Price is clear."], "risk_flags": ["Short descriptions reduce trust.", "Low photo count can make the listing look suspicious."], "suggestions": ["Use a clear title between 18 and 90 characters.", "Write a richer description with practical property highlights.", "Add the neighborhood when available.", "Add more photos to build trust."], "duplicate_risk": "low", "owner_suggestions": ["Rewrite the title so it is specific and easy to scan.", "Expand the description before publishing.", "Add the neighborhood or a nearby landmark if it is safe to share."]}	\N	2026-04-26 09:16:16.747
a9794994-2670-4ee0-a44a-c898dde11982	/ai/content/quality	\N	\N	t	f	f	3953	{"area": 120, "city": "Um Al Fahm", "mode": "RENT", "price": 140000, "rooms": 5, "title": "Apartment in Um Al Fahm", "bathrooms": 3, "description": "This listing offers a practical option in Um Al Fahm. It includes 5 rooms, 3 bathrooms, and 120.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "image_count": 2, "property_type": "APARTMENT"}	{"level": "excellent", "score": 88, "strengths": ["Title length is healthy.", "Description has enough depth for buyers.", "City is present.", "Price is clear."], "risk_flags": ["Low photo count can make the listing look suspicious."], "suggestions": ["Add the neighborhood when available.", "Add more photos to build trust."], "duplicate_risk": "low", "owner_suggestions": ["Add the neighborhood or a nearby landmark if it is safe to share."]}	\N	2026-04-26 09:16:26.073
34031019-e355-4b4d-af76-8163bdde1d56	/ai/neighborhood/summary	\N	\N	t	f	f	3756	{"city": "Um Al Fahm", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}	{"summary": "Um Al Fahm may be worth considering for people renting in Um Al Fahm. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-26 09:16:34.64
c5ed3f94-58c4-4334-879d-adfde1268131	/ai/ranking/listings	openai	gpt-5.4	t	t	f	3732	{"viewer": {"maxArea": 91.125, "minArea": 43.875, "maxPrice": 108000, "minPrice": 52000, "preferredModes": ["RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tbilisi"]}, "listings": [{"id": "cb288153-a8d4-4973-9435-75d98775f743", "area": 120, "city": "Um Al Fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 140000, "rooms": 5, "title": "Apartment in Um Al Fahm", "views": 0, "reports": 0, "bathrooms": 3, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Um Al Fahm. It includes 5 rooms, 3 bathrooms, and 120.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": null, "qualityScore": 100, "verifiedOwner": false}, {"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "strategy": "AI", "objective": "RECOMMENDATION"}	{"model": "gpt-5.4", "scores": [{"score": 63, "reason": "hybrid fallback", "listingId": "cb288153-a8d4-4973-9435-75d98775f743"}, {"score": 53.65, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 56.699999999999996, "reason": "hybrid fallback", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 50.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 58.7, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 62.150000000000006, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 54.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 52.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 44.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:16:34.66
b5a1c5f6-b52b-443f-985f-d9530afe8692	/ai/neighborhood/summary	\N	\N	t	f	f	4149	{"city": "Um Al Fahm", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}	{"summary": "Um Al Fahm may be worth considering for people renting in Um Al Fahm. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-26 09:16:35.106
9556dc6b-71b5-43bf-a7a6-d8af4289688b	/ai/ranking/listings	openai	gpt-5.4	t	t	f	4628	{"viewer": {"maxArea": 91.125, "minArea": 43.875, "maxPrice": 108000, "minPrice": 52000, "preferredModes": ["RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tbilisi"]}, "listings": [{"id": "cb288153-a8d4-4973-9435-75d98775f743", "area": 120, "city": "Um Al Fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 140000, "rooms": 5, "title": "Apartment in Um Al Fahm", "views": 0, "reports": 0, "bathrooms": 3, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Um Al Fahm. It includes 5 rooms, 3 bathrooms, and 120.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": null, "qualityScore": 100, "verifiedOwner": false}, {"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "strategy": "AI", "objective": "RECOMMENDATION"}	{"model": "gpt-5.4", "scores": [{"score": 63, "reason": "hybrid fallback", "listingId": "cb288153-a8d4-4973-9435-75d98775f743"}, {"score": 53.65, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 56.699999999999996, "reason": "hybrid fallback", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 50.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 58.7, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 62.150000000000006, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 54.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 52.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 44.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:16:35.621
7744d7c9-f0b3-4f6f-b3d1-bcb08a68b859	/ai/content/listing	\N	\N	t	f	f	3814	{"area": 95, "city": "Tblisi", "mode": "RENT", "price": 90000, "rooms": 4, "title": "Apartment2", "language": "en", "bathrooms": 2, "neighborhood": "Green", "property_type": "APARTMENT"}	{"cta": "Contact the owner to schedule a viewing.", "title": "Apartment in Green", "language": "en", "description": "This listing offers a practical option in Green. It includes 4 rooms, 2 bathrooms, and 95.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent."}	\N	2026-04-26 09:17:55.609
ea67fab7-6152-4937-8367-39feaad8d434	/ai/content/quality	\N	\N	t	f	f	3680	{"area": 95, "city": "Tblisi", "mode": "RENT", "price": 90000, "rooms": 4, "title": "Apartment in Green", "bathrooms": 2, "description": "This listing offers a practical option in Green. It includes 4 rooms, 2 bathrooms, and 95.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "image_count": 2, "neighborhood": "Green", "property_type": "APARTMENT"}	{"level": "excellent", "score": 95, "strengths": ["Title length is healthy.", "Description has enough depth for buyers.", "City is present.", "Price is clear."], "risk_flags": ["Low photo count can make the listing look suspicious."], "suggestions": ["Add more photos to build trust."], "duplicate_risk": "low", "owner_suggestions": []}	\N	2026-04-26 09:18:10.815
820ab687-9947-47f7-ae15-d8ba42c4a0ba	/ai/content/listing	\N	\N	t	f	f	3999	{"area": 95, "city": "Tblisi", "mode": "SALE", "price": 90000, "rooms": 4, "title": "Apartment in Green", "language": "en", "bathrooms": 2, "description": "This listing offers a practical option in Green. It includes 4 rooms, 2 bathrooms, and 95.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": "Green", "property_type": "APARTMENT"}	{"cta": "Contact the owner to learn more.", "title": "Apartment in Green", "language": "en", "description": "This listing offers a practical option in Green. It includes 4 rooms, 2 bathrooms, and 95.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for sale."}	\N	2026-04-26 09:18:18.072
9dbd7e22-923e-41c2-b2f0-64cc62d9d916	/ai/neighborhood/summary	\N	\N	t	f	f	3801	{"city": "Tblisi", "mode": "SALE", "listing_type": "APARTMENT", "neighborhood": "Green"}	{"summary": "Green may be worth considering for people buying in Tblisi. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-26 09:18:26.165
06e3a7c4-3f9b-45d4-9419-14e33d173558	/ai/neighborhood/summary	\N	\N	t	f	f	4269	{"city": "Tblisi", "mode": "SALE", "listing_type": "APARTMENT", "neighborhood": "Green"}	{"summary": "Green may be worth considering for people buying in Tblisi. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-26 09:18:26.668
de5f0b04-28a5-4376-a9b5-6571d3c9d5f9	/ai/ranking/listings	openai	gpt-5.4	t	t	f	4485	{"viewer": {"maxArea": 114.75000000000001, "minArea": 55.25, "maxPrice": 135000, "minPrice": 65000, "preferredModes": ["RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Um Al Fahm", "Tbilisi"]}, "listings": [{"id": "36ffa8d9-dd90-414d-b257-db98e4a90f70", "area": 95, "city": "Tblisi", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 90000, "rooms": 4, "title": "Apartment in Green", "views": 0, "reports": 0, "bathrooms": 2, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 4 rooms, 2 bathrooms, and 95.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for sale.\\n\\nContact the owner to learn more.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "strategy": "AI", "objective": "RECOMMENDATION"}	{"model": "gpt-5.4", "scores": [{"score": 69, "reason": "hybrid fallback", "listingId": "36ffa8d9-dd90-414d-b257-db98e4a90f70"}, {"score": 59.650000000000006, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 66.7, "reason": "city preference", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 50.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 58.7, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 62.150000000000006, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 54.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 56.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 40.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:18:26.975
e31c5923-82dc-4f58-bc4f-44c4063af908	/ai/ranking/listings	openai	gpt-5.4	t	t	f	3817	{"viewer": {"maxArea": 118.12500000000001, "minArea": 56.875, "maxPrice": 131625, "minPrice": 63375, "preferredModes": ["SALE", "RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tblisi", "Um Al Fahm", "Tbilisi"]}, "listings": [{"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "c901de33-674a-444d-8892-259897e9e4a9", "area": 125, "city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "leads": 2, "price": 120000, "rooms": 5, "title": "Modern property with strong potential", "views": 25, "reports": 0, "bathrooms": 3, "favorites": 2, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "strategy": "AI", "objective": "RECOMMENDATION"}	{"model": "gpt-5.4", "scores": [{"score": 59.650000000000006, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 57.800000000000004, "reason": "hybrid fallback", "listingId": "c901de33-674a-444d-8892-259897e9e4a9"}, {"score": 70.7, "reason": "city preference", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 50.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 58.7, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 62.150000000000006, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 54.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 56.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 40.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:18:30.065
6737829d-adbc-435f-9d0d-988ffdd0d3a3	/ai/ranking/listings	openai	gpt-5.4	t	t	f	4161	{"viewer": {"maxArea": 118.12500000000001, "minArea": 56.875, "maxPrice": 131625, "minPrice": 63375, "preferredModes": ["SALE", "RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tblisi", "Um Al Fahm", "Tbilisi"]}, "listings": [{"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "c901de33-674a-444d-8892-259897e9e4a9", "area": 125, "city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "leads": 2, "price": 120000, "rooms": 5, "title": "Modern property with strong potential", "views": 25, "reports": 0, "bathrooms": 3, "favorites": 2, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "strategy": "AI", "objective": "RECOMMENDATION"}	{"model": "gpt-5.4", "scores": [{"score": 59.650000000000006, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 57.800000000000004, "reason": "hybrid fallback", "listingId": "c901de33-674a-444d-8892-259897e9e4a9"}, {"score": 70.7, "reason": "city preference", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 50.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 58.7, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 62.150000000000006, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 54.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 56.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 40.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:18:30.445
25cc2f6a-4804-4616-9fd2-7348011a7765	/ai/ranking/listings	openai	gpt-5.4	t	t	f	16534	{"viewer": {"maxArea": 114.75000000000001, "minArea": 55.25, "maxPrice": 135000, "minPrice": 65000, "preferredModes": ["RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Um Al Fahm", "Tbilisi"]}, "listings": [{"id": "36ffa8d9-dd90-414d-b257-db98e4a90f70", "area": 95, "city": "Tblisi", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 90000, "rooms": 4, "title": "Apartment in Green", "views": 0, "reports": 0, "bathrooms": 2, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 4 rooms, 2 bathrooms, and 95.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for sale.\\n\\nContact the owner to learn more.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "strategy": "AI", "objective": "RECOMMENDATION"}	{"model": "gpt-5.4", "scores": [{"score": 69, "reason": "hybrid fallback", "listingId": "36ffa8d9-dd90-414d-b257-db98e4a90f70"}, {"score": 59.650000000000006, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 66.7, "reason": "city preference", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 50.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 58.7, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 62.150000000000006, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 54.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 56.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 40.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:18:39.014
3ef3794e-539f-450b-b22a-5ce92093ee72	/ai/ranking/listings	openai	gpt-5.4	t	t	f	3641	{"viewer": {"maxArea": 126.9, "minArea": 61.1, "maxPrice": 143100, "minPrice": 68900, "preferredModes": ["SALE", "RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tblisi", "Um Al Fahm", "Tbilisi"]}, "listings": [{"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "c901de33-674a-444d-8892-259897e9e4a9", "area": 125, "city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "leads": 2, "price": 120000, "rooms": 5, "title": "Modern property with strong potential", "views": 25, "reports": 0, "bathrooms": 3, "favorites": 2, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "strategy": "AI", "objective": "RECOMMENDATION"}	{"model": "gpt-5.4", "scores": [{"score": 59.650000000000006, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 61.8, "reason": "hybrid fallback", "listingId": "c901de33-674a-444d-8892-259897e9e4a9"}, {"score": 70.7, "reason": "city preference", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 50.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 58.7, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 62.150000000000006, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 54.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 56.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 40.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:19:30.048
87e686df-b089-49f8-a21b-7d63f478bff8	/ai/ranking/listings	openai	gpt-5.4	t	t	f	4357	{"viewer": {"maxArea": 126.9, "minArea": 61.1, "maxPrice": 143100, "minPrice": 68900, "preferredModes": ["SALE", "RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tblisi", "Um Al Fahm", "Tbilisi"]}, "listings": [{"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "c901de33-674a-444d-8892-259897e9e4a9", "area": 125, "city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "leads": 2, "price": 120000, "rooms": 5, "title": "Modern property with strong potential", "views": 25, "reports": 0, "bathrooms": 3, "favorites": 2, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "strategy": "AI", "objective": "RECOMMENDATION"}	{"model": "gpt-5.4", "scores": [{"score": 59.650000000000006, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 61.8, "reason": "hybrid fallback", "listingId": "c901de33-674a-444d-8892-259897e9e4a9"}, {"score": 70.7, "reason": "city preference", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 50.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 58.7, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 62.150000000000006, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 54.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 56.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 40.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-26 09:19:30.808
8ab792d4-bdd4-495e-b4ff-60d4ffc84166	/ai/ranking/listings	openai	gpt-5.4	t	t	f	5686	{"filters": {}, "listings": [{"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "c901de33-674a-444d-8892-259897e9e4a9", "area": 125, "city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "leads": 2, "price": 120000, "rooms": 5, "title": "Modern property with strong potential", "views": 25, "reports": 0, "bathrooms": 3, "favorites": 2, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "36ffa8d9-dd90-414d-b257-db98e4a90f70", "area": 95, "city": "Tblisi", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 90000, "rooms": 4, "title": "Apartment in Green", "views": 1, "reports": 0, "bathrooms": 2, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 4 rooms, 2 bathrooms, and 95.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for sale.\\n\\nContact the owner to learn more.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "cb288153-a8d4-4973-9435-75d98775f743", "area": 120, "city": "Um Al Fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 140000, "rooms": 5, "title": "Apartment in Um Al Fahm", "views": 1, "reports": 0, "bathrooms": 3, "favorites": 1, "imageCount": 2, "description": "This listing offers a practical option in Um Al Fahm. It includes 5 rooms, 3 bathrooms, and 120.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": null, "qualityScore": 100, "verifiedOwner": false}, {"id": "7f8bd3c9-8044-4ac4-bce0-9934871cc100", "area": 80, "city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 90000, "rooms": 3, "title": "Apartment in Green", "views": 1, "reports": 0, "bathrooms": 2, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 3 rooms, 2 bathrooms, and 80.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "959feec8-ec17-4e75-8d29-af4f57913c84", "area": 55, "city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 70000, "rooms": 2, "title": "Apartment1 in Green", "views": 1, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 2 rooms, 1 bathrooms, and 55.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "objective": "SEARCH"}	{"model": "gpt-5.4", "scores": [{"score": 48.15, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 40.699999999999996, "reason": "hybrid fallback", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 45.65, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 47.800000000000004, "reason": "hybrid fallback", "listingId": "c901de33-674a-444d-8892-259897e9e4a9"}, {"score": 53.15, "reason": "hybrid fallback", "listingId": "36ffa8d9-dd90-414d-b257-db98e4a90f70"}, {"score": 53.949999999999996, "reason": "hybrid fallback", "listingId": "cb288153-a8d4-4973-9435-75d98775f743"}, {"score": 53.15, "reason": "hybrid fallback", "listingId": "7f8bd3c9-8044-4ac4-bce0-9934871cc100"}, {"score": 53.15, "reason": "hybrid fallback", "listingId": "959feec8-ec17-4e75-8d29-af4f57913c84"}, {"score": 40.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 44.699999999999996, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 40.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 42.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 30.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-27 11:33:01.756
b4e0247c-fe38-439b-944d-62eee1c651b9	/ai/ranking/listings	openai	gpt-5.4	t	t	f	5721	{"filters": {}, "listings": [{"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "c901de33-674a-444d-8892-259897e9e4a9", "area": 125, "city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "leads": 2, "price": 120000, "rooms": 5, "title": "Modern property with strong potential", "views": 25, "reports": 0, "bathrooms": 3, "favorites": 2, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "36ffa8d9-dd90-414d-b257-db98e4a90f70", "area": 95, "city": "Tblisi", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 90000, "rooms": 4, "title": "Apartment in Green", "views": 1, "reports": 0, "bathrooms": 2, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 4 rooms, 2 bathrooms, and 95.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for sale.\\n\\nContact the owner to learn more.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "cb288153-a8d4-4973-9435-75d98775f743", "area": 120, "city": "Um Al Fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 140000, "rooms": 5, "title": "Apartment in Um Al Fahm", "views": 1, "reports": 0, "bathrooms": 3, "favorites": 1, "imageCount": 2, "description": "This listing offers a practical option in Um Al Fahm. It includes 5 rooms, 3 bathrooms, and 120.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": null, "qualityScore": 100, "verifiedOwner": false}, {"id": "7f8bd3c9-8044-4ac4-bce0-9934871cc100", "area": 80, "city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 90000, "rooms": 3, "title": "Apartment in Green", "views": 1, "reports": 0, "bathrooms": 2, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 3 rooms, 2 bathrooms, and 80.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "959feec8-ec17-4e75-8d29-af4f57913c84", "area": 55, "city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 70000, "rooms": 2, "title": "Apartment1 in Green", "views": 1, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 2 rooms, 1 bathrooms, and 55.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "objective": "SEARCH"}	{"model": "gpt-5.4", "scores": [{"score": 48.15, "reason": "hybrid fallback", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}, {"score": 40.699999999999996, "reason": "hybrid fallback", "listingId": "9cc14069-c507-44df-900b-3833cea37ead"}, {"score": 45.65, "reason": "trust penalty", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}, {"score": 47.800000000000004, "reason": "hybrid fallback", "listingId": "c901de33-674a-444d-8892-259897e9e4a9"}, {"score": 53.15, "reason": "hybrid fallback", "listingId": "36ffa8d9-dd90-414d-b257-db98e4a90f70"}, {"score": 53.949999999999996, "reason": "hybrid fallback", "listingId": "cb288153-a8d4-4973-9435-75d98775f743"}, {"score": 53.15, "reason": "hybrid fallback", "listingId": "7f8bd3c9-8044-4ac4-bce0-9934871cc100"}, {"score": 53.15, "reason": "hybrid fallback", "listingId": "959feec8-ec17-4e75-8d29-af4f57913c84"}, {"score": 40.849999999999994, "reason": "hybrid fallback", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 44.699999999999996, "reason": "hybrid fallback", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 40.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 42.300000000000004, "reason": "hybrid fallback", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 30.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-27 11:33:01.764
d29e09d1-50d8-46f8-a1f4-50b6ad4926a4	/ai/ranking/listings	\N	\N	f	f	f	68	{"filters": {}, "listings": [{"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "c901de33-674a-444d-8892-259897e9e4a9", "area": 125, "city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "leads": 2, "price": 120000, "rooms": 5, "title": "Modern property with strong potential", "views": 25, "reports": 0, "bathrooms": 3, "favorites": 2, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "36ffa8d9-dd90-414d-b257-db98e4a90f70", "area": 95, "city": "Tblisi", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 90000, "rooms": 4, "title": "Apartment in Green", "views": 1, "reports": 0, "bathrooms": 2, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 4 rooms, 2 bathrooms, and 95.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for sale.\\n\\nContact the owner to learn more.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "cb288153-a8d4-4973-9435-75d98775f743", "area": 120, "city": "Um Al Fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 140000, "rooms": 5, "title": "Apartment in Um Al Fahm", "views": 1, "reports": 0, "bathrooms": 3, "favorites": 1, "imageCount": 2, "description": "This listing offers a practical option in Um Al Fahm. It includes 5 rooms, 3 bathrooms, and 120.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": null, "qualityScore": 100, "verifiedOwner": false}, {"id": "7f8bd3c9-8044-4ac4-bce0-9934871cc100", "area": 80, "city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 90000, "rooms": 3, "title": "Apartment in Green", "views": 1, "reports": 0, "bathrooms": 2, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 3 rooms, 2 bathrooms, and 80.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "959feec8-ec17-4e75-8d29-af4f57913c84", "area": 55, "city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 70000, "rooms": 2, "title": "Apartment1 in Green", "views": 1, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 2 rooms, 1 bathrooms, and 55.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "objective": "SEARCH"}	{"message": "Internal AI service error", "success": false}	AI service failed	2026-04-27 11:33:07.376
a2d81902-bf8f-4100-96ca-85bdf05c649b	/ai/ranking/listings	\N	\N	f	f	f	55	{"filters": {}, "listings": [{"id": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "area": 80, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 2, "price": 150000, "rooms": 5, "title": "Home", "views": 37, "reports": 0, "bathrooms": 2, "favorites": 3, "imageCount": 0, "description": ".", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "9cc14069-c507-44df-900b-3833cea37ead", "area": 70, "city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 80000, "rooms": 4, "title": "Modern property with strong potential", "views": 12, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 66, "verifiedOwner": false}, {"id": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "area": 80, "city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "leads": 1, "price": 110000, "rooms": 4, "title": "Modern property with strong potential", "views": 10, "reports": 1, "bathrooms": 2, "favorites": 1, "imageCount": 3, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "c901de33-674a-444d-8892-259897e9e4a9", "area": 125, "city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "leads": 2, "price": 120000, "rooms": 5, "title": "Modern property with strong potential", "views": 25, "reports": 0, "bathrooms": 3, "favorites": 2, "imageCount": 0, "description": "This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\\n\\nContact the owner today to learn more.", "neighborhood": null, "qualityScore": 75, "verifiedOwner": false}, {"id": "36ffa8d9-dd90-414d-b257-db98e4a90f70", "area": 95, "city": "Tblisi", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 90000, "rooms": 4, "title": "Apartment in Green", "views": 1, "reports": 0, "bathrooms": 2, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 4 rooms, 2 bathrooms, and 95.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for sale.\\n\\nContact the owner to learn more.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "cb288153-a8d4-4973-9435-75d98775f743", "area": 120, "city": "Um Al Fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 140000, "rooms": 5, "title": "Apartment in Um Al Fahm", "views": 1, "reports": 0, "bathrooms": 3, "favorites": 1, "imageCount": 2, "description": "This listing offers a practical option in Um Al Fahm. It includes 5 rooms, 3 bathrooms, and 120.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": null, "qualityScore": 100, "verifiedOwner": false}, {"id": "7f8bd3c9-8044-4ac4-bce0-9934871cc100", "area": 80, "city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 90000, "rooms": 3, "title": "Apartment in Green", "views": 1, "reports": 0, "bathrooms": 2, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 3 rooms, 2 bathrooms, and 80.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "959feec8-ec17-4e75-8d29-af4f57913c84", "area": 55, "city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 70000, "rooms": 2, "title": "Apartment1 in Green", "views": 1, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 2 rooms, 1 bathrooms, and 55.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "objective": "SEARCH"}	{"message": "Internal AI service error", "success": false}	AI service failed	2026-04-27 11:33:07.499
51921042-6e80-438f-b0ac-bba3808867ca	/ai/neighborhood/summary	\N	\N	t	f	f	3865	{"city": "Tel Aviv", "mode": "RENT", "listing_type": "HOUSE", "neighborhood": null}	{"summary": "Tel Aviv may be worth considering for people renting in Tel Aviv. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-27 11:33:31.682
7c6ae181-22dd-46fc-8921-593182f6a0ff	/ai/ranking/listings	openai	gpt-5.4	t	t	f	4258	{"viewer": {"maxArea": 135.84375, "minArea": 65.40625, "maxPrice": 160312.5, "minPrice": 77187.5, "preferredModes": ["RENT", "SALE"], "preferredTypes": ["HOUSE", "APARTMENT"], "preferredCities": ["Tel Aviv", "Um Al Fahm", "Haifa"]}, "listings": [{"id": "36ffa8d9-dd90-414d-b257-db98e4a90f70", "area": 95, "city": "Tblisi", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 90000, "rooms": 4, "title": "Apartment in Green", "views": 1, "reports": 0, "bathrooms": 2, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 4 rooms, 2 bathrooms, and 95.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for sale.\\n\\nContact the owner to learn more.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "7f8bd3c9-8044-4ac4-bce0-9934871cc100", "area": 80, "city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 90000, "rooms": 3, "title": "Apartment in Green", "views": 1, "reports": 0, "bathrooms": 2, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 3 rooms, 2 bathrooms, and 80.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "959feec8-ec17-4e75-8d29-af4f57913c84", "area": 55, "city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 70000, "rooms": 2, "title": "Apartment1 in Green", "views": 1, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 2 rooms, 1 bathrooms, and 55.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "strategy": "BEHAVIOR", "objective": "RECOMMENDATION"}	{"model": "gpt-5.4", "scores": [{"score": 73.15, "reason": "hybrid fallback", "listingId": "36ffa8d9-dd90-414d-b257-db98e4a90f70"}, {"score": 73.15, "reason": "hybrid fallback", "listingId": "7f8bd3c9-8044-4ac4-bce0-9934871cc100"}, {"score": 63.15, "reason": "hybrid fallback", "listingId": "959feec8-ec17-4e75-8d29-af4f57913c84"}, {"score": 60.85000000000001, "reason": "city preference", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 68.69999999999999, "reason": "city preference", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 54.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 66.3, "reason": "city preference", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 40.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-27 11:33:32.239
1cc082cd-5a6b-4979-9924-cbbf1aa83341	/ai/ranking/listings	openai	gpt-5.4	t	t	f	4999	{"viewer": {"maxArea": 135.84375, "minArea": 65.40625, "maxPrice": 160312.5, "minPrice": 77187.5, "preferredModes": ["RENT", "SALE"], "preferredTypes": ["HOUSE", "APARTMENT"], "preferredCities": ["Tel Aviv", "Um Al Fahm", "Haifa"]}, "listings": [{"id": "36ffa8d9-dd90-414d-b257-db98e4a90f70", "area": 95, "city": "Tblisi", "mode": "SALE", "type": "APARTMENT", "leads": 0, "price": 90000, "rooms": 4, "title": "Apartment in Green", "views": 1, "reports": 0, "bathrooms": 2, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 4 rooms, 2 bathrooms, and 95.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for sale.\\n\\nContact the owner to learn more.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "7f8bd3c9-8044-4ac4-bce0-9934871cc100", "area": 80, "city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 90000, "rooms": 3, "title": "Apartment in Green", "views": 1, "reports": 0, "bathrooms": 2, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 3 rooms, 2 bathrooms, and 80.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "959feec8-ec17-4e75-8d29-af4f57913c84", "area": 55, "city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 70000, "rooms": 2, "title": "Apartment1 in Green", "views": 1, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 2, "description": "This listing offers a practical option in Green. It includes 2 rooms, 1 bathrooms, and 55.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\\n\\nContact the owner to schedule a viewing.", "neighborhood": "Green", "qualityScore": 100, "verifiedOwner": false}, {"id": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543", "area": 40, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 400, "rooms": 2, "title": "HH", "views": 6, "reports": 0, "bathrooms": 1, "favorites": 0, "imageCount": 0, "description": "A", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}, {"id": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7", "area": 66, "city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "leads": 3, "price": 5000, "rooms": 4, "title": "home1", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "c161f02d-7d64-47bd-8412-424d48166b15", "area": 70, "city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6000, "rooms": 4, "title": "homee", "views": 12, "reports": 0, "bathrooms": 2, "favorites": 1, "imageCount": 0, "description": "a", "neighborhood": null, "qualityScore": 60, "verifiedOwner": false}, {"id": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "area": 110, "city": "Haifa", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 7777, "rooms": 3, "title": "Codex Test Listing", "views": 3, "reports": 0, "bathrooms": 2, "favorites": 2, "imageCount": 0, "description": "Created during verification", "neighborhood": "Downtown", "qualityScore": 75, "verifiedOwner": false}, {"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "leads": 0, "price": 6600, "rooms": 2, "title": "Home1", "views": 1, "reports": 1, "bathrooms": 1, "favorites": 1, "imageCount": 0, "description": "", "neighborhood": null, "qualityScore": 51, "verifiedOwner": false}], "strategy": "BEHAVIOR", "objective": "RECOMMENDATION"}	{"model": "gpt-5.4", "scores": [{"score": 73.15, "reason": "hybrid fallback", "listingId": "36ffa8d9-dd90-414d-b257-db98e4a90f70"}, {"score": 73.15, "reason": "hybrid fallback", "listingId": "7f8bd3c9-8044-4ac4-bce0-9934871cc100"}, {"score": 63.15, "reason": "hybrid fallback", "listingId": "959feec8-ec17-4e75-8d29-af4f57913c84"}, {"score": 60.85000000000001, "reason": "city preference", "listingId": "9cd6f7ba-e28a-456c-8ad6-3edce35a4543"}, {"score": 68.69999999999999, "reason": "city preference", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}, {"score": 54.599999999999994, "reason": "hybrid fallback", "listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}, {"score": 66.3, "reason": "city preference", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}, {"score": 40.599999999999994, "reason": "trust penalty", "listingId": "41367728-e8a5-4232-8a08-520075bc6859"}], "cacheHit": false, "provider": "openai", "fallbackUsed": true}	\N	2026-04-27 11:33:32.877
99202a9e-55c5-400e-a371-501b55132c65	/ai/neighborhood/summary	\N	\N	t	f	f	5183	{"city": "Tel Aviv", "mode": "RENT", "listing_type": "HOUSE", "neighborhood": null}	{"summary": "Tel Aviv may be worth considering for people renting in Tel Aviv. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}	\N	2026-04-27 11:33:33.016
\.


--
-- Data for Name: AuditLog; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."AuditLog" (id, "actorUserId", "targetType", "targetId", action, "beforeJson", "afterJson", "metadataJson", "createdAt") FROM stdin;
6690a2e7-4e9c-4e37-a496-675743498b23	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	listing	41367728-e8a5-4232-8a08-520075bc6859	LISTING_STATUS_UPDATED	{"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "image": "", "price": 6600, "rooms": 2, "title": "Home1", "status": "PUBLISHED", "bathrooms": 1, "createdAt": "2026-04-09T14:20:29.387Z", "updatedAt": "2026-04-21T21:13:38.416Z", "createdById": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "description": "", "boostedUntil": null, "neighborhood": null, "featuredUntil": null}	{"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "image": "", "price": 6600, "rooms": 2, "title": "Home1", "status": "ARCHIVED", "bathrooms": 1, "createdAt": "2026-04-09T14:20:29.387Z", "updatedAt": "2026-04-23T17:00:40.042Z", "createdById": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "description": "", "boostedUntil": null, "neighborhood": null, "featuredUntil": null}	{"status": "ARCHIVED"}	2026-04-23 17:00:40.052
5ba0d1c9-3448-4653-b404-75c036922bd0	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	listing	41367728-e8a5-4232-8a08-520075bc6859	LISTING_STATUS_UPDATED	{"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "image": "", "price": 6600, "rooms": 2, "title": "Home1", "status": "ARCHIVED", "bathrooms": 1, "createdAt": "2026-04-09T14:20:29.387Z", "updatedAt": "2026-04-23T17:00:40.042Z", "createdById": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "description": "", "boostedUntil": null, "neighborhood": null, "featuredUntil": null}	{"id": "41367728-e8a5-4232-8a08-520075bc6859", "area": 50, "city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "image": "", "price": 6600, "rooms": 2, "title": "Home1", "status": "PUBLISHED", "bathrooms": 1, "createdAt": "2026-04-09T14:20:29.387Z", "updatedAt": "2026-04-23T17:01:25.080Z", "createdById": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "description": "", "boostedUntil": null, "neighborhood": null, "featuredUntil": null}	{"status": "PUBLISHED"}	2026-04-23 17:01:25.086
382080d9-532e-4411-8d8e-640705852248	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	ai_request_feedback	4bfd5858-3717-46d9-88b6-a6db6a21f9c5	AI_FEEDBACK_UPDATED	null	{"id": "3867d13d-e077-4b71-9eab-109e302bb160", "model": null, "approval": null, "endpoint": "/ai/content/listing", "provider": null, "createdAt": "2026-04-24T21:54:38.458Z", "inputJson": {"mode": "RENT", "language": "en", "property_type": "APARTMENT"}, "latencyMs": 3355, "updatedAt": "2026-04-24T21:54:38.458Z", "outputJson": {"cta": "Contact the owner to schedule a viewing.", "title": "Apartment in a convenient location", "language": "en", "description": "This listing offers a practical option in the area. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent."}, "usefulness": "USEFUL", "actorUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "correctness": null, "fallbackUsed": false, "requestLogId": "4bfd5858-3717-46d9-88b6-a6db6a21f9c5", "reviewerNote": null}	{"model": null, "endpoint": "/ai/content/listing", "provider": null}	2026-04-24 21:54:38.477
2385c308-16f8-4a34-b9f6-c75e349b8607	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	ai_request_feedback	ba07bf2b-622a-4213-bf41-e4ba3be5a1f7	AI_FEEDBACK_UPDATED	null	{"id": "f599bb25-9f01-47c6-a1c0-b527cae07bf7", "model": null, "approval": null, "endpoint": "/ai/neighborhood/summary", "provider": null, "createdAt": "2026-04-25T13:48:00.194Z", "inputJson": {"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}, "latencyMs": 3216, "updatedAt": "2026-04-25T13:48:00.194Z", "outputJson": {"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}, "usefulness": "USEFUL", "actorUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "correctness": null, "fallbackUsed": false, "requestLogId": "ba07bf2b-622a-4213-bf41-e4ba3be5a1f7", "reviewerNote": null, "expectedOutputJson": null}	{"model": null, "endpoint": "/ai/neighborhood/summary", "provider": null}	2026-04-25 13:48:00.206
ef6fead0-c94d-4d44-9074-df138e8bfac7	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	ai_request_feedback	ba07bf2b-622a-4213-bf41-e4ba3be5a1f7	AI_FEEDBACK_UPDATED	{"id": "f599bb25-9f01-47c6-a1c0-b527cae07bf7", "model": null, "approval": null, "endpoint": "/ai/neighborhood/summary", "provider": null, "createdAt": "2026-04-25T13:48:00.194Z", "inputJson": {"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}, "latencyMs": 3216, "updatedAt": "2026-04-25T13:48:00.194Z", "outputJson": {"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}, "usefulness": "USEFUL", "actorUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "correctness": null, "fallbackUsed": false, "requestLogId": "ba07bf2b-622a-4213-bf41-e4ba3be5a1f7", "reviewerNote": null, "expectedOutputJson": null}	{"id": "f599bb25-9f01-47c6-a1c0-b527cae07bf7", "model": null, "approval": null, "endpoint": "/ai/neighborhood/summary", "provider": null, "createdAt": "2026-04-25T13:48:00.194Z", "inputJson": {"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}, "latencyMs": 3216, "updatedAt": "2026-04-25T13:48:01.356Z", "outputJson": {"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}, "usefulness": "USEFUL", "actorUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "correctness": "CORRECT", "fallbackUsed": false, "requestLogId": "ba07bf2b-622a-4213-bf41-e4ba3be5a1f7", "reviewerNote": null, "expectedOutputJson": null}	{"model": null, "endpoint": "/ai/neighborhood/summary", "provider": null}	2026-04-25 13:48:01.367
857cce42-a904-4a17-9428-0af08e69a14f	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	ai_request_feedback	ba07bf2b-622a-4213-bf41-e4ba3be5a1f7	AI_FEEDBACK_UPDATED	{"id": "f599bb25-9f01-47c6-a1c0-b527cae07bf7", "model": null, "approval": null, "endpoint": "/ai/neighborhood/summary", "provider": null, "createdAt": "2026-04-25T13:48:00.194Z", "inputJson": {"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}, "latencyMs": 3216, "updatedAt": "2026-04-25T13:48:01.356Z", "outputJson": {"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}, "usefulness": "USEFUL", "actorUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "correctness": "CORRECT", "fallbackUsed": false, "requestLogId": "ba07bf2b-622a-4213-bf41-e4ba3be5a1f7", "reviewerNote": null, "expectedOutputJson": null}	{"id": "f599bb25-9f01-47c6-a1c0-b527cae07bf7", "model": null, "approval": null, "endpoint": "/ai/neighborhood/summary", "provider": null, "createdAt": "2026-04-25T13:48:00.194Z", "inputJson": {"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}, "latencyMs": 3216, "updatedAt": "2026-04-25T13:48:10.317Z", "outputJson": {"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}, "usefulness": "USEFUL", "actorUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "correctness": "CORRECT", "fallbackUsed": false, "requestLogId": "ba07bf2b-622a-4213-bf41-e4ba3be5a1f7", "reviewerNote": null, "expectedOutputJson": null}	{"model": null, "endpoint": "/ai/neighborhood/summary", "provider": null}	2026-04-25 13:48:10.322
2e8a4be5-5137-48c1-a91e-8d6f08cf90c9	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	ai_request_feedback	ba07bf2b-622a-4213-bf41-e4ba3be5a1f7	AI_FEEDBACK_UPDATED	{"id": "f599bb25-9f01-47c6-a1c0-b527cae07bf7", "model": null, "approval": null, "endpoint": "/ai/neighborhood/summary", "provider": null, "createdAt": "2026-04-25T13:48:00.194Z", "inputJson": {"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}, "latencyMs": 3216, "updatedAt": "2026-04-25T13:48:10.317Z", "outputJson": {"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}, "usefulness": "USEFUL", "actorUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "correctness": "CORRECT", "fallbackUsed": false, "requestLogId": "ba07bf2b-622a-4213-bf41-e4ba3be5a1f7", "reviewerNote": null, "expectedOutputJson": null}	{"id": "f599bb25-9f01-47c6-a1c0-b527cae07bf7", "model": null, "approval": null, "endpoint": "/ai/neighborhood/summary", "provider": null, "createdAt": "2026-04-25T13:48:00.194Z", "inputJson": {"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}, "latencyMs": 3216, "updatedAt": "2026-04-25T13:48:12.955Z", "outputJson": {"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}, "usefulness": "USEFUL", "actorUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "correctness": "CORRECT", "fallbackUsed": false, "requestLogId": "ba07bf2b-622a-4213-bf41-e4ba3be5a1f7", "reviewerNote": null, "expectedOutputJson": null}	{"model": null, "endpoint": "/ai/neighborhood/summary", "provider": null}	2026-04-25 13:48:12.96
51429c01-6fee-4069-810f-c578035409a5	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	ai_request_feedback	4bfd5858-3717-46d9-88b6-a6db6a21f9c5	AI_FEEDBACK_UPDATED	{"id": "3867d13d-e077-4b71-9eab-109e302bb160", "model": null, "approval": null, "endpoint": "/ai/content/listing", "provider": null, "createdAt": "2026-04-24T21:54:38.458Z", "inputJson": {"mode": "RENT", "language": "en", "property_type": "APARTMENT"}, "latencyMs": 3355, "updatedAt": "2026-04-24T21:54:38.458Z", "outputJson": {"cta": "Contact the owner to schedule a viewing.", "title": "Apartment in a convenient location", "language": "en", "description": "This listing offers a practical option in the area. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent."}, "usefulness": "USEFUL", "actorUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "correctness": null, "fallbackUsed": false, "requestLogId": "4bfd5858-3717-46d9-88b6-a6db6a21f9c5", "reviewerNote": null, "expectedOutputJson": null}	{"id": "3867d13d-e077-4b71-9eab-109e302bb160", "model": null, "approval": null, "endpoint": "/ai/content/listing", "provider": null, "createdAt": "2026-04-24T21:54:38.458Z", "inputJson": {"mode": "RENT", "language": "en", "property_type": "APARTMENT"}, "latencyMs": 3355, "updatedAt": "2026-04-25T13:48:25.990Z", "outputJson": {"cta": "Contact the owner to schedule a viewing.", "title": "Apartment in a convenient location", "language": "en", "description": "This listing offers a practical option in the area. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent."}, "usefulness": "USEFUL", "actorUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "correctness": null, "fallbackUsed": false, "requestLogId": "4bfd5858-3717-46d9-88b6-a6db6a21f9c5", "reviewerNote": null, "expectedOutputJson": {}}	{"model": null, "endpoint": "/ai/content/listing", "provider": null}	2026-04-25 13:48:25.996
41973fcd-2ba1-451c-861e-2b191e4c14ed	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	ai_request_feedback	345af401-6788-4577-b479-e328cdb7599d	AI_FEEDBACK_UPDATED	null	{"id": "a653133e-2307-46b1-922b-ebaa20cb043c", "model": null, "approval": "REJECT", "endpoint": "/ai/neighborhood/summary", "provider": null, "createdAt": "2026-04-25T13:49:42.638Z", "inputJson": {"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}, "latencyMs": 4084, "updatedAt": "2026-04-25T13:49:42.638Z", "outputJson": {"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}, "usefulness": null, "actorUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "correctness": null, "fallbackUsed": false, "requestLogId": "345af401-6788-4577-b479-e328cdb7599d", "reviewerNote": null, "expectedOutputJson": null}	{"model": null, "endpoint": "/ai/neighborhood/summary", "provider": null}	2026-04-25 13:49:42.646
ed92bccb-31a9-4640-b4c6-9b10033c82ae	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	ai_request_feedback	12004a18-d3b2-4ff7-88dc-9f2cdabe80b7	AI_FEEDBACK_UPDATED	null	{"id": "b21f45a4-39a6-48c2-97f4-7be255ee9020", "model": null, "approval": null, "endpoint": "/ai/neighborhood/summary", "provider": null, "createdAt": "2026-04-25T21:10:03.330Z", "inputJson": {"city": "Haifa", "mode": "RENT", "listing_type": "APARTMENT", "neighborhood": null}, "latencyMs": 4977, "updatedAt": "2026-04-25T21:10:03.330Z", "outputJson": {"summary": "Haifa may be worth considering for people renting in Haifa. Compare exact streets, transport access, building condition, parking, noise, and nearby daily services before deciding.", "cautions": ["This is an AI helper summary, not an official neighborhood report.", "Verify noise, commute time, fees, and exact surroundings manually."], "highlights": ["Check access to public transport and main roads.", "Compare nearby shops, schools, parks, and daily services.", "Review the building, street condition, and parking options."], "suitable_for": ["families", "commuters", "students"]}, "usefulness": null, "actorUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "correctness": "CORRECT", "fallbackUsed": false, "requestLogId": "12004a18-d3b2-4ff7-88dc-9f2cdabe80b7", "reviewerNote": null, "expectedOutputJson": null}	{"model": null, "endpoint": "/ai/neighborhood/summary", "provider": null}	2026-04-25 21:10:03.339
baf24e38-25ba-4761-8438-9c2fe443f1e9	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	ai_request_feedback	465e0b4c-7d2d-4d6d-a110-70c8f3026e8d	AI_FEEDBACK_UPDATED	null	{"id": "cf32e0cb-b3d7-48a5-b947-eb01ab96057a", "model": null, "approval": null, "endpoint": "/ai/search/parse", "provider": null, "createdAt": "2026-04-25T21:10:20.924Z", "inputJson": {"query": "شقة للطلاب في حيفا للايجار"}, "latencyMs": 4509, "updatedAt": "2026-04-25T21:10:20.924Z", "outputJson": {"filters": {"q": "students", "city": "Haifa", "mode": "RENT", "sort": "price_low", "type": "APARTMENT", "rooms": null, "maxArea": null, "minArea": null, "maxPrice": null, "minPrice": null, "bathrooms": null}, "confidence": 0.83, "explanation": "Parsed search intent with local fallback rules."}, "usefulness": "USEFUL", "actorUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "correctness": null, "fallbackUsed": false, "requestLogId": "465e0b4c-7d2d-4d6d-a110-70c8f3026e8d", "reviewerNote": null, "expectedOutputJson": null}	{"model": null, "endpoint": "/ai/search/parse", "provider": null}	2026-04-25 21:10:20.931
896b32ab-e271-46e1-9659-e2d409508680	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	ai_request_feedback	923f56eb-1650-4cf0-a4ae-858c821bba1e	AI_FEEDBACK_UPDATED	null	{"id": "83b1a72e-28dd-4233-97dd-e54aaed1411e", "model": null, "approval": null, "endpoint": "/ai/search/parse", "provider": null, "createdAt": "2026-04-25T21:10:22.259Z", "inputJson": {"query": "شقة للطلاب في حيفا"}, "latencyMs": 5992, "updatedAt": "2026-04-25T21:10:22.259Z", "outputJson": {"filters": {"q": "students", "city": "Haifa", "mode": null, "sort": "price_low", "type": "APARTMENT", "rooms": null, "maxArea": null, "minArea": null, "maxPrice": null, "minPrice": null, "bathrooms": null}, "confidence": 0.73, "explanation": "Parsed search intent with local fallback rules."}, "usefulness": null, "actorUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "correctness": "CORRECT", "fallbackUsed": false, "requestLogId": "923f56eb-1650-4cf0-a4ae-858c821bba1e", "reviewerNote": null, "expectedOutputJson": null}	{"model": null, "endpoint": "/ai/search/parse", "provider": null}	2026-04-25 21:10:22.268
7d98d97b-8667-4b4b-b574-dc22e8956e99	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	ai_request_feedback	03b05cf8-bb2f-47bc-9806-7a587be64778	AI_FEEDBACK_UPDATED	null	{"id": "74da0587-ac50-4a64-a800-b5751685f144", "model": null, "approval": null, "endpoint": "/ai/search/parse", "provider": null, "createdAt": "2026-04-25T21:10:29.186Z", "inputJson": {"query": "apartment in Haifa"}, "latencyMs": 4928, "updatedAt": "2026-04-25T21:10:29.186Z", "outputJson": {"filters": {"q": null, "city": "Haifa", "mode": null, "sort": null, "type": "APARTMENT", "rooms": null, "maxArea": null, "minArea": null, "maxPrice": null, "minPrice": null, "bathrooms": null}, "confidence": 0.65, "explanation": "Parsed search intent with local fallback rules."}, "usefulness": null, "actorUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "correctness": "CORRECT", "fallbackUsed": false, "requestLogId": "03b05cf8-bb2f-47bc-9806-7a587be64778", "reviewerNote": null, "expectedOutputJson": null}	{"model": null, "endpoint": "/ai/search/parse", "provider": null}	2026-04-25 21:10:29.193
8a3524e0-6697-4198-afc2-e9d09f9b95e9	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	ai_request_feedback	45d971cf-eb2f-40a1-bea1-e163b62e7f26	AI_FEEDBACK_UPDATED	null	{"id": "4addf63a-41e9-45fb-b9a7-d933b8354cfc", "model": null, "approval": null, "endpoint": "/ai/content/listing", "provider": null, "createdAt": "2026-04-25T21:10:30.306Z", "inputJson": {"mode": "RENT", "language": "en", "property_type": "APARTMENT"}, "latencyMs": 6551, "updatedAt": "2026-04-25T21:10:30.306Z", "outputJson": {"cta": "Contact the owner to schedule a viewing.", "title": "Apartment in a convenient location", "language": "en", "description": "This listing offers a practical option in the area. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent."}, "usefulness": "USEFUL", "actorUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "correctness": null, "fallbackUsed": false, "requestLogId": "45d971cf-eb2f-40a1-bea1-e163b62e7f26", "reviewerNote": null, "expectedOutputJson": null}	{"model": null, "endpoint": "/ai/content/listing", "provider": null}	2026-04-25 21:10:30.316
86b1d633-a416-4a8b-886a-8db6ad8f2551	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	ai_request_feedback	ca15fc8e-dcf6-44da-af85-a78c54bf1811	AI_FEEDBACK_UPDATED	null	{"id": "a9419a1f-ce5f-4b6d-a8b9-e30f877ccbb6", "model": null, "approval": null, "endpoint": "/ai/search/parse", "provider": null, "createdAt": "2026-04-25T21:10:46.129Z", "inputJson": {"query": "شقة للطلاب في حيفا للايجار يوجد فيها اكثر من غرفتين"}, "latencyMs": 5111, "updatedAt": "2026-04-25T21:10:46.129Z", "outputJson": {"filters": {"q": "students", "city": "Haifa", "mode": "RENT", "sort": "price_low", "type": "APARTMENT", "rooms": null, "maxArea": null, "minArea": null, "maxPrice": null, "minPrice": null, "bathrooms": null}, "confidence": 0.83, "explanation": "Parsed search intent with local fallback rules."}, "usefulness": null, "actorUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "correctness": "INCORRECT", "fallbackUsed": false, "requestLogId": "ca15fc8e-dcf6-44da-af85-a78c54bf1811", "reviewerNote": null, "expectedOutputJson": null}	{"model": null, "endpoint": "/ai/search/parse", "provider": null}	2026-04-25 21:10:46.136
\.


--
-- Data for Name: Conversation; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Conversation" (id, "listingId", "buyerUserId", "ownerUserId", "lastMessageAt", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: EmailLog; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."EmailLog" (id, "userId", "to", subject, type, status, provider, "errorMessage", metadata, "createdAt") FROM stdin;
\.


--
-- Data for Name: Event; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Event" (id, "userId", "sessionId", type, "entityId", "entityType", metadata, "createdAt") FROM stdin;
93445ccf-f64e-4145-840a-4135568f13c0	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12}	2026-04-20 00:22:21.147
af3b3439-065d-4a17-8e79-23ac437f0922	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12}	2026-04-20 00:22:30.884
163419bc-8726-4649-bd47-2e2bb9c3ff2f	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	FAVORITE_ADDED	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	listing	{"listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}	2026-04-20 00:22:33.561
476ce264-bdf0-4015-8748-6ca50a21fec9	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12}	2026-04-20 00:22:33.612
3ed55063-45de-423b-b90f-698245a5a8c5	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12}	2026-04-20 00:22:39.435
f6931cad-fcc2-4cdc-8c44-df2c8e595f10	\N	\N	LISTING_VIEWED	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	listing	{"city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "price": 5000}	2026-04-20 00:22:44.876
ab0b56b3-6a9a-4ebd-b343-77ec0c654ab5	\N	\N	LISTING_VIEWED	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	listing	{"city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "price": 5000}	2026-04-20 00:22:44.891
c46cd1d0-597c-47f1-8a3c-d71277710411	\N	\N	INQUIRY_CREATED	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	listing	{"leadId": "bdb696e1-1ede-486c-87b6-6fe78367d7cd", "source": "listing_details", "ownerUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c"}	2026-04-20 00:23:00.22
7d806c13-24d9-4bbd-9199-fd9fb0404815	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	LISTING_UPDATED	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	listing	{"status": "ARCHIVED", "changedFields": ["title", "description", "price", "city", "neighborhood", "type", "mode", "status", "rooms", "bathrooms", "area", "image"]}	2026-04-20 00:23:17.973
95a59f9b-51ab-478d-8d31-2d00e1401879	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12}	2026-04-20 00:41:17.757
68ee81db-7d26-48be-ae11-ae2b0d5e9ba8	\N	\N	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000}	2026-04-20 00:41:21.627
2acbf405-11e5-4583-b9c0-03ac860161ce	\N	\N	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000}	2026-04-20 00:41:21.652
f5688de2-d0c9-4ced-b2e0-fba5844c131e	\N	\N	LISTING_VIEWED	c161f02d-7d64-47bd-8412-424d48166b15	listing	{"city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "price": 6000}	2026-04-20 00:41:32.792
0f133eda-a182-45b8-ba41-3f66c3407508	\N	\N	LISTING_VIEWED	c161f02d-7d64-47bd-8412-424d48166b15	listing	{"city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "price": 6000}	2026-04-20 00:41:32.818
b3edc589-c7c6-4f73-9143-61ac0fcfe849	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12}	2026-04-20 01:06:50.579
b6a85115-aa24-41a9-b38b-4eebcba11388	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12}	2026-04-20 01:06:50.699
f6c86a94-4ebc-4a9c-a11a-0e90df0e1560	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12}	2026-04-20 01:07:27.137
fa06d582-04a9-4aca-8402-ac391c3dbce9	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12}	2026-04-20 02:22:37.803
78ffe9a6-aade-492f-aa3d-b2a2db914107	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12}	2026-04-20 02:22:37.915
cd37aa83-c211-4d36-bf52-e332e997bf24	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12}	2026-04-20 02:22:43.836
5252fe46-2e27-4892-b205-8aae40d1c0b7	\N	\N	LISTING_VIEWED	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	listing	{"city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "price": 5000}	2026-04-20 02:22:51.583
c876f0f7-55b5-416d-8512-929d799a4de0	\N	\N	LISTING_VIEWED	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	listing	{"city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "price": 5000}	2026-04-20 02:22:51.596
45714c31-76cf-4aba-a15b-e9ff503d2a52	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12}	2026-04-20 02:23:39.644
d098646d-520c-4e04-9754-791ff46075dc	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12}	2026-04-20 02:23:39.804
626fb1dd-c316-4a21-b545-d195ea9bc111	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12}	2026-04-20 02:24:22.049
b79ecfe0-bb35-431f-8280-cb0c8dee43ca	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12}	2026-04-20 02:31:16.407
fd75937f-b22e-488e-a708-6202e0d0c004	\N	\N	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000}	2026-04-20 02:31:22.505
928ddbde-2fba-4c09-bc32-a146de919ca3	\N	\N	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000}	2026-04-20 02:31:22.544
e915e4a2-3df9-48d4-9270-e32657d2c09a	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12}	2026-04-20 14:07:42.968
1f4d20e8-c4c2-4056-b651-599aa0d02387	\N	\N	LISTING_VIEWED	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	listing	{"city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "price": 5000}	2026-04-20 14:07:54.68
ea92c46a-9b4f-4057-9e39-56882bf914ca	\N	\N	LISTING_VIEWED	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	listing	{"city": "Tel Aviv", "mode": "RENT", "type": "APARTMENT", "price": 5000}	2026-04-20 14:07:54.682
c4600556-61b0-410e-a41d-79764c126536	\N	\N	LISTING_VIEWED	9cc14069-c507-44df-900b-3833cea37ead	listing	{"city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "price": 80000}	2026-04-20 14:08:08.224
6818e53a-8c00-4c18-aa0d-9c7b2ced1b8e	\N	\N	LISTING_VIEWED	9cc14069-c507-44df-900b-3833cea37ead	listing	{"city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "price": 80000}	2026-04-20 14:08:08.232
f7f02099-5cbf-4206-adbc-8d7ba4cff6e6	\N	\N	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000}	2026-04-20 14:09:14.965
56afdf1b-9595-4bf5-9d31-de8dc8b779e0	\N	\N	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000}	2026-04-20 14:09:14.997
33030ed9-4876-4294-b5df-5c91978434fc	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12}	2026-04-20 14:19:55.115
ec4cd91f-1b5e-4146-a207-e7b3d9c8ae54	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12}	2026-04-20 14:19:55.19
34f5ca09-236e-42ce-b118-42d91f67bd1b	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	LEAD_STATUS_CHANGED	bdb696e1-1ede-486c-87b6-6fe78367d7cd	lead	{"status": "CONTACTED", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}	2026-04-20 14:20:26.937
6b2ad23e-63a6-4ba7-b93b-24d5213bfc22	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	LEAD_STATUS_CHANGED	bdb696e1-1ede-486c-87b6-6fe78367d7cd	lead	{"status": "NEW", "listingId": "51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7"}	2026-04-20 14:20:28.686
53e98181-7c52-43d0-ac25-d1d8c070b2d6	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12}	2026-04-20 14:20:41.577
bdf59ff4-7933-4eb9-8423-a291598912f1	\N	\N	LISTING_VIEWED	9cc14069-c507-44df-900b-3833cea37ead	listing	{"city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "price": 80000}	2026-04-20 14:20:49.585
d25f2132-eb38-43dc-9995-3c7580d7fe13	\N	\N	LISTING_VIEWED	9cc14069-c507-44df-900b-3833cea37ead	listing	{"city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "price": 80000}	2026-04-20 14:20:49.59
05a7864f-e735-44fe-b55e-a7f9f989721b	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	LISTING_CREATED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000, "status": "PUBLISHED"}	2026-04-20 14:56:34.129
575d505d-357c-4a83-be39-2a2d2a70c09f	\N	\N	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-20 14:56:36.742
40a7302c-899c-4382-a1b9-a2753a429dff	\N	\N	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-20 14:56:36.778
9129d9b8-f2bb-4a93-b02e-ad750dc81314	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-20 20:34:03.121
c19121fe-d148-4cbf-ab50-a49fb1602069	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-20 20:34:03.142
7ee967cb-8926-42f1-bb09-8dcee35d21e6	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000}	2026-04-20 20:34:29.571
19cca29a-a378-465f-97ca-8562382a4822	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000}	2026-04-20 20:34:29.605
58f9159e-73d2-4bca-85be-527d4db73fc2	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	LISTING_UPDATED	41367728-e8a5-4232-8a08-520075bc6859	listing	{"status": "PUBLISHED", "changedFields": ["title", "description", "price", "city", "neighborhood", "type", "mode", "status", "rooms", "bathrooms", "area", "image"]}	2026-04-20 20:35:47.369
2db347db-8b10-4bea-8e43-aec8091d0b16	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_content	{"city": null, "mode": "RENT", "action": "generate_listing_content", "source": "add_listing", "propertyType": "APARTMENT"}	2026-04-20 20:36:08.2
f6021c00-7d2c-4024-bce4-4940a1209e97	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	search	{"query": "expensive home", "source": "ai_search", "filters": {"q": "expensive home", "city": null, "mode": null, "sort": null, "type": null, "rooms": null, "maxPrice": null, "minPrice": null}, "confidence": 0.35, "explanation": "Could not infer structured filters, using the query as keywords."}	2026-04-20 20:38:49.153
2432c389-6e50-4bae-8f19-9807e04b2252	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 0, "filters": {"q": "expensive home", "page": 1, "limit": 12}, "resultsCount": 0}	2026-04-20 20:38:49.281
5223ad57-b4aa-409f-aa0a-c6750c3b869a	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"source": "manual_filters", "filters": {"q": "", "city": "", "mode": "", "sort": "latest", "type": "", "rooms": "", "maxPrice": "", "minPrice": "100000"}}	2026-04-20 20:39:05.686
f1a7224a-d274-4bb2-9998-f5eeb6f904a5	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 2, "filters": {"page": 1, "limit": 12, "minPrice": 100000}, "resultsCount": 2}	2026-04-20 20:39:05.758
17e3b8df-272f-478a-a581-ab0c7c6fcbd5	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-20 20:50:44.238
3a947d78-2d8c-4fde-8861-41d4de785c49	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-20 20:51:21.793
2ff44cd8-d248-40f0-a0cb-f48e0262e0ef	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-20 20:54:51.462
5844f745-b2b3-401c-905d-9153fdeeff19	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-20 20:54:51.549
39f73be4-d306-4007-9ea2-878e204a3bc6	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	FAVORITE_REMOVED	c161f02d-7d64-47bd-8412-424d48166b15	listing	{"listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}	2026-04-20 20:55:00.878
c5f44ee2-ae39-4d67-aedb-00f9b023063a	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	FAVORITE_REMOVED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}	2026-04-20 20:55:06.585
dc4e9a0a-01d6-4037-999f-c1b39f954896	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-20 20:55:15.329
05ef3eba-c592-401f-8111-55bb064ef708	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	FAVORITE_ADDED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}	2026-04-20 20:55:21.526
0ab596e9-be35-4eb4-9666-0fac7f8e7103	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-20 20:55:21.599
2eeafb99-e2d5-4afd-940d-4e3366f99342	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	FAVORITE_ADDED	c161f02d-7d64-47bd-8412-424d48166b15	listing	{"listingId": "c161f02d-7d64-47bd-8412-424d48166b15"}	2026-04-20 20:55:24.657
71454852-5bd2-4afb-860c-c908beea1865	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-20 20:55:24.718
51d77414-589f-4071-87bf-5b2a90906dd2	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-20 20:55:25.484
ccee98cf-0ebf-41f3-99ee-ac12408e934c	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-20 20:55:26.086
2fb0ec2a-5bb8-429c-9b9d-94bac7764c0f	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	FAVORITE_ADDED	51b8a6d1-6450-49a4-b961-3d9bfe465770	listing	{"listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770"}	2026-04-20 20:55:28.295
734df078-edb3-4575-8bbe-9af1d38fabe9	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-20 20:55:28.354
7d4c9925-c3fc-4ac1-aa1e-f5a264918d36	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	FAVORITE_ADDED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"listingId": "c901de33-674a-444d-8892-259897e9e4a9"}	2026-04-20 20:55:31.294
da5a8c82-e7c0-41e3-83b8-7e574341e12a	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-20 20:55:31.359
00b24bed-d256-4a91-8fe9-981c02d8e292	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-20 23:08:15.729
0d6323f9-bfa2-4591-bb47-9dd4e322b7db	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-20 23:08:15.758
b3d902b6-8dee-4739-8118-fa9ec9f5dd11	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c161f02d-7d64-47bd-8412-424d48166b15	listing	{"city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "price": 6000}	2026-04-20 23:08:22.826
f7b10b1a-cf09-42ad-8c85-2c6fb9b89aca	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c161f02d-7d64-47bd-8412-424d48166b15	listing	{"city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "price": 6000}	2026-04-20 23:08:22.83
d4fdfa34-e7f6-4155-9309-b2239e145e39	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000}	2026-04-20 23:08:33.625
01f1732f-66fb-46a0-8925-e6c6fdaeea02	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000}	2026-04-20 23:08:33.627
e357ab12-6b21-4494-b64a-9fc8f627b7ef	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-20 23:33:28.5
adc6d890-a23d-4b75-8b22-28ddffd0711d	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-20 23:33:38.021
72d00bfe-35fb-4284-a771-bd0a20dac5de	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-20 23:41:01.386
7e6a5443-72f1-4a05-89eb-ead2e1357fb0	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-20 23:41:01.488
b09b3335-1b8b-476a-a162-2cba4aa79467	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-20 23:41:07.612
3d91271a-7bd2-4f52-af30-fcc90848de52	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-20 23:41:07.65
014fbef6-5d58-42d5-80bb-b55a0e4898fc	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 03:17:19.077
32bae7c1-25e0-4ad0-bf89-2025a7a94f46	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 03:17:19.157
43710211-fa71-4add-8027-48141d426a98	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-21 03:17:26.249
6dc092e8-316c-4d4f-95bf-12ed965d2689	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-21 03:17:26.283
f7592d6c-6b7b-46aa-a3c9-90307bc6e0b3	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-21 03:18:16.656
678d39b2-b82c-40b3-8c32-ba3adaa428c7	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-21 03:18:25.349
d7b7ac40-c531-4f16-826f-a62d03682a01	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 03:18:36.311
b234799b-2500-476b-a03c-6525a48c9193	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-21 03:18:38.347
0b186265-b45b-4a7b-8218-4a93496a867b	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 03:18:43.935
5557cc56-8d08-4561-9d72-33d5d3d4d420	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 03:18:51.606
f731beeb-b290-46ff-85d0-00315797fd23	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 03:18:52.504
35b88313-faa1-4d2c-a870-2d0c63f4199d	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-21 12:24:29.586
d0ff5d2d-046c-4789-a561-e9866405d825	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-21 12:24:40.099
3f5bd934-62da-4bab-8937-37e8b5235648	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-21 12:24:40.143
081f029e-952e-40e4-9998-fb84bc61e3ef	\N	\N	INQUIRY_CREATED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"leadId": "1d22cfb1-f708-41c0-933b-29a6b76c46cd", "source": "listing_details", "ownerUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c"}	2026-04-21 12:25:05.748
cf41ec5b-2267-4cdd-b385-c9256cb206ff	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 12:25:13.496
641f1301-89bd-4769-bd45-6ed79130e57b	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-21 12:25:22.574
d8a32b62-fabe-492f-a8e2-fd9c028dbf27	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-21 12:25:22.577
79596632-b88d-458e-ab50-7d5c0562d0fb	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 12:26:10.986
657eaee9-ca4f-4acf-bbdf-2328fee3f806	0863bc3f-a7c7-464c-9737-1f49ec6d6a65	\N	FAVORITE_ADDED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"listingId": "c901de33-674a-444d-8892-259897e9e4a9"}	2026-04-21 12:26:15.087
2b7ae2ef-059f-4307-966a-fdb2b1b77e0c	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 12:26:15.155
30ac29d7-6b82-442b-ac8f-60dfdccccff2	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-21 12:26:21.921
e9901f14-f208-45d5-98fb-4ddbac6b21dc	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-21 12:26:21.946
8c025021-3dd7-4d46-a9a1-6c45d6249618	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-21 12:36:55.914
635bbbc8-d91d-4264-9db4-8488da2e95e7	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-21 12:37:12.086
4a5a039a-51e5-444a-968f-c3bad0b9b9a0	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 12:37:24.918
e108a90b-7594-4723-9ff4-7d9e1ac16b62	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-21 21:11:11.747
554a8071-8197-48c0-9887-ac72845183c6	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 12:37:37.567
c7767ace-a35c-41ea-beee-af0325ae74db	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-21 12:37:45.685
adf84254-d42c-45e7-ba36-3b209c736f7f	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-21 12:37:45.725
ba06566b-bf64-4082-83c5-62fb51db8e46	\N	\N	INQUIRY_CREATED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"leadId": "bcc60994-a34c-40df-82e9-160b5af032a0", "source": "listing_details", "ownerUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c"}	2026-04-21 12:38:04.505
2e7a431c-9467-4fcc-9dd3-f46d19b83944	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 12:38:35.322
81366260-1293-40cb-97e9-d51f96b3e23a	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000}	2026-04-21 12:38:39.037
48eadaf2-a6b2-4c2d-b947-bde2a150e295	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000}	2026-04-21 12:38:39.059
32a8ae2c-a9db-4b45-b069-abf880d227d6	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	INQUIRY_CREATED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"leadId": "85ec5c6d-a47d-4400-82af-1067b6188d0c", "source": "listing_details", "ownerUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c"}	2026-04-21 12:38:51.664
efd2285a-c46a-4c54-9ce6-f26ed0fa3919	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	LEAD_STATUS_CHANGED	85ec5c6d-a47d-4400-82af-1067b6188d0c	lead	{"status": "CONTACTED", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}	2026-04-21 12:39:31.821
8cf0cb08-db63-4544-8af0-5962249e4a33	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	LEAD_STATUS_CHANGED	bcc60994-a34c-40df-82e9-160b5af032a0	lead	{"status": "CLOSED", "listingId": "c901de33-674a-444d-8892-259897e9e4a9"}	2026-04-21 12:39:33.796
8bb1fdfb-611e-4e96-8f84-57204b69127b	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 12:39:49.888
b3500fb2-aab8-494c-80d0-75375f561e54	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 1, "filters": {"page": 1, "type": "HOUSE", "limit": 12, "rooms": 3, "maxPrice": 200000, "minPrice": 50000}, "resultsCount": 1}	2026-04-21 12:40:25.083
aa03c70d-6042-4e98-8c1c-34bda36a987d	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 0, "filters": {"mode": "RENT", "page": 1, "type": "HOUSE", "limit": 12, "rooms": 3, "maxPrice": 200000, "minPrice": 50000}, "resultsCount": 0}	2026-04-21 12:40:35.958
252dc145-e7e7-4cfa-b624-81f4766a0c44	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 1, "filters": {"page": 1, "type": "HOUSE", "limit": 12, "rooms": 3, "maxPrice": 200000, "minPrice": 50000}, "resultsCount": 1}	2026-04-21 12:40:45.419
e3e0feb4-baf2-4ec0-80a6-4757f7d8d302	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	SAVED_SEARCH_CREATED	00e2dd5e-32d2-4de3-8e94-46465d880c31	saved_search	{"name": "Saved1", "filters": {"type": "HOUSE", "rooms": "3", "maxPrice": "200000", "minPrice": "50000"}}	2026-04-21 12:41:00.253
cb672a83-86b4-4e41-8ad2-bbfc89afdef2	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 1, "filters": {"page": 1, "type": "HOUSE", "limit": 12, "rooms": 3, "maxPrice": 200000, "minPrice": 50000}, "resultsCount": 1}	2026-04-21 12:41:18.631
b35c94f8-a406-476e-befe-9345b594d978	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	SAVED_SEARCH_DELETED	00e2dd5e-32d2-4de3-8e94-46465d880c31	saved_search	{"name": "Saved1", "filters": {"type": "HOUSE", "rooms": "3", "maxPrice": "200000", "minPrice": "50000"}}	2026-04-21 12:41:32.914
3f08f7b7-add3-47e6-927c-1533b7ed797e	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-21 12:59:48.023
e13b651f-de4b-476f-b89f-0f3b068afda9	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_content	{"city": null, "mode": "RENT", "action": "generate_listing_content", "source": "add_listing", "propertyType": "APARTMENT"}	2026-04-21 13:00:05.495
9d2c898c-b1d2-462f-8aff-ce6b154e6019	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	LISTING_CREATED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "price": 110000, "status": "PUBLISHED"}	2026-04-21 13:01:55.111
d8152c6b-2ba2-4950-84c2-4c98db9acdf7	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "price": 110000}	2026-04-21 13:01:58.665
46c1e5fe-87a9-4a8f-a993-4124158262fe	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "filters": {"page": 1, "limit": 12}, "resultsCount": 8}	2026-04-21 13:07:10.669
e7cde5e3-8dbe-4ef6-a54e-ed486d8ea4f7	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "filters": {"page": 1, "limit": 12}, "resultsCount": 8}	2026-04-21 13:08:19.9
b2b79802-afa0-434c-9850-84c7da664bee	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "filters": {}, "resultsCount": 8}	2026-04-21 13:08:35.325
7f549e03-4298-4cc5-8b8f-42f27747ee3b	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-21 13:09:33.067
78b6417c-2944-46a4-8604-86d5fee17daf	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-21 13:09:33.071
0ce7ed24-f591-49ff-9ba6-28acf6483305	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	LISTING_DELETED	ecc5b2d6-d6f8-4238-9f8d-474965563e25	listing	{"city": "asq", "mode": "RENT", "type": "APARTMENT", "price": 50}	2026-04-21 13:10:02.853
88d83e03-bc99-4cb8-b0c9-77b5952cace4	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	LISTING_UPDATED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"status": "ARCHIVED", "changedFields": ["title", "description", "price", "city", "neighborhood", "type", "mode", "status", "rooms", "bathrooms", "area", "image", "images"]}	2026-04-21 13:10:18.986
11f04322-e48d-49c0-89ae-73ce1667c2be	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	LISTING_UPDATED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"status": "PUBLISHED", "changedFields": ["title", "description", "price", "city", "neighborhood", "type", "mode", "status", "rooms", "bathrooms", "area", "image", "images"]}	2026-04-21 13:10:34.196
f62b5e97-e1dc-4697-9e94-6f55e0171ff3	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "price": 110000}	2026-04-21 21:11:25.761
e4ca64df-462a-44d6-9e4b-698858d87619	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	LISTING_UPDATED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"status": "ARCHIVED", "changedFields": ["title", "description", "price", "city", "neighborhood", "type", "mode", "status", "rooms", "bathrooms", "area", "image", "images"]}	2026-04-21 13:10:39.584
225f6daf-826b-4c32-9ba8-94b53b645441	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 6, "filters": {"page": 1, "limit": 12}, "resultsCount": 6}	2026-04-21 13:10:42.777
4e054cc0-45bc-4e00-b856-c2e144384712	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	LISTING_UPDATED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"status": "PUBLISHED", "changedFields": ["title", "description", "price", "city", "neighborhood", "type", "mode", "status", "rooms", "bathrooms", "area", "image", "images"]}	2026-04-21 13:10:50.772
c974e950-02ab-48bf-9432-3bd8754f5c6a	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 13:10:52.316
2699c8cc-3da4-49a2-9b4c-b6e4bc93b41d	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-21 13:24:55.267
d0a65a51-6ffe-401c-b62f-cc5bdc35e436	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 13:25:07.807
9089dc91-942d-44c8-9ec4-598e198d98fa	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 13:25:07.886
c8833faa-c765-47af-a183-3e1bb18a0412	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "filters": {"page": 1, "sort": "price_high", "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "minPrice": 60000, "bathrooms": 1}, "resultsCount": 3}	2026-04-21 13:25:47.301
c550913b-ce18-4d34-9c0a-8bee6f194608	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "filters": {"page": 1, "sort": "price_low", "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "minPrice": 60000, "bathrooms": 1}, "resultsCount": 3}	2026-04-21 13:26:10.22
741f7a4f-9524-490f-9676-4470f7c3ce6b	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "filters": {"page": 1, "sort": "price_low", "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "minPrice": 60000, "bathrooms": 1}, "resultsCount": 3}	2026-04-21 13:27:00.769
a4450038-377c-4a1c-bdae-7dfc3aeec075	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "filters": {"page": 1, "sort": "price_low", "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "minPrice": 60000, "bathrooms": 1}, "resultsCount": 3}	2026-04-21 13:27:01.934
632f7341-6b26-4efc-ae1e-2a5511c1ab3e	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 5, "filters": {"page": 1, "sort": "price_low", "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "bathrooms": 1}, "resultsCount": 5}	2026-04-21 13:27:16.405
bc6e0cd4-513f-4f35-ab7d-5b8e75ddd320	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 5, "filters": {"page": 1, "sort": "price_low", "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "bathrooms": 1}, "resultsCount": 5}	2026-04-21 13:27:20.885
8d39e8f9-6ad4-48c9-a6b0-82e4dba724f8	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "filters": {"page": 1, "sort": "price_low", "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "minPrice": 60000, "bathrooms": 1}, "resultsCount": 3}	2026-04-21 13:27:26.335
6e096a56-dd07-4c0a-99b7-d966719e1ea9	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "filters": {"page": 1, "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "minPrice": 60000, "bathrooms": 1}, "resultsCount": 3}	2026-04-21 13:28:17.479
08e592db-a3e6-49f4-8a3e-b06b21eb02d4	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "filters": {"page": 1, "sort": "oldest", "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "minPrice": 60000, "bathrooms": 1}, "resultsCount": 3}	2026-04-21 13:28:23.859
954cfb4e-8e20-4b1a-9ae3-be5c924141b9	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 13:28:38.432
b1c64e3d-1b95-4bab-abc8-d67ea210d9ac	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 5, "filters": {"page": 1, "sort": "price_low", "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "bathrooms": 1}, "resultsCount": 5}	2026-04-21 13:28:49.279
1e503927-1268-49a8-966b-a03d4bc5b0ab	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 5, "filters": {"page": 1, "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "bathrooms": 1}, "resultsCount": 5}	2026-04-21 13:28:54.52
276729bf-d2fe-4695-8523-5abb49b5ce3d	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 13:28:57.947
b7ad472a-3e40-426f-a181-f08f894ab1ab	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "filters": {"page": 1, "sort": "price_low", "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "minPrice": 60000, "bathrooms": 1}, "resultsCount": 3}	2026-04-21 13:29:09.921
c94af814-afc4-4bb6-a75c-5d25b9608e68	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	SAVED_SEARCH_CREATED	0df360de-4e69-45bc-9e1d-3b09396dccc1	saved_search	{"name": "Saved search2", "filters": {"sort": "price_low", "rooms": "2", "maxArea": "200", "minArea": "70", "maxPrice": "200000", "minPrice": "60000", "bathrooms": "1"}}	2026-04-21 13:29:18.256
f54da5b6-b4d1-490d-8d20-1a1249fcba61	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 13:29:20.825
7aa8d8f0-b51c-4067-b29e-ee67fc39cb30	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "filters": {"page": 1, "sort": "price_low", "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "minPrice": 60000, "bathrooms": 1}, "resultsCount": 3}	2026-04-21 13:29:54.316
20d07650-8dc4-41a5-b692-41f5d0d5fe8e	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 13:30:17.541
20e73712-824c-425d-83e0-d468205be4ec	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	search	{"query": "cheap apartment in Haifa for students", "source": "ai_search", "filters": {"q": "students", "city": "Haifa", "mode": null, "sort": "price_low", "type": "APARTMENT", "rooms": null, "maxPrice": "5000", "minPrice": null}, "confidence": 0.8999999999999999, "explanation": "Parsed basic search intent from text."}	2026-04-21 13:30:20.693
2274d505-acec-4371-91cb-13b9358160ea	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 0, "filters": {"q": "students", "city": "Haifa", "page": 1, "sort": "price_low", "type": "APARTMENT", "limit": 12, "maxPrice": 5000}, "resultsCount": 0}	2026-04-21 13:30:20.856
3aa206ff-77ea-4136-92ba-996136dda8db	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 0, "filters": {"q": "students", "city": "Haifa", "page": 1, "sort": "price_low", "limit": 12, "maxPrice": 5000}, "resultsCount": 0}	2026-04-21 13:30:30.277
ed0d644a-db44-4160-b119-7d4a8c95ff6a	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 0, "filters": {"q": "students", "city": "Haifa", "page": 1, "sort": "price_low", "type": "APARTMENT", "limit": 12, "maxPrice": 500000}, "resultsCount": 0}	2026-04-21 13:30:42.384
ecec0b13-e260-4620-8be2-e1a6b5694bcf	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 0, "filters": {"q": "students", "city": "Haifa", "page": 1, "sort": "price_low", "limit": 12, "maxPrice": 500000}, "resultsCount": 0}	2026-04-21 13:30:47.791
054d4f8a-b5df-4c5e-b8dd-723563537be9	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	search	{"query": "cheap apartment in Tel Aviv for students", "source": "ai_search", "filters": {"q": "students", "city": "Tel Aviv", "mode": null, "sort": "price_low", "type": "APARTMENT", "rooms": null, "maxPrice": "5000", "minPrice": null}, "confidence": 0.8999999999999999, "explanation": "Parsed basic search intent from text."}	2026-04-21 13:31:09.733
38275738-6466-4b7f-abd5-4c8b7731d6ef	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 0, "filters": {"q": "students", "city": "Tel Aviv", "page": 1, "sort": "price_low", "type": "APARTMENT", "limit": 12, "maxPrice": 5000}, "resultsCount": 0}	2026-04-21 13:31:09.849
6dcb9bec-7557-45d1-b8ef-b7f417e37ea0	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 0, "filters": {"q": "students", "city": "TelAviv", "page": 1, "sort": "price_low", "type": "APARTMENT", "limit": 12, "maxPrice": 5000}, "resultsCount": 0}	2026-04-21 13:31:15.963
0d9ee01b-e7f1-491b-a370-50c9ef57d5ae	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 13:31:19.214
3106f60f-2f5d-47fe-8088-178ec6ddcca5	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c161f02d-7d64-47bd-8412-424d48166b15	listing	{"city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "price": 6000}	2026-04-21 13:31:46.081
4635471c-e253-4134-abf5-cc0d85017c66	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c161f02d-7d64-47bd-8412-424d48166b15	listing	{"city": "um al fahm", "mode": "RENT", "type": "APARTMENT", "price": 6000}	2026-04-21 13:31:46.087
70788ccb-4bad-4743-9c53-c75b82d56ea5	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-21 13:35:17.636
0af9a6f2-ebde-4e42-a8e1-f264b1abcc1a	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 13:35:24.724
92d04b73-dff4-4c3d-a517-9fc20bbd1078	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 0, "filters": {"page": 1, "limit": 12, "rooms": 2, "maxArea": 160, "minArea": 70, "maxPrice": 200000, "minPrice": 2000, "bathrooms": 6}, "resultsCount": 0}	2026-04-21 13:36:41.612
5b3d6253-a711-4bc4-8c7c-e3926f30a363	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 0, "filters": {"page": 1, "limit": 12, "rooms": 2, "maxPrice": 200000, "minPrice": 2000, "bathrooms": 6}, "resultsCount": 0}	2026-04-21 13:36:56.101
a402db98-b3c8-4379-b3db-62d5e7581a58	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 6, "filters": {"page": 1, "limit": 12, "maxPrice": 200000, "minPrice": 2000}, "resultsCount": 6}	2026-04-21 13:37:04.876
e5573b35-5868-4ee3-8b50-feecb9977c32	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 6, "filters": {"page": 1, "limit": 12, "maxPrice": 200000, "minPrice": 2000}, "resultsCount": 6}	2026-04-21 13:37:27.151
12ba011f-fb64-4216-8c91-48fb4ead53a2	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 13:37:40.033
c9629493-4381-40f9-9208-62ac951d6a68	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 6, "filters": {"page": 1, "limit": 12, "maxPrice": 200000, "minPrice": 2000}, "resultsCount": 6}	2026-04-21 13:37:41.857
1f86ad6d-9852-42f9-a578-ba4d26db54f2	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 5, "filters": {"page": 1, "limit": 12, "rooms": 3, "maxPrice": 200000, "minPrice": 2000, "bathrooms": 2}, "resultsCount": 5}	2026-04-21 13:37:58.268
ab59c984-53e9-46fb-9de3-6c6fa3e9e2ca	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 5, "filters": {"page": 1, "limit": 12, "rooms": 3, "maxPrice": 200000, "minPrice": 2000, "bathrooms": 2}, "resultsCount": 5}	2026-04-21 13:38:00.077
48cfac37-f31d-4768-bc52-9b9fcebc3606	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 13:38:02.134
252555bb-c28a-46e7-b308-9519f0fb949f	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 5, "filters": {"page": 1, "limit": 12, "rooms": 3, "maxPrice": 200000, "minPrice": 2000, "bathrooms": 2}, "resultsCount": 5}	2026-04-21 13:38:04.043
58ba696a-dba9-4a6f-bb83-3461f47c4b94	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_REPORTED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"reason": "WRONG_DETAILS", "reportId": "363424e8-ed43-42df-bd2d-e3772d08a3ae", "autoArchived": false, "reportsCount": 1}	2026-04-21 21:11:40.857
337b8dd2-2307-4b90-b610-ef86de0bd3fa	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	VERIFICATION_REQUESTED	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	user	null	2026-04-21 21:12:05.003
f52e98ca-52d0-440c-bf9f-a878e4795e01	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-21 21:13:08.642
3d958286-3e9c-48c4-adbb-3dda18afe610	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-21 21:13:12.352
514fd2fb-d84f-4cb6-8629-931c3ffaf4ce	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	41367728-e8a5-4232-8a08-520075bc6859	listing	{"city": "um al fahm ", "mode": "RENT", "type": "APARTMENT", "price": 6600}	2026-04-21 21:13:17.838
2dd0e2d3-3933-446c-963d-2a671c4339f0	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_REPORTED	41367728-e8a5-4232-8a08-520075bc6859	listing	{"reason": "WRONG_DETAILS", "reportId": "5e2c1828-38ea-4670-a4b7-bbad3e85b233", "autoArchived": false, "reportsCount": 1}	2026-04-21 21:13:24.101
f07a547e-523e-44e4-b990-5a0882352965	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	LISTING_UPDATED	41367728-e8a5-4232-8a08-520075bc6859	listing	{"status": "ARCHIVED", "changedFields": ["title", "description", "price", "city", "neighborhood", "type", "mode", "status", "rooms", "bathrooms", "area", "image", "images"]}	2026-04-21 21:13:37.585
8139d9aa-010c-4baa-8b2d-3d4b818257d5	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	LISTING_UPDATED	41367728-e8a5-4232-8a08-520075bc6859	listing	{"status": "PUBLISHED", "changedFields": ["title", "description", "price", "city", "neighborhood", "type", "mode", "status", "rooms", "bathrooms", "area", "image", "images"]}	2026-04-21 21:13:38.439
aed9c894-47c6-48b4-898a-f9dd875d946a	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-22 00:19:51.254
1fc2db68-d21d-4eec-ade6-68cd937f7a8c	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-22 00:20:16.588
6f365865-d2ca-4e44-b87e-696a82c99a8b	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "price": 110000}	2026-04-22 00:20:30.374
d5554fd8-c1db-406b-a8c2-43dbf2ced388	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "filters": {"page": 1, "sort": "price_low", "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "minPrice": 60000, "bathrooms": 1}, "resultsCount": 3}	2026-04-22 00:21:23.931
25255a73-7074-47e2-84a9-c64f2d083a43	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 5, "filters": {"page": 1, "limit": 12, "rooms": 3, "maxPrice": 200000, "minPrice": 2000, "bathrooms": 2}, "resultsCount": 5}	2026-04-22 00:21:28.642
affad714-7c0c-474c-b504-1e925fa8112b	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 5, "filters": {"page": 1, "limit": 12, "rooms": 3, "maxPrice": 200000, "minPrice": 2000, "bathrooms": 2}, "resultsCount": 5}	2026-04-22 00:21:31.514
4d8bbe6c-04cf-473b-8450-3fff2ae49d2c	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {"page": 1, "limit": 12}, "resultsCount": 7}	2026-04-22 00:21:36.882
58f43ae3-1052-4fe1-b1c2-cfb7cefcbc99	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_content	{"city": null, "mode": "RENT", "action": "generate_listing_content", "source": "add_listing", "propertyType": "APARTMENT"}	2026-04-22 00:21:49.762
10256442-faad-4b7a-beda-0ad598dada9f	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_REJECTED	\N	listing_content	{"mode": "RENT", "action": "undo_generated_listing_content", "source": "add_listing", "propertyType": "APARTMENT"}	2026-04-22 00:22:24.361
db19baa7-5daa-4083-bfea-60c6d5d25c3a	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_content	{"city": "Haifa", "mode": "RENT", "action": "generate_listing_content", "source": "add_listing", "propertyType": "APARTMENT"}	2026-04-22 00:22:30.496
765ac11e-86dd-4ada-a256-669a9d75f564	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_quality	{"level": "excellent", "score": 86, "action": "score_listing_quality", "source": "add_listing"}	2026-04-22 00:22:46.912
24f61363-c0db-417b-8f86-5299d7a7c865	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-22 00:23:10.709
c2063324-ab2a-4a76-b63f-bad24f82fc3e	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-22 01:11:55.968
f4f25d6b-dd1f-4689-8e58-af25f927112e	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-22 01:11:56.234
9804120e-641f-44d2-afdb-4861adc2661d	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-22 01:11:56.485
b5940964-4ea9-4ac7-94f5-600f72c4235a	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "price": 110000}	2026-04-22 01:12:16.241
28c9890f-ff30-485d-8215-e8a2d932a497	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-22 01:12:44.57
3509b345-0efe-4ec2-af65-649235beccc5	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-22 01:12:44.574
9725b7f8-4107-4763-9c64-0d6702c89061	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_quality	{"level": "weak", "score": 11, "action": "score_listing_quality", "source": "add_listing"}	2026-04-22 01:14:36.623
a123e960-cd51-4934-846e-f3662064863e	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_content	{"city": null, "mode": "RENT", "action": "generate_listing_content", "source": "add_listing", "propertyType": "APARTMENT"}	2026-04-22 01:14:36.927
c1166d68-8142-4dfc-91e3-bb92356dcfb1	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_quality	{"level": "weak", "score": 41, "action": "score_listing_quality", "source": "add_listing"}	2026-04-22 01:14:45.249
c2cae502-eb62-4181-b4e7-e0840082cb16	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_REJECTED	\N	listing_content	{"mode": "RENT", "action": "undo_generated_listing_content", "source": "add_listing", "propertyType": "APARTMENT"}	2026-04-22 01:15:04.898
a0002dd1-0e8e-4fb3-9e70-b674de43f4c1	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_content	{"city": null, "mode": "RENT", "action": "generate_listing_content", "source": "add_listing", "propertyType": "APARTMENT"}	2026-04-22 01:15:05.946
c358c00d-c6d3-4548-80c5-d6feb1adf319	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_content	{"city": null, "mode": "RENT", "action": "generate_listing_content", "source": "add_listing", "propertyType": "APARTMENT"}	2026-04-22 01:15:21.492
e081ad80-0208-4a25-b119-569730e73b72	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_content	{"city": "Um Al Fahm", "mode": "RENT", "action": "generate_listing_content", "source": "add_listing", "propertyType": "APARTMENT"}	2026-04-22 01:15:37.825
016e9321-072e-4d01-8433-40f06009b5c1	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_content	{"city": "Um Al Fahm", "mode": "RENT", "action": "generate_listing_content", "source": "add_listing", "propertyType": "APARTMENT"}	2026-04-22 01:16:15.764
6accd234-2f4b-41b4-8242-e391f6053445	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-22 03:01:27.27
a8cfae60-40c9-4ed4-b54b-d1e9d1939a3d	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-22 03:03:12.281
b0a9ff5a-82a9-4dbe-82d7-1ef3a121b679	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "price": 110000}	2026-04-22 03:03:19.712
4bb5b1d9-49a2-4917-b9a2-2a329d9fe0de	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "price": 110000}	2026-04-22 03:03:19.766
3663d6d4-7222-4304-bc24-8b55e3146f5a	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	INQUIRY_CREATED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"leadId": "ea06cd76-96b2-4924-b512-0d14d07fba96", "source": "listing_details", "ownerUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c"}	2026-04-22 03:03:52.587
f495b541-cec5-4f66-b82f-425934256622	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-22 16:19:59.301
dad0bd4d-aaf1-489b-9d5f-0a800e5756c6	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "filters": {}, "resultsCount": 7}	2026-04-22 16:31:55.118
133fb94a-97a2-4500-9191-0e22ad049082	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	9cc14069-c507-44df-900b-3833cea37ead	listing	{"city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "price": 80000}	2026-04-22 16:33:20.65
411517fb-981c-472f-97de-6eff694ffd0f	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-22 16:33:48.139
c60338a7-1a22-44c4-bcce-5feddcec9038	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000}	2026-04-22 16:33:48.143
7dde2a2c-360d-4651-8155-d597fec37b7a	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "filters": {}, "resultsCount": 8}	2026-04-22 16:34:30.403
b42c124c-794c-479a-82dd-0febdb352eee	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "price": 110000}	2026-04-22 16:34:56.492
527fb11d-ac13-4500-8530-2d079491cb93	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "price": 110000}	2026-04-22 16:34:56.499
447bc594-36d2-4b42-bd40-ca681ba3d65d	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "filters": {"page": 1, "limit": 12}, "resultsCount": 8}	2026-04-22 16:35:45.377
f0fc342d-d3bd-41a2-b187-2b72fd579645	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "filters": {}, "resultsCount": 8}	2026-04-22 16:36:01.157
de7d8e3d-f466-4810-949d-20baebd047b0	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "filters": {}, "resultsCount": 8}	2026-04-22 16:39:44.27
8882d115-5eac-4386-bcca-8329cfd45c41	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "filters": {"limit": 50}, "resultsCount": 8}	2026-04-22 16:39:44.278
e9b539d2-88e4-4236-9a8b-2f06bd8340c1	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "filters": {"limit": 50}, "resultsCount": 8}	2026-04-22 16:40:09.27
b78d796d-6879-4997-a425-28b883fbbff3	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "filters": {}, "resultsCount": 8}	2026-04-22 16:40:09.271
b2f72b3e-7be3-4bec-a46f-70df7dbad9ec	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "filters": {"limit": 50}, "resultsCount": 8}	2026-04-22 16:40:33.99
41eb10f6-9b18-450f-bbd7-4be42153eadf	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "filters": {}, "resultsCount": 8}	2026-04-22 16:40:34.006
8a175397-930a-4600-bff1-848765d262c0	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-22T22:11:39.040Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-22 22:11:39.041
5c7f12c1-2fc2-43d3-bed3-86b2c5012b8e	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-22T22:11:39.029Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-22 22:11:39.038
83948c27-fd03-413a-8b86-d3158852e98d	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-22T22:11:53.784Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-22 22:11:53.785
8ace6d3c-8ace-4f81-a88c-c6c5709488b1	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-22T22:11:53.786Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-22 22:11:53.786
e39b76b5-6f50-4ea9-8ae1-5517dfefc159	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-22T22:12:04.246Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-22 22:12:04.247
34efc73f-9ec7-43e5-9cd3-147f7db94ce9	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "source": "real-estate-backend", "filters": {"city": "Haifa", "page": 1, "limit": 12}, "receivedAt": "2026-04-22T22:12:10.833Z", "environment": "development", "resultsCount": 3, "schemaVersion": 1}	2026-04-22 22:12:10.833
bc48feee-aeab-4360-81f0-60eb77537306	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-22T22:12:20.909Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-22 22:12:20.909
0f1fb820-d3f3-4b15-a759-ea20a4a098b9	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "source": "real-estate-backend", "filters": {"city": "Haifa", "page": 1, "limit": 12}, "receivedAt": "2026-04-22T22:12:26.579Z", "environment": "development", "resultsCount": 3, "schemaVersion": 1}	2026-04-22 22:12:26.58
21d15120-bc29-4286-8215-4da493ce6599	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000, "source": "real-estate-backend", "receivedAt": "2026-04-22T22:12:31.183Z", "environment": "development", "schemaVersion": 1}	2026-04-22 22:12:31.185
6906de02-1140-4a04-a254-a5076d06d255	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000, "source": "real-estate-backend", "receivedAt": "2026-04-22T22:12:31.186Z", "environment": "development", "schemaVersion": 1}	2026-04-22 22:12:31.187
82249ca5-3b06-4cf2-9c02-2df3ca2427ca	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "source": "real-estate-backend", "filters": {"city": "Haifa", "page": 1, "limit": 12}, "receivedAt": "2026-04-22T22:12:38.273Z", "environment": "development", "resultsCount": 3, "schemaVersion": 1}	2026-04-22 22:12:38.273
14e39a90-5809-4adb-8d0f-adcc8a711fd7	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	51b8a6d1-6450-49a4-b961-3d9bfe465770	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 7777, "source": "real-estate-backend", "receivedAt": "2026-04-22T22:12:41.690Z", "environment": "development", "schemaVersion": 1}	2026-04-22 22:12:41.691
ac6851e0-bfad-4039-998b-69d6f7ff3889	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	51b8a6d1-6450-49a4-b961-3d9bfe465770	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 7777, "source": "real-estate-backend", "receivedAt": "2026-04-22T22:12:41.708Z", "environment": "development", "schemaVersion": 1}	2026-04-22 22:12:41.709
03bd0360-b0a0-4d60-a2ec-5e6d2f5b9149	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-22T23:46:54.696Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-22 23:46:54.711
0961e617-2891-40f1-9e1c-ea4bd746b1a3	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-22T23:46:54.715Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-22 23:46:54.716
de1c5fe4-7b12-419c-a7a9-ad53b44b2859	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	SUBSCRIPTION_CHANGED	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	user	{"plan": "PREMIUM", "source": "real-estate-backend", "paymentId": "8099f332-56c1-47dd-8a93-955b0ea85382", "receivedAt": "2026-04-22T23:48:22.483Z", "environment": "development", "schemaVersion": 1}	2026-04-22 23:48:22.484
dd610738-d6d5-4958-9a19-e71ab21b5a3a	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	PAYMENT_COMPLETED	8099f332-56c1-47dd-8a93-955b0ea85382	payment	{"plan": "PREMIUM", "amount": 79, "source": "real-estate-backend", "purpose": "SUBSCRIPTION", "currency": "USD", "provider": "local", "listingId": null, "receivedAt": "2026-04-22T23:48:22.952Z", "environment": "development", "schemaVersion": 1}	2026-04-22 23:48:22.954
199f670b-7a19-4157-8d17-6fabbcb7853f	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-22T23:54:24.501Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-22 23:54:24.516
0bf636f9-6044-4dd5-b78d-68330a41829e	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-22T23:54:24.522Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-22 23:54:24.522
59bc4b03-948b-4958-81f2-341594158160	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-22T23:55:10.071Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-22 23:55:10.072
4e1c4cb6-a32c-4c5d-8c97-1d4affbc9dcb	0863bc3f-a7c7-464c-9737-1f49ec6d6a65	\N	FAVORITE_ADDED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"source": "real-estate-backend", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "receivedAt": "2026-04-22T23:55:17.822Z", "environment": "development", "schemaVersion": 1}	2026-04-22 23:55:17.825
73c06980-577f-48fd-8303-fa37e1719ed9	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	FAVORITE_ADDED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"city": "Tel Aviv", "price": 110000, "source": "real-estate-ui", "userId": "0863bc3f-a7c7-464c-9737-1f49ec6d6a65", "entityId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-22T23:55:18.484Z", "environment": "development", "schemaVersion": 1}	2026-04-22 23:55:18.487
b7408cd0-065e-4e4b-a924-dc0996dcb44f	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-22T23:55:18.629Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-22 23:55:18.63
9232d219-71c9-4212-8c9b-d32d1fdd011f	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-22T23:55:37.265Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-22 23:55:37.267
9f6a03a7-d71f-42f6-8397-17dee2a97828	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-22T23:55:43.389Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-22 23:55:43.39
9dcd70b9-9c58-4986-b7c7-dc760c758204	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-22T23:55:43.423Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-22 23:55:43.424
88c0c0a2-18ae-425d-9d59-f8f0deea6141	0863bc3f-a7c7-464c-9737-1f49ec6d6a65	\N	SUBSCRIPTION_CHANGED	0863bc3f-a7c7-464c-9737-1f49ec6d6a65	user	{"plan": "AGENT", "source": "real-estate-backend", "paymentId": "5f8cdf3b-5b13-4736-8181-a76384880425", "receivedAt": "2026-04-22T23:56:02.594Z", "environment": "development", "schemaVersion": 1}	2026-04-22 23:56:02.597
d155cecb-3318-4168-8a8e-c9920670bb33	0863bc3f-a7c7-464c-9737-1f49ec6d6a65	\N	PAYMENT_COMPLETED	5f8cdf3b-5b13-4736-8181-a76384880425	payment	{"plan": "AGENT", "amount": 29, "source": "real-estate-backend", "purpose": "SUBSCRIPTION", "currency": "USD", "provider": "local", "listingId": null, "receivedAt": "2026-04-22T23:56:02.859Z", "environment": "development", "schemaVersion": 1}	2026-04-22 23:56:02.861
183a8337-0f84-42e8-9719-e3598d200bcb	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-22T23:57:17.179Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-22 23:57:17.18
e1fb6545-203e-4574-a7ce-1e73bb840288	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-22T23:57:17.183Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-22 23:57:17.184
7b32b217-f98c-4e76-8d15-3a4c30fe711f	f0ce40f7-e29c-4791-8928-fb1bcdf6c85f	\N	SUBSCRIPTION_CHANGED	f0ce40f7-e29c-4791-8928-fb1bcdf6c85f	user	{"plan": "AGENT", "source": "real-estate-backend", "paymentId": "9799c762-c370-46c4-838c-8059ed3bbe81", "receivedAt": "2026-04-22T23:58:34.534Z", "environment": "development", "schemaVersion": 1}	2026-04-22 23:58:34.536
86779231-b340-429f-832e-65710ad6dfb0	f0ce40f7-e29c-4791-8928-fb1bcdf6c85f	\N	PAYMENT_COMPLETED	9799c762-c370-46c4-838c-8059ed3bbe81	payment	{"plan": "AGENT", "amount": 29, "source": "real-estate-backend", "purpose": "SUBSCRIPTION", "currency": "USD", "provider": "local", "listingId": null, "receivedAt": "2026-04-22T23:58:35.705Z", "environment": "development", "schemaVersion": 1}	2026-04-22 23:58:35.706
4d0c54b9-7a31-4f05-a162-2b1d281b5390	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-22T23:58:42.805Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-22 23:58:42.806
20ce597c-6647-48ad-ae41-59349f8dcf9b	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-22T23:58:42.808Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-22 23:58:42.809
6aae8aaa-5722-4926-abd0-ad5fc431e5ce	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-23T00:02:33.241Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-23 00:02:33.242
d35ff22b-12a8-4ff0-99a0-73a4373aafdc	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-23T00:02:33.242Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-23 00:02:33.242
304c6c4a-7a04-4f7e-bcf3-07e0ac02584e	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-23T00:02:41.304Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-23 00:02:41.305
9d060208-49d4-4b3e-a178-d5968b698d4f	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": "Haifa", "query": null, "source": "filter_bar", "userId": "f0ce40f7-e29c-4791-8928-fb1bcdf6c85f", "filters": {"city": "Haifa", "type": "APARTMENT"}, "maxPrice": null, "minPrice": null, "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-23T00:03:01.785Z", "environment": "development", "schemaVersion": 1}	2026-04-23 00:03:01.787
2ecd86e9-335d-40a8-a561-f93af58c7d7f	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "source": "real-estate-backend", "filters": {"city": "Haifa", "page": 1, "type": "APARTMENT", "limit": 12}, "receivedAt": "2026-04-23T00:03:01.849Z", "environment": "development", "resultsCount": 3, "schemaVersion": 1}	2026-04-23 00:03:01.85
083d804b-ea7e-4552-8f1c-d6f4768de011	f0ce40f7-e29c-4791-8928-fb1bcdf6c85f	\N	FAVORITE_ADDED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"source": "real-estate-backend", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "receivedAt": "2026-04-23T00:03:06.701Z", "environment": "development", "schemaVersion": 1}	2026-04-23 00:03:06.702
ac2d1b7b-8342-426d-9651-652f9fa59c2a	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	FAVORITE_ADDED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "price": 150000, "source": "real-estate-ui", "userId": "f0ce40f7-e29c-4791-8928-fb1bcdf6c85f", "entityId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-23T00:03:06.913Z", "environment": "development", "schemaVersion": 1}	2026-04-23 00:03:06.914
51f5d8e3-7c0a-4359-b38e-ebc00973a2f7	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "source": "real-estate-backend", "filters": {"city": "Haifa", "page": 1, "type": "APARTMENT", "limit": 12}, "receivedAt": "2026-04-23T00:03:06.982Z", "environment": "development", "resultsCount": 3, "schemaVersion": 1}	2026-04-23 00:03:06.983
a0a76420-4144-4417-94d3-d0d573c6f33f	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "price": 150000, "source": "real-estate-ui", "userId": "f0ce40f7-e29c-4791-8928-fb1bcdf6c85f", "entityId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-23T00:03:11.629Z", "environment": "development", "schemaVersion": 1}	2026-04-23 00:03:11.632
17f8259b-7a3e-4f41-b0aa-47281f899d2b	f0ce40f7-e29c-4791-8928-fb1bcdf6c85f	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000, "source": "real-estate-backend", "receivedAt": "2026-04-23T00:03:11.729Z", "environment": "development", "schemaVersion": 1}	2026-04-23 00:03:11.73
5e9d67f0-78bf-4efe-8a3f-fc4940e1a4ba	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-23T15:36:36.051Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-23 15:36:36.07
3e80c2fe-6b52-4515-b7e5-382b5b935a9b	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-23T15:36:36.073Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-23 15:36:36.075
1eaee5f7-323c-4928-bdb6-98a0d6679579	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	9cc14069-c507-44df-900b-3833cea37ead	listing	{"city": "Um Al Fahm", "price": 80000, "source": "real-estate-ui", "userId": "f0ce40f7-e29c-4791-8928-fb1bcdf6c85f", "entityId": "9cc14069-c507-44df-900b-3833cea37ead", "listingId": "9cc14069-c507-44df-900b-3833cea37ead", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-23T15:36:46.358Z", "environment": "development", "schemaVersion": 1}	2026-04-23 15:36:46.36
96860ecf-8d4d-42bc-ad0c-b524661d4ace	f0ce40f7-e29c-4791-8928-fb1bcdf6c85f	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	9cc14069-c507-44df-900b-3833cea37ead	listing	{"city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "price": 80000, "source": "real-estate-backend", "receivedAt": "2026-04-23T15:36:46.706Z", "environment": "development", "schemaVersion": 1}	2026-04-23 15:36:46.71
d426affa-d056-4f40-876c-4d03d51ba2b0	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"city": "Tel Aviv", "price": 110000, "source": "real-estate-ui", "userId": "f0ce40f7-e29c-4791-8928-fb1bcdf6c85f", "entityId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-23T15:36:54.318Z", "environment": "development", "schemaVersion": 1}	2026-04-23 15:36:54.319
0aae5dee-945b-4351-a8c0-5401f0737eeb	f0ce40f7-e29c-4791-8928-fb1bcdf6c85f	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "price": 110000, "source": "real-estate-backend", "receivedAt": "2026-04-23T15:36:54.413Z", "environment": "development", "schemaVersion": 1}	2026-04-23 15:36:54.414
8ad9c9b6-fff6-48d1-a3c2-3ebe115057e9	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-23T16:23:42.845Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-23 16:23:42.857
9d0db4be-d8f9-455b-a2e1-21270c66aebf	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-23T16:23:42.858Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-23 16:23:42.859
954ae050-1e73-4865-abe5-974ad8caee01	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"city": "Tel Aviv", "price": 110000, "source": "real-estate-ui", "userId": null, "entityId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-23T16:23:53.442Z", "environment": "development", "schemaVersion": 1}	2026-04-23 16:23:53.444
25cb2c80-6291-4824-a67d-6e2a77259151	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "price": 110000, "source": "real-estate-backend", "receivedAt": "2026-04-23T16:23:53.550Z", "environment": "development", "schemaVersion": 1}	2026-04-23 16:23:53.551
f0f5d9ec-35df-446a-8756-bd311f6327af	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-23T16:24:41.910Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-23 16:24:41.91
87c444f4-84ca-4444-baa8-57d09ba8ae00	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": "Haifa", "query": null, "source": "filter_bar", "userId": "f0ce40f7-e29c-4791-8928-fb1bcdf6c85f", "filters": {"city": "Haifa"}, "maxPrice": null, "minPrice": null, "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-23T16:24:52.991Z", "environment": "development", "schemaVersion": 1}	2026-04-23 16:24:52.994
49a9b179-7275-4096-a0c6-97bdfeaf579a	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "source": "real-estate-backend", "filters": {"city": "Haifa", "page": 1, "limit": 12}, "receivedAt": "2026-04-23T16:24:53.058Z", "environment": "development", "resultsCount": 3, "schemaVersion": 1}	2026-04-23 16:24:53.059
85796a17-9f57-4e0f-a0ca-b94a33b05177	f0ce40f7-e29c-4791-8928-fb1bcdf6c85f	\N	FAVORITE_ADDED	51b8a6d1-6450-49a4-b961-3d9bfe465770	listing	{"source": "real-estate-backend", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "receivedAt": "2026-04-23T16:24:58.114Z", "environment": "development", "schemaVersion": 1}	2026-04-23 16:24:58.116
2311d964-82a6-408f-aab3-0b7226b90e00	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	FAVORITE_ADDED	51b8a6d1-6450-49a4-b961-3d9bfe465770	listing	{"city": "Haifa", "price": 7777, "source": "real-estate-ui", "userId": "f0ce40f7-e29c-4791-8928-fb1bcdf6c85f", "entityId": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-23T16:24:58.346Z", "environment": "development", "schemaVersion": 1}	2026-04-23 16:24:58.35
512a26af-5425-4254-89df-2dce88f4b095	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "source": "real-estate-backend", "filters": {"city": "Haifa", "page": 1, "limit": 12}, "receivedAt": "2026-04-23T16:24:58.411Z", "environment": "development", "resultsCount": 3, "schemaVersion": 1}	2026-04-23 16:24:58.411
d1bd70b2-8ebf-4f9d-97ad-1b04553d8302	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-23T16:55:43.452Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-23 16:55:43.461
1b26bd7e-a132-41b5-8c39-3b358940b58f	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-23T16:55:43.463Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-23 16:55:43.464
7492806f-a633-429e-86e1-aa43bea4107e	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 4, "source": "real-estate-backend", "filters": {"page": 1, "sort": "price_low", "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "minPrice": 60000, "bathrooms": 1}, "receivedAt": "2026-04-23T16:57:20.261Z", "environment": "development", "resultsCount": 4, "schemaVersion": 1}	2026-04-23 16:57:20.261
d172967c-9e3a-4fc3-a576-d468604e3640	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": null, "query": null, "source": "filter_bar", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "filters": {"sort": "price_low", "type": "APARTMENT", "rooms": "2", "maxArea": "200", "minArea": "70", "maxPrice": "200000", "minPrice": "60000", "bathrooms": "1"}, "maxPrice": "200000", "minPrice": "60000", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-23T16:57:32.774Z", "environment": "development", "schemaVersion": 1}	2026-04-23 16:57:32.777
31d05f32-2b19-421c-b9f7-4b6110780f05	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 2, "source": "real-estate-backend", "filters": {"page": 1, "sort": "price_low", "type": "APARTMENT", "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "minPrice": 60000, "bathrooms": 1}, "receivedAt": "2026-04-23T16:57:32.833Z", "environment": "development", "resultsCount": 2, "schemaVersion": 1}	2026-04-23 16:57:32.834
abaf5f26-22b1-40d6-b585-d9b45e8edb14	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": null, "query": null, "source": "filter_bar", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "filters": {"sort": "price_low", "type": "APARTMENT", "rooms": "2", "maxArea": "200", "minArea": "70", "maxPrice": "200000", "minPrice": "60000", "bathrooms": "1"}, "maxPrice": "200000", "minPrice": "60000", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-23T16:57:35.681Z", "environment": "development", "schemaVersion": 1}	2026-04-23 16:57:35.681
ce1b2b07-5249-418b-9de9-b84f607ae035	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 2, "source": "real-estate-backend", "filters": {"page": 1, "sort": "price_low", "type": "APARTMENT", "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "minPrice": 60000, "bathrooms": 1}, "receivedAt": "2026-04-23T16:57:35.744Z", "environment": "development", "resultsCount": 2, "schemaVersion": 1}	2026-04-23 16:57:35.744
e5b375fb-b210-4d29-ac34-28d0083a73b2	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": null, "query": null, "source": "filter_bar", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "filters": {"sort": "price_low", "type": "APARTMENT", "rooms": "2", "maxArea": "200", "minArea": "70", "maxPrice": "200000", "minPrice": "60000", "bathrooms": "1"}, "maxPrice": "200000", "minPrice": "60000", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-23T16:57:38.788Z", "environment": "development", "schemaVersion": 1}	2026-04-23 16:57:38.79
f0f86f7c-5368-4ce4-a039-e09539baec54	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 2, "source": "real-estate-backend", "filters": {"page": 1, "sort": "price_low", "type": "APARTMENT", "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "minPrice": 60000, "bathrooms": 1}, "receivedAt": "2026-04-23T16:57:38.837Z", "environment": "development", "resultsCount": 2, "schemaVersion": 1}	2026-04-23 16:57:38.837
370c8d50-0e37-4fa6-9e5d-7211df9582c7	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-23T16:57:40.744Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-23 16:57:40.744
ef0f13b2-4219-45ed-8658-b1e27028624f	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": null, "query": null, "source": "filter_bar", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "filters": {"sort": "price_low", "type": "APARTMENT", "rooms": "2", "maxArea": "200", "minArea": "70", "maxPrice": "200000", "minPrice": "60000", "bathrooms": "1"}, "maxPrice": "200000", "minPrice": "60000", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-23T16:57:44.034Z", "environment": "development", "schemaVersion": 1}	2026-04-23 16:57:44.035
a77a8198-6527-404c-8014-2cc006e72a32	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 2, "source": "real-estate-backend", "filters": {"page": 1, "sort": "price_low", "type": "APARTMENT", "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "minPrice": 60000, "bathrooms": 1}, "receivedAt": "2026-04-23T16:57:44.107Z", "environment": "development", "resultsCount": 2, "schemaVersion": 1}	2026-04-23 16:57:44.107
75ed2f13-5b59-47cf-bad8-5b202412001f	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": null, "query": null, "source": "filter_bar", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "filters": {"sort": "price_low", "type": "APARTMENT", "rooms": "2", "maxArea": "200", "minArea": "70", "maxPrice": "200000", "minPrice": "60000", "bathrooms": "1"}, "maxPrice": "200000", "minPrice": "60000", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-23T16:57:49.418Z", "environment": "development", "schemaVersion": 1}	2026-04-23 16:57:49.42
0cb15d4b-28f7-43cf-8fd2-15ee0fd9cd15	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 2, "source": "real-estate-backend", "filters": {"page": 1, "sort": "price_low", "type": "APARTMENT", "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "minPrice": 60000, "bathrooms": 1}, "receivedAt": "2026-04-23T16:57:49.483Z", "environment": "development", "resultsCount": 2, "schemaVersion": 1}	2026-04-23 16:57:49.483
491dcb75-29e8-41c3-bc56-b6c2e8e73700	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": null, "query": null, "source": "filter_bar", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "filters": {"sort": "price_low", "type": "HOUSE", "rooms": "2", "maxArea": "200", "minArea": "70", "maxPrice": "200000", "minPrice": "60000", "bathrooms": "1"}, "maxPrice": "200000", "minPrice": "60000", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-23T16:57:57.137Z", "environment": "development", "schemaVersion": 1}	2026-04-23 16:57:57.137
ae16f2c1-2742-469b-b30f-1cde8dc1f1af	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 2, "source": "real-estate-backend", "filters": {"page": 1, "sort": "price_low", "type": "HOUSE", "limit": 12, "rooms": 2, "maxArea": 200, "minArea": 70, "maxPrice": 200000, "minPrice": 60000, "bathrooms": 1}, "receivedAt": "2026-04-23T16:57:57.187Z", "environment": "development", "resultsCount": 2, "schemaVersion": 1}	2026-04-23 16:57:57.187
b8d89d29-1208-44bb-b42b-45d4bf80cbdb	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	51b8a6d1-6450-49a4-b961-3d9bfe465770	listing	{"city": "Haifa", "price": 7777, "source": "real-estate-ui", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "entityId": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "listingId": "51b8a6d1-6450-49a4-b961-3d9bfe465770", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-23T16:58:13.949Z", "environment": "development", "schemaVersion": 1}	2026-04-23 16:58:13.954
218aceeb-713b-49fd-bef4-e22d3c10da99	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	51b8a6d1-6450-49a4-b961-3d9bfe465770	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 7777, "source": "real-estate-backend", "receivedAt": "2026-04-23T16:58:14.102Z", "environment": "development", "schemaVersion": 1}	2026-04-23 16:58:14.104
b04a9bca-17a2-4a60-b425-49b5155733dc	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "price": 150000, "source": "real-estate-ui", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "entityId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-23T16:58:20.926Z", "environment": "development", "schemaVersion": 1}	2026-04-23 16:58:20.928
08cf53da-13ed-407f-8073-796d1b05da78	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000, "source": "real-estate-backend", "receivedAt": "2026-04-23T16:58:20.917Z", "environment": "development", "schemaVersion": 1}	2026-04-23 16:58:20.92
ea725f8f-6ae7-4e2a-a1d9-fac39f77de36	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	INQUIRY_CREATED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"leadId": "565a4e73-9d01-4735-abed-df352fadab44", "source": "listing_details", "receivedAt": "2026-04-23T16:58:52.189Z", "environment": "development", "ownerUserId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "schemaVersion": 1}	2026-04-23 16:58:52.19
47d8f1de-1e1e-4402-9b24-2dac2baffa59	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	INQUIRY_CREATED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "price": 150000, "source": "listing_details", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "entityId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-23T16:58:52.455Z", "environment": "development", "schemaVersion": 1}	2026-04-23 16:58:52.456
332f360e-b37e-4982-9342-6460343e0082	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_content	{"city": null, "mode": "RENT", "action": "generate_listing_content", "source": "add_listing", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing_content", "receivedAt": "2026-04-23T16:59:17.041Z", "environment": "development", "propertyType": "APARTMENT", "schemaVersion": 1}	2026-04-23 16:59:17.044
05058db7-88a7-48c3-9c61-bf879bba7cf6	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-23T17:00:25.922Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-23 17:00:25.922
823de80a-7916-43bc-8cd6-0983f051a8c4	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 7, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-23T17:00:49.477Z", "environment": "development", "resultsCount": 7, "schemaVersion": 1}	2026-04-23 17:00:49.479
d03dd2f7-4720-4a4b-ba00-1589308bb0ee	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-23T17:01:40.397Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-23 17:01:40.398
72535849-7599-4538-a6a1-111bd0ee647d	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-24T07:39:26.849Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-24 07:39:26.85
e625a8aa-2faf-482d-8228-e7231d47129f	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-24T07:39:26.824Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-24 07:39:26.844
067d8a41-2692-4460-a255-2948d108d295	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-24T07:40:36.193Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-24 07:40:36.196
e0ccaf3f-678e-444e-95b4-a8d47e33e376	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	search	{"query": "apartment in Haifa", "source": "ai_search", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "filters": {"q": null, "city": "Haifa", "mode": null, "sort": null, "type": "APARTMENT", "rooms": null, "maxArea": null, "minArea": null, "maxPrice": null, "minPrice": null, "bathrooms": null}, "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "confidence": 0.65, "entityType": "search", "receivedAt": "2026-04-24T07:42:18.619Z", "environment": "development", "explanation": "Parsed search intent with local fallback rules.", "schemaVersion": 1}	2026-04-24 07:42:18.622
1181cef7-3a01-417e-9ad7-65f8dc7813e3	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": "Haifa", "query": null, "source": "filter_bar", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "filters": {"city": "Haifa", "type": "APARTMENT"}, "maxPrice": null, "minPrice": null, "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-24T07:42:18.632Z", "environment": "development", "schemaVersion": 1}	2026-04-24 07:42:18.635
51557b1a-337c-4b2c-a107-cbf64c4d74a1	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "source": "real-estate-backend", "filters": {"city": "Haifa", "page": 1, "type": "APARTMENT", "limit": 12}, "receivedAt": "2026-04-24T07:42:18.880Z", "environment": "development", "resultsCount": 3, "schemaVersion": 1}	2026-04-24 07:42:18.881
3e570a38-127c-4a4f-a985-49e845859c6d	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": null, "query": null, "source": "filter_bar", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "filters": {"mode": "RENT", "sort": "price_high", "type": "APARTMENT", "rooms": "3", "maxArea": "300", "minArea": "50", "maxPrice": "200000", "minPrice": "1000", "bathrooms": "2"}, "maxPrice": "200000", "minPrice": "1000", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-24T07:43:05.654Z", "environment": "development", "schemaVersion": 1}	2026-04-24 07:43:05.655
fde29199-e20c-4faa-af69-d15933927c96	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "source": "real-estate-backend", "filters": {"mode": "RENT", "page": 1, "sort": "price_high", "type": "APARTMENT", "limit": 12, "rooms": 3, "maxArea": 300, "minArea": 50, "maxPrice": 200000, "minPrice": 1000, "bathrooms": 2}, "receivedAt": "2026-04-24T07:43:05.736Z", "environment": "development", "resultsCount": 3, "schemaVersion": 1}	2026-04-24 07:43:05.737
b9442fda-a048-4602-8425-09e1bf886986	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": null, "query": null, "source": "filter_bar", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "filters": {"mode": "SALE", "sort": "price_high", "type": "APARTMENT", "rooms": "3", "maxArea": "300", "minArea": "50", "maxPrice": "200000", "minPrice": "1000", "bathrooms": "2"}, "maxPrice": "200000", "minPrice": "1000", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-24T07:43:12.939Z", "environment": "development", "schemaVersion": 1}	2026-04-24 07:43:12.939
de2a8f27-631f-46e6-a5db-7d0f71f8043a	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-25T06:45:44.394Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-25 06:45:44.406
1ffab19a-cbb4-4644-8ad9-135985081e76	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 0, "source": "real-estate-backend", "filters": {"mode": "SALE", "page": 1, "sort": "price_high", "type": "APARTMENT", "limit": 12, "rooms": 3, "maxArea": 300, "minArea": 50, "maxPrice": 200000, "minPrice": 1000, "bathrooms": 2}, "receivedAt": "2026-04-24T07:43:12.999Z", "environment": "development", "resultsCount": 0, "schemaVersion": 1}	2026-04-24 07:43:13
751d5600-58cc-4ea5-94d8-28b14f2693f9	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": null, "query": null, "source": "filter_bar", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "filters": {"mode": "SALE", "sort": "price_high", "type": "APARTMENT", "rooms": "3", "maxArea": "300", "minArea": "50", "maxPrice": "200000", "minPrice": "1000", "bathrooms": "2"}, "maxPrice": "200000", "minPrice": "1000", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-24T07:43:16.811Z", "environment": "development", "schemaVersion": 1}	2026-04-24 07:43:16.812
c80172e2-2cd6-4b24-a498-cae0c66900bc	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 0, "source": "real-estate-backend", "filters": {"mode": "SALE", "page": 1, "sort": "price_high", "type": "APARTMENT", "limit": 12, "rooms": 3, "maxArea": 300, "minArea": 50, "maxPrice": 200000, "minPrice": 1000, "bathrooms": 2}, "receivedAt": "2026-04-24T07:43:16.876Z", "environment": "development", "resultsCount": 0, "schemaVersion": 1}	2026-04-24 07:43:16.876
8d143a6f-2155-40e5-8808-872c27740936	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": null, "query": null, "source": "filter_bar", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "filters": {"mode": "SALE", "sort": "price_high", "type": "APARTMENT", "rooms": "3", "maxArea": "300", "minArea": "50", "maxPrice": "200000", "minPrice": "1000", "bathrooms": "2"}, "maxPrice": "200000", "minPrice": "1000", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-24T07:43:20.961Z", "environment": "development", "schemaVersion": 1}	2026-04-24 07:43:20.962
130436b1-35f4-4509-be24-fc73624eb172	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 0, "source": "real-estate-backend", "filters": {"mode": "SALE", "page": 1, "sort": "price_high", "type": "APARTMENT", "limit": 12, "rooms": 3, "maxArea": 300, "minArea": 50, "maxPrice": 200000, "minPrice": 1000, "bathrooms": 2}, "receivedAt": "2026-04-24T07:43:21.024Z", "environment": "development", "resultsCount": 0, "schemaVersion": 1}	2026-04-24 07:43:21.024
197a9271-065c-4a04-b19d-a1d38be4130d	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": null, "query": null, "source": "filter_bar", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "filters": {"mode": "RENT", "sort": "price_high", "type": "APARTMENT", "rooms": "3", "maxArea": "300", "minArea": "50", "maxPrice": "200000", "minPrice": "1000", "bathrooms": "2"}, "maxPrice": "200000", "minPrice": "1000", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-24T07:43:26.027Z", "environment": "development", "schemaVersion": 1}	2026-04-24 07:43:26.028
00e00186-7a64-4b2b-abad-fe4b5a8a4ebd	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "source": "real-estate-backend", "filters": {"mode": "RENT", "page": 1, "sort": "price_high", "type": "APARTMENT", "limit": 12, "rooms": 3, "maxArea": 300, "minArea": 50, "maxPrice": 200000, "minPrice": 1000, "bathrooms": 2}, "receivedAt": "2026-04-24T07:43:26.081Z", "environment": "development", "resultsCount": 3, "schemaVersion": 1}	2026-04-24 07:43:26.082
9c070eed-77dd-4f25-a353-34ec1d906ab9	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": null, "query": null, "source": "filter_bar", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "filters": {"mode": "RENT", "sort": "price_high", "type": "APARTMENT", "rooms": "3", "maxArea": "300", "minArea": "50", "maxPrice": "200000", "minPrice": "1000", "bathrooms": "2"}, "maxPrice": "200000", "minPrice": "1000", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-24T07:43:33.140Z", "environment": "development", "schemaVersion": 1}	2026-04-24 07:43:33.141
798c9dbe-b26f-4dcb-a0ab-07b7131846e2	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "source": "real-estate-backend", "filters": {"mode": "RENT", "page": 1, "sort": "price_high", "type": "APARTMENT", "limit": 12, "rooms": 3, "maxArea": 300, "minArea": 50, "maxPrice": 200000, "minPrice": 1000, "bathrooms": 2}, "receivedAt": "2026-04-24T07:43:33.201Z", "environment": "development", "resultsCount": 3, "schemaVersion": 1}	2026-04-24 07:43:33.202
5e77da33-b3be-4b0a-b645-b3591f29d0e8	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	SAVED_SEARCH_CREATED	134f606d-c9c4-4e33-afb8-45dd57b1a237	saved_search	{"name": "Saved search3", "source": "real-estate-backend", "filters": {"mode": "RENT", "sort": "price_high", "type": "APARTMENT", "rooms": "3", "maxArea": "300", "minArea": "50", "maxPrice": "200000", "minPrice": "1000", "bathrooms": "2"}, "receivedAt": "2026-04-24T07:43:40.863Z", "environment": "development", "schemaVersion": 1}	2026-04-24 07:43:40.867
0397d117-1086-4780-a527-14d3d784895d	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-24T07:43:42.383Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-24 07:43:42.384
b31c6082-a357-4251-8ea9-f2429b22953f	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "price": 150000, "source": "real-estate-ui", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "entityId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-24T07:44:18.016Z", "environment": "development", "schemaVersion": 1}	2026-04-24 07:44:18.018
b61e4316-d13d-4c91-a800-37f21eb78a0d	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000, "source": "real-estate-backend", "receivedAt": "2026-04-24T07:44:18.177Z", "environment": "development", "schemaVersion": 1}	2026-04-24 07:44:18.179
8388a3c9-727e-42e4-92be-af4bca630612	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_content	{"city": null, "mode": "RENT", "action": "generate_listing_content", "source": "add_listing", "userId": "056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing_content", "receivedAt": "2026-04-24T07:47:35.837Z", "environment": "development", "propertyType": "APARTMENT", "schemaVersion": 1}	2026-04-24 07:47:35.838
f89d60ea-d64c-4d79-8b93-0bd3c8e624eb	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-25T06:45:44.408Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-25 06:45:44.408
503d75d2-ce97-4254-893b-ddbe08630ec2	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-25T21:05:00.069Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-25 21:05:00.083
02bcd2eb-7ec2-4d28-8fb2-5aaa0561d266	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-25T21:05:00.086Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-25 21:05:00.087
373b70af-d25b-448b-bb3e-a8cce0e2ba76	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-25T21:05:17.346Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-25 21:05:17.348
7d53c520-1cc9-49db-b66d-31b97bc807f1	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	search	{"query": "شقة للطلاب في حيفا", "source": "ai_search", "userId": "056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4", "filters": {"q": "students", "city": "Haifa", "mode": null, "sort": "price_low", "type": "APARTMENT", "rooms": null, "maxArea": null, "minArea": null, "maxPrice": null, "minPrice": null, "bathrooms": null}, "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "confidence": 0.73, "entityType": "search", "receivedAt": "2026-04-25T21:05:38.723Z", "environment": "development", "explanation": "Parsed search intent with local fallback rules.", "schemaVersion": 1}	2026-04-25 21:05:38.728
6e640c4c-d33c-4984-990d-a7fbd5bd7469	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": "Haifa", "query": "students", "source": "filter_bar", "userId": "056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4", "filters": {"q": "students", "city": "Haifa", "sort": "price_low", "type": "APARTMENT"}, "maxPrice": null, "minPrice": null, "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-25T21:05:38.737Z", "environment": "development", "schemaVersion": 1}	2026-04-25 21:05:38.74
c06d77c7-880a-4e11-b358-4573aef9d0ab	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 0, "source": "real-estate-backend", "filters": {"q": "students", "city": "Haifa", "page": 1, "sort": "price_low", "type": "APARTMENT", "limit": 12}, "receivedAt": "2026-04-25T21:05:38.899Z", "environment": "development", "resultsCount": 0, "schemaVersion": 1}	2026-04-25 21:05:38.901
c7232464-dfbe-45d0-9493-3ae9d127718a	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	search	{"query": "شقة للطلاب في حيفا للايجار", "source": "ai_search", "userId": "056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4", "filters": {"q": "students", "city": "Haifa", "mode": "RENT", "sort": "price_low", "type": "APARTMENT", "rooms": null, "maxArea": null, "minArea": null, "maxPrice": null, "minPrice": null, "bathrooms": null}, "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "confidence": 0.83, "entityType": "search", "receivedAt": "2026-04-25T21:05:57.888Z", "environment": "development", "explanation": "Parsed search intent with local fallback rules.", "schemaVersion": 1}	2026-04-25 21:05:57.889
5a6a057c-fd73-46e9-8d24-4bb29875899d	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": "Haifa", "query": "students", "source": "filter_bar", "userId": "056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4", "filters": {"q": "students", "city": "Haifa", "mode": "RENT", "sort": "price_low", "type": "APARTMENT"}, "maxPrice": null, "minPrice": null, "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-25T21:05:57.895Z", "environment": "development", "schemaVersion": 1}	2026-04-25 21:05:57.896
87859da5-5599-430c-bb7e-393f1202373e	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 0, "source": "real-estate-backend", "filters": {"q": "students", "city": "Haifa", "mode": "RENT", "page": 1, "sort": "price_low", "type": "APARTMENT", "limit": 12}, "receivedAt": "2026-04-25T21:05:58.015Z", "environment": "development", "resultsCount": 0, "schemaVersion": 1}	2026-04-25 21:05:58.017
e34162d4-91d5-40fd-bb0f-608ee5560dde	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	search	{"query": "شقة للطلاب في حيفا للايجار يوجد فيها اكثر من غرفتين", "source": "ai_search", "userId": "056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4", "filters": {"q": "students", "city": "Haifa", "mode": "RENT", "sort": "price_low", "type": "APARTMENT", "rooms": null, "maxArea": null, "minArea": null, "maxPrice": null, "minPrice": null, "bathrooms": null}, "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "confidence": 0.83, "entityType": "search", "receivedAt": "2026-04-25T21:06:26.972Z", "environment": "development", "explanation": "Parsed search intent with local fallback rules.", "schemaVersion": 1}	2026-04-25 21:06:26.973
ea6541de-91f7-47bf-9f5a-03e88baa1a92	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": "Haifa", "query": "students", "source": "filter_bar", "userId": "056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4", "filters": {"q": "students", "city": "Haifa", "mode": "RENT", "sort": "price_low", "type": "APARTMENT"}, "maxPrice": null, "minPrice": null, "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-25T21:06:26.990Z", "environment": "development", "schemaVersion": 1}	2026-04-25 21:06:26.992
a411f8e2-8913-44f8-afae-1169dd2706c0	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 0, "source": "real-estate-backend", "filters": {"q": "students", "city": "Haifa", "mode": "RENT", "page": 1, "sort": "price_low", "type": "APARTMENT", "limit": 12}, "receivedAt": "2026-04-25T21:06:27.104Z", "environment": "development", "resultsCount": 0, "schemaVersion": 1}	2026-04-25 21:06:27.106
7096183f-ae8b-41f1-a206-f685f5ca4ec6	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-25T21:06:35.342Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-25 21:06:35.343
70cafcd0-0acf-485e-bead-2f022ae7d97f	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": "Haifa", "query": "students", "source": "filter_bar", "userId": "056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4", "filters": {"q": "students", "city": "Haifa", "mode": "RENT", "sort": "price_low", "type": "APARTMENT"}, "maxPrice": null, "minPrice": null, "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-25T21:06:53.836Z", "environment": "development", "schemaVersion": 1}	2026-04-25 21:06:53.838
cdb24530-a740-4836-b15a-7ee6eb947fda	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 0, "source": "real-estate-backend", "filters": {"q": "students", "city": "Haifa", "mode": "RENT", "page": 1, "sort": "price_low", "type": "APARTMENT", "limit": 12}, "receivedAt": "2026-04-25T21:06:53.946Z", "environment": "development", "resultsCount": 0, "schemaVersion": 1}	2026-04-25 21:06:53.946
0e7a7707-57a8-4bad-9b0d-f31b8e963fae	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 0, "source": "real-estate-backend", "filters": {"q": "students", "city": "Haifa", "mode": "RENT", "page": 1, "type": "APARTMENT", "limit": 12}, "receivedAt": "2026-04-25T21:06:58.970Z", "environment": "development", "resultsCount": 0, "schemaVersion": 1}	2026-04-25 21:06:58.97
851ac032-8b22-4ea4-b6eb-703bd17a0311	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": "Haifa", "query": null, "source": "filter_bar", "userId": "056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4", "filters": {"city": "Haifa", "mode": "RENT", "type": "APARTMENT"}, "maxPrice": null, "minPrice": null, "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-25T21:07:04.854Z", "environment": "development", "schemaVersion": 1}	2026-04-25 21:07:04.855
c5460fb9-dc93-4ec8-b43a-dd8c0553afbe	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "source": "real-estate-backend", "filters": {"city": "Haifa", "mode": "RENT", "page": 1, "type": "APARTMENT", "limit": 12}, "receivedAt": "2026-04-25T21:07:04.921Z", "environment": "development", "resultsCount": 3, "schemaVersion": 1}	2026-04-25 21:07:04.922
942bc8c2-03b7-4741-ae49-b6cd54dcf10f	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "price": 150000, "source": "real-estate-ui", "userId": "056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4", "entityId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-25T21:07:12.288Z", "environment": "development", "schemaVersion": 1}	2026-04-25 21:07:12.293
d187b8e6-4f5b-4552-a40b-9ae1b80ae7e7	056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000, "source": "real-estate-backend", "receivedAt": "2026-04-25T21:07:12.364Z", "environment": "development", "schemaVersion": 1}	2026-04-25 21:07:12.367
178ba6f8-c315-4b07-b2c2-d45303784f16	056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4	\N	FAVORITE_ADDED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"source": "real-estate-backend", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "receivedAt": "2026-04-25T21:07:33.676Z", "environment": "development", "schemaVersion": 1}	2026-04-25 21:07:33.678
a88b2fbf-39f6-4f8b-91f1-cd546ed38485	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	FAVORITE_ADDED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "price": 150000, "source": "real-estate-ui", "userId": "056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4", "entityId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-25T21:07:33.938Z", "environment": "development", "schemaVersion": 1}	2026-04-25 21:07:33.94
c093a985-917b-4fc0-b20c-9ebf45cb7336	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "source": "real-estate-backend", "filters": {"city": "Haifa", "mode": "RENT", "page": 1, "type": "APARTMENT", "limit": 12}, "receivedAt": "2026-04-25T21:07:34.067Z", "environment": "development", "resultsCount": 3, "schemaVersion": 1}	2026-04-25 21:07:34.068
d23070cd-96bc-49da-a957-24f507630aac	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_content	{"city": null, "mode": "RENT", "action": "generate_listing_content", "source": "add_listing", "userId": "056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing_content", "receivedAt": "2026-04-25T21:08:00.065Z", "environment": "development", "propertyType": "APARTMENT", "schemaVersion": 1}	2026-04-25 21:08:00.065
5d80563f-f9d5-4928-9055-556436a444a8	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_REJECTED	\N	listing_content	{"mode": "RENT", "action": "undo_generated_listing_content", "source": "add_listing", "userId": "056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing_content", "receivedAt": "2026-04-25T21:08:05.210Z", "environment": "development", "propertyType": "APARTMENT", "schemaVersion": 1}	2026-04-25 21:08:05.215
bf5e1d1e-daed-4ace-a707-45cb095e0de7	056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4	\N	VERIFICATION_REQUESTED	056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4	user	{"source": "real-estate-backend", "receivedAt": "2026-04-25T21:08:12.676Z", "environment": "development", "schemaVersion": 1}	2026-04-25 21:08:12.679
ee3293d5-5e0c-4d72-8021-3aef2e12573b	056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4	\N	SUBSCRIPTION_CHANGED	056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4	user	{"plan": "AGENT", "source": "real-estate-backend", "paymentId": "03194990-5d53-4426-80ff-d6671687852b", "receivedAt": "2026-04-25T21:08:35.852Z", "environment": "development", "schemaVersion": 1}	2026-04-25 21:08:35.855
41d771f2-c37b-4e42-ba86-b67d42ab9757	056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4	\N	PAYMENT_COMPLETED	03194990-5d53-4426-80ff-d6671687852b	payment	{"plan": "AGENT", "amount": 29, "source": "real-estate-backend", "purpose": "SUBSCRIPTION", "currency": "USD", "provider": "local", "listingId": null, "receivedAt": "2026-04-25T21:08:36.132Z", "environment": "development", "schemaVersion": 1}	2026-04-25 21:08:36.134
0fcf6a2b-9404-4450-9b9a-cb4c1c6969a8	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-25T21:09:20.599Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-25 21:09:20.6
09b777ad-a650-4d8c-9788-675038308263	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-25T21:09:20.602Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1}	2026-04-25 21:09:20.603
a4b946cd-dad4-4b4e-bbae-7e278f117bc1	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-25T22:37:54.294Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1, "searchVariant": null}	2026-04-25 22:37:54.301
99107ae8-96a5-4429-aa40-bdacaf094f8f	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-25T22:37:54.304Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1, "searchVariant": null}	2026-04-25 22:37:54.306
0dc90cd6-81f8-4afc-9bf7-dbe6f579e8bd	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-25T22:38:23.994Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1, "searchVariant": null}	2026-04-25 22:38:23.996
36e8dc49-078d-46c0-b0a2-ab3a1b8b8ad2	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-25T22:38:24.100Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1, "searchVariant": null}	2026-04-25 22:38:24.102
30c6b5a6-39f8-44dd-9367-d24a082528cf	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	EXPERIMENT_EXPOSED	search_v2	experiment	{"source": "real-estate-ui", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "surface": "listings_page", "variant": "B", "entityId": "search_v2", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "experiment", "receivedAt": "2026-04-25T22:38:26.076Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "B"}, "experimentKey": "search_v2", "schemaVersion": 1}	2026-04-25 22:38:26.079
a93f003b-7e91-466f-a60e-c6e7cd5e5ab5	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12, "searchVariant": "B"}, "receivedAt": "2026-04-25T22:38:26.142Z", "environment": "development", "experiments": {"search_v2": "B"}, "resultsCount": 8, "schemaVersion": 1, "searchVariant": "B"}	2026-04-25 22:38:26.143
6002f9f5-2cb2-4694-9458-2ae2ebb0e65a	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12, "searchVariant": "B"}, "receivedAt": "2026-04-25T22:38:26.145Z", "environment": "development", "experiments": {"search_v2": "B"}, "resultsCount": 8, "schemaVersion": 1, "searchVariant": "B"}	2026-04-25 22:38:26.146
a6364206-4e03-4d52-9715-6522948e80c0	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	SEARCH_PERFORMED	\N	search	{"city": "Haifa", "query": null, "source": "filter_bar", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "filters": {"city": "Haifa", "mode": "RENT", "type": "APARTMENT"}, "maxPrice": null, "minPrice": null, "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "search", "receivedAt": "2026-04-25T22:38:30.322Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "B"}, "schemaVersion": 1, "searchVariant": "B"}	2026-04-25 22:38:30.325
47a1ffe8-d113-4f0f-98d9-b15dd642d2e6	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 3, "source": "real-estate-backend", "filters": {"city": "Haifa", "mode": "RENT", "page": 1, "type": "APARTMENT", "limit": 12, "searchVariant": "B"}, "receivedAt": "2026-04-25T22:38:30.412Z", "environment": "development", "experiments": {"search_v2": "B"}, "resultsCount": 3, "schemaVersion": 1, "searchVariant": "B"}	2026-04-25 22:38:30.413
46428d48-9e58-4447-b527-165e0fcbb7f9	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-25T22:38:39.922Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1, "searchVariant": null}	2026-04-25 22:38:39.922
60c9b233-41d8-4eda-ab0e-f92628ace881	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12, "searchVariant": "B"}, "receivedAt": "2026-04-25T22:38:40.571Z", "environment": "development", "experiments": {"search_v2": "B"}, "resultsCount": 8, "schemaVersion": 1, "searchVariant": "B"}	2026-04-25 22:38:40.575
7aa9f4f9-53ef-4250-8c46-36eab1a12fb3	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	EXPERIMENT_EXPOSED	ai_ranking_v1	experiment	{"source": "real-estate-ui", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "surface": "listing_recommendations", "variant": "B", "entityId": "ai_ranking_v1", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "experiment", "receivedAt": "2026-04-25T22:38:54.517Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "B"}, "experimentKey": "ai_ranking_v1", "schemaVersion": 1}	2026-04-25 22:38:54.519
b2f25cd5-f60f-4bd4-971e-a6413f74ca77	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "price": 150000, "source": "real-estate-ui", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "entityId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-25T22:38:54.524Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "B"}, "schemaVersion": 1}	2026-04-25 22:38:54.536
3ea78742-3d78-4fa6-aa1d-0b9db560add4	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	EXPERIMENT_EXPOSED	recommendation_v2	experiment	{"source": "real-estate-ui", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "surface": "listing_recommendations", "variant": "B", "entityId": "recommendation_v2", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "experiment", "receivedAt": "2026-04-25T22:38:54.847Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "B"}, "experimentKey": "recommendation_v2", "schemaVersion": 1}	2026-04-25 22:38:54.848
08d2012a-a828-44ce-a85b-4b9c0ee55f03	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000, "source": "real-estate-backend", "receivedAt": "2026-04-25T22:38:54.967Z", "environment": "development", "schemaVersion": 1}	2026-04-25 22:38:54.972
46ceda42-b8f6-48b2-9428-327fb6490092	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "price": 120000, "source": "real-estate-ui", "userId": "b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c", "entityId": "c901de33-674a-444d-8892-259897e9e4a9", "listingId": "c901de33-674a-444d-8892-259897e9e4a9", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-25T22:39:00.996Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "B"}, "schemaVersion": 1}	2026-04-25 22:39:00.998
f73da10d-fc8c-4295-b010-27e8802358a2	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000, "source": "real-estate-backend", "receivedAt": "2026-04-25T22:39:01.224Z", "environment": "development", "schemaVersion": 1}	2026-04-25 22:39:01.226
8e1f2116-ed4b-4cce-b13d-d5c7f82b42e2	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 8, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-25T22:39:34.959Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1, "searchVariant": null}	2026-04-25 22:39:34.96
d7654de1-e9f6-4216-a120-8cbb8c46ca5f	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-25T22:39:34.962Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1, "searchVariant": null}	2026-04-25 22:39:34.963
bce6dd26-0436-49b2-af43-c0da51ddf8ad	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-25T22:40:52.999Z", "environment": "development", "resultsCount": 8, "schemaVersion": 1, "searchVariant": null}	2026-04-25 22:40:53
eeecf450-1f7d-47d4-a01f-92324a468bbe	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12, "searchVariant": "B"}, "receivedAt": "2026-04-25T22:40:54.772Z", "environment": "development", "experiments": {"search_v2": "B"}, "resultsCount": 8, "schemaVersion": 1, "searchVariant": "B"}	2026-04-25 22:40:54.773
96046dc9-42fb-4a03-9f30-8d9624fc4f1e	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 8, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12, "searchVariant": "B"}, "receivedAt": "2026-04-25T22:40:54.833Z", "environment": "development", "experiments": {"search_v2": "B"}, "resultsCount": 8, "schemaVersion": 1, "searchVariant": "B"}	2026-04-25 22:40:54.835
eff0a0e3-4a27-4824-a388-9fd4479c8e98	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	LISTING_UPDATED	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	listing	{"source": "real-estate-backend", "status": "PUBLISHED", "receivedAt": "2026-04-25T22:41:25.066Z", "environment": "development", "changedFields": ["title", "description", "price", "city", "neighborhood", "type", "mode", "status", "rooms", "bathrooms", "area", "image", "images"], "schemaVersion": 1}	2026-04-25 22:41:25.067
06b8fdea-dec6-4c30-8f31-2665d837863d	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 9, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12}, "receivedAt": "2026-04-25T22:41:27.621Z", "environment": "development", "resultsCount": 9, "schemaVersion": 1, "searchVariant": null}	2026-04-25 22:41:27.621
c4c5a0ad-9a60-4e2e-a643-a76c73dfb36a	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 9, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12, "searchVariant": "B"}, "receivedAt": "2026-04-25T22:41:28.073Z", "environment": "development", "experiments": {"search_v2": "B"}, "resultsCount": 9, "schemaVersion": 1, "searchVariant": "B"}	2026-04-25 22:41:28.073
baeb51f5-db9a-4824-8230-e15f48ed1bf0	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 9, "source": "real-estate-backend", "filters": {"page": 1, "limit": 12, "searchVariant": "B"}, "receivedAt": "2026-04-25T22:41:28.150Z", "environment": "development", "experiments": {"search_v2": "B"}, "resultsCount": 9, "schemaVersion": 1, "searchVariant": "B"}	2026-04-25 22:41:28.152
73a3a36c-2369-49e6-921f-4d7db8e63101	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 9, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-26T09:09:45.190Z", "environment": "development", "resultsCount": 9, "schemaVersion": 1, "searchVariant": null}	2026-04-26 09:09:45.192
8c53cee2-79c1-4759-b21a-70a82ec0ffd9	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 9, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-26T09:09:45.150Z", "environment": "development", "resultsCount": 9, "schemaVersion": 1, "searchVariant": null}	2026-04-26 09:09:45.186
9f6bef09-506e-48fe-8aca-18a6001458cc	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 9, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-26T09:09:45.457Z", "environment": "development", "resultsCount": 9, "schemaVersion": 1, "searchVariant": null}	2026-04-26 09:09:45.458
f516baf0-bb9b-4c22-8bf1-f5d8426e9d2f	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 9, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-26T09:09:45.796Z", "environment": "development", "resultsCount": 9, "schemaVersion": 1, "searchVariant": null}	2026-04-26 09:09:45.798
52be61d4-f69f-4de7-8b84-cd26920c6e4f	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 9, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-26T09:09:45.852Z", "environment": "development", "resultsCount": 9, "schemaVersion": 1, "searchVariant": null}	2026-04-26 09:09:45.854
dcbe1edb-0c3b-42bf-ae6e-3c97e5475553	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 9, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-26T09:09:45.980Z", "environment": "development", "resultsCount": 9, "schemaVersion": 1, "searchVariant": null}	2026-04-26 09:09:45.981
77ea6e02-e20b-4eed-9a93-ca8a097e2340	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 9, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-26T09:10:41.032Z", "environment": "development", "resultsCount": 9, "schemaVersion": 1, "searchVariant": null}	2026-04-26 09:10:41.041
d199121d-69c5-4b82-be1e-7091e5ee1330	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 9, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-26T09:10:41.083Z", "environment": "development", "resultsCount": 9, "schemaVersion": 1, "searchVariant": null}	2026-04-26 09:10:41.085
66357446-2e1e-4a15-bf56-032864fbeb0c	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_content	{"city": "Tbilisi", "mode": "RENT", "action": "generate_listing_content", "source": "add_listing", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing_content", "receivedAt": "2026-04-26T09:12:05.892Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "propertyType": "APARTMENT", "schemaVersion": 1}	2026-04-26 09:12:05.893
8f8a0c2f-091f-4777-b1cb-bb9f6443a15b	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_REJECTED	\N	listing_content	{"mode": "RENT", "action": "undo_generated_listing_content", "source": "add_listing", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing_content", "receivedAt": "2026-04-26T09:12:31.343Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "propertyType": "APARTMENT", "schemaVersion": 1}	2026-04-26 09:12:31.346
f854bd75-9d48-42f0-b386-947bb807e779	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_content	{"city": "Tbilisi", "mode": "RENT", "action": "generate_listing_content", "source": "add_listing", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing_content", "receivedAt": "2026-04-26T09:12:36.713Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "propertyType": "APARTMENT", "schemaVersion": 1}	2026-04-26 09:12:36.713
8e4ac4dc-c083-454b-9d83-eef2d9e55e55	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	\N	LISTING_CREATED	959feec8-ec17-4e75-8d29-af4f57913c84	listing	{"city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "price": 70000, "source": "real-estate-backend", "status": "PUBLISHED", "receivedAt": "2026-04-26T09:12:46.684Z", "environment": "development", "schemaVersion": 1}	2026-04-26 09:12:46.686
b8f65c18-906e-4608-b87e-195fb6dc3dd1	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	EXPERIMENT_EXPOSED	ai_ranking_v1	experiment	{"source": "real-estate-ui", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "surface": "listing_recommendations", "variant": "B", "entityId": "ai_ranking_v1", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "experiment", "receivedAt": "2026-04-26T09:12:50.525Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "experimentKey": "ai_ranking_v1", "schemaVersion": 1}	2026-04-26 09:12:50.527
013e4aec-853b-4c1b-a4d8-941a83982ba3	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	EXPERIMENT_EXPOSED	recommendation_v2	experiment	{"source": "real-estate-ui", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "surface": "listing_recommendations", "variant": "A", "entityId": "recommendation_v2", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "experiment", "receivedAt": "2026-04-26T09:12:50.531Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "experimentKey": "recommendation_v2", "schemaVersion": 1}	2026-04-26 09:12:50.532
f0d534e5-80ee-499e-8eee-4d56fa53c73a	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	959feec8-ec17-4e75-8d29-af4f57913c84	listing	{"city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "price": 70000, "source": "real-estate-backend", "receivedAt": "2026-04-26T09:12:50.661Z", "environment": "development", "schemaVersion": 1}	2026-04-26 09:12:50.662
4fe806b0-f3bd-44d7-903f-c4e92ccfb39d	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	959feec8-ec17-4e75-8d29-af4f57913c84	listing	{"city": "Tbilisi", "price": 70000, "source": "real-estate-ui", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "entityId": "959feec8-ec17-4e75-8d29-af4f57913c84", "listingId": "959feec8-ec17-4e75-8d29-af4f57913c84", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-26T09:12:50.754Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "schemaVersion": 1}	2026-04-26 09:12:50.758
7e4614da-e77b-4334-bf84-72637af3f680	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_quality	{"level": "excellent", "score": 95, "action": "score_listing_quality", "source": "add_listing", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing_quality", "receivedAt": "2026-04-26T09:12:51.716Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "schemaVersion": 1}	2026-04-26 09:12:51.717
193871ff-b6a0-48b5-bdb3-d063286a426c	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_quality	{"level": "fair", "score": 57, "action": "score_listing_quality", "source": "add_listing", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing_quality", "receivedAt": "2026-04-26T09:14:01.616Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "schemaVersion": 1}	2026-04-26 09:14:01.617
95dbac91-20ca-4257-98d4-5958da3bef0d	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_content	{"city": "Tbilisi", "mode": "RENT", "action": "generate_listing_content", "source": "add_listing", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing_content", "receivedAt": "2026-04-26T09:14:11.985Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "propertyType": "APARTMENT", "schemaVersion": 1}	2026-04-26 09:14:11.986
353d6bc8-22fb-4b6f-890e-dfb84e972fe0	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_quality	{"level": "excellent", "score": 95, "action": "score_listing_quality", "source": "add_listing", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing_quality", "receivedAt": "2026-04-26T09:14:24.043Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "schemaVersion": 1}	2026-04-26 09:14:24.043
6e135494-eed8-4974-9beb-a9f59eba8e8a	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	\N	LISTING_CREATED	7f8bd3c9-8044-4ac4-bce0-9934871cc100	listing	{"city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "price": 90000, "source": "real-estate-backend", "status": "PUBLISHED", "receivedAt": "2026-04-26T09:14:35.623Z", "environment": "development", "schemaVersion": 1}	2026-04-26 09:14:35.624
19558f61-93bb-4b86-bb55-f7bdd0b1fc77	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	7f8bd3c9-8044-4ac4-bce0-9934871cc100	listing	{"city": "Tbilisi", "price": 90000, "source": "real-estate-ui", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "entityId": "7f8bd3c9-8044-4ac4-bce0-9934871cc100", "listingId": "7f8bd3c9-8044-4ac4-bce0-9934871cc100", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-26T09:14:36.691Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "schemaVersion": 1}	2026-04-26 09:14:36.692
e2f422b7-99f6-4f94-9a28-487ed14f21e7	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	7f8bd3c9-8044-4ac4-bce0-9934871cc100	listing	{"city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "price": 90000, "source": "real-estate-backend", "receivedAt": "2026-04-26T09:14:36.805Z", "environment": "development", "schemaVersion": 1}	2026-04-26 09:14:36.806
62277d0e-8073-4801-96fd-2312173dd48f	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_content	{"city": "Um Al Fahm", "mode": "RENT", "action": "generate_listing_content", "source": "add_listing", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing_content", "receivedAt": "2026-04-26T09:16:15.795Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "propertyType": "APARTMENT", "schemaVersion": 1}	2026-04-26 09:16:15.797
5a2d1f68-45aa-441a-b1f5-c0b03cd87ae4	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_quality	{"level": "fair", "score": 50, "action": "score_listing_quality", "source": "add_listing", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing_quality", "receivedAt": "2026-04-26T09:16:16.765Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "schemaVersion": 1}	2026-04-26 09:16:16.766
f559e58e-8011-4991-80dc-d7635fbc632b	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_quality	{"level": "excellent", "score": 88, "action": "score_listing_quality", "source": "add_listing", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing_quality", "receivedAt": "2026-04-26T09:16:26.095Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "schemaVersion": 1}	2026-04-26 09:16:26.096
ef070c79-9930-4f29-bddb-79264767b563	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	\N	LISTING_CREATED	cb288153-a8d4-4973-9435-75d98775f743	listing	{"city": "Um Al Fahm", "mode": "RENT", "type": "APARTMENT", "price": 140000, "source": "real-estate-backend", "status": "PUBLISHED", "receivedAt": "2026-04-26T09:16:30.167Z", "environment": "development", "schemaVersion": 1}	2026-04-26 09:16:30.167
786d3eba-9d00-49b8-b8fa-e6dcf4e397df	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	cb288153-a8d4-4973-9435-75d98775f743	listing	{"city": "Um Al Fahm", "price": 140000, "source": "real-estate-ui", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "entityId": "cb288153-a8d4-4973-9435-75d98775f743", "listingId": "cb288153-a8d4-4973-9435-75d98775f743", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-26T09:16:30.874Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "schemaVersion": 1}	2026-04-26 09:16:30.875
c40e5464-4a63-44a1-99e1-d20fec4a8f0a	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	cb288153-a8d4-4973-9435-75d98775f743	listing	{"city": "Um Al Fahm", "mode": "RENT", "type": "APARTMENT", "price": 140000, "source": "real-estate-backend", "receivedAt": "2026-04-26T09:16:30.997Z", "environment": "development", "schemaVersion": 1}	2026-04-26 09:16:30.998
50c64d0f-b6b1-4056-a9f7-d39675b709ed	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_content	{"city": "Tblisi", "mode": "RENT", "action": "generate_listing_content", "source": "add_listing", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing_content", "receivedAt": "2026-04-26T09:17:55.641Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "propertyType": "APARTMENT", "schemaVersion": 1}	2026-04-26 09:17:55.643
8cdfb95a-06cb-48f3-a330-32c6bb746931	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_quality	{"level": "excellent", "score": 95, "action": "score_listing_quality", "source": "add_listing", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing_quality", "receivedAt": "2026-04-26T09:18:10.846Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "schemaVersion": 1}	2026-04-26 09:18:10.846
105f089b-175d-4753-ba84-8b731e1db742	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	AI_SUGGESTION_ACCEPTED	\N	listing_content	{"city": "Tblisi", "mode": "SALE", "action": "generate_listing_content", "source": "add_listing", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing_content", "receivedAt": "2026-04-26T09:18:18.090Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "propertyType": "APARTMENT", "schemaVersion": 1}	2026-04-26 09:18:18.09
f7bcadc2-3b97-4e34-9df3-25ec9f9f0fd0	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	\N	LISTING_CREATED	36ffa8d9-dd90-414d-b257-db98e4a90f70	listing	{"city": "Tblisi", "mode": "SALE", "type": "APARTMENT", "price": 90000, "source": "real-estate-backend", "status": "PUBLISHED", "receivedAt": "2026-04-26T09:18:21.671Z", "environment": "development", "schemaVersion": 1}	2026-04-26 09:18:21.672
2fe4f12d-2ea4-4257-8cf5-06db89a20390	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	36ffa8d9-dd90-414d-b257-db98e4a90f70	listing	{"city": "Tblisi", "price": 90000, "source": "real-estate-ui", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "entityId": "36ffa8d9-dd90-414d-b257-db98e4a90f70", "listingId": "36ffa8d9-dd90-414d-b257-db98e4a90f70", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-26T09:18:22.371Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "schemaVersion": 1}	2026-04-26 09:18:22.372
e2df99c8-9af4-49a5-a8cc-08c77fa9fdd3	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	36ffa8d9-dd90-414d-b257-db98e4a90f70	listing	{"city": "Tblisi", "mode": "SALE", "type": "APARTMENT", "price": 90000, "source": "real-estate-backend", "receivedAt": "2026-04-26T09:18:22.491Z", "environment": "development", "schemaVersion": 1}	2026-04-26 09:18:22.492
605562e8-98be-4a5c-993b-29877ffb224f	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	\N	FAVORITE_ADDED	cb288153-a8d4-4973-9435-75d98775f743	listing	{"source": "real-estate-backend", "listingId": "cb288153-a8d4-4973-9435-75d98775f743", "receivedAt": "2026-04-26T09:18:48.908Z", "environment": "development", "schemaVersion": 1}	2026-04-26 09:18:48.91
4b0a18ed-3654-4579-b504-225ad2c71a4d	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	FAVORITE_ADDED	cb288153-a8d4-4973-9435-75d98775f743	listing	{"city": "Um Al Fahm", "price": 140000, "source": "real-estate-ui", "userId": "f4ce3817-ad27-471d-9dac-20d07a0d1d0d", "entityId": "cb288153-a8d4-4973-9435-75d98775f743", "listingId": "cb288153-a8d4-4973-9435-75d98775f743", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-26T09:18:49.175Z", "environment": "development", "experiments": {"search_v2": "B", "ai_ranking_v1": "B", "recommendation_v2": "A"}, "schemaVersion": 1}	2026-04-26 09:18:49.176
75bc0893-a9dd-4e05-8bba-6b62c9426e64	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	\N	VERIFICATION_REQUESTED	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	user	{"source": "real-estate-backend", "receivedAt": "2026-04-26T09:19:29.634Z", "environment": "development", "schemaVersion": 1}	2026-04-26 09:19:29.637
2b888515-9165-4e49-9aed-cb954419c202	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 12, "total": 13, "source": "real-estate-backend", "filters": {}, "receivedAt": "2026-04-27T11:33:01.777Z", "environment": "development", "resultsCount": 12, "schemaVersion": 1, "searchVariant": null}	2026-04-27 11:33:01.811
d4b825de-f264-431f-92d5-b1d27e22fa5b	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 50, "total": 13, "source": "real-estate-backend", "filters": {"limit": 50}, "receivedAt": "2026-04-27T11:33:01.815Z", "environment": "development", "resultsCount": 13, "schemaVersion": 1, "searchVariant": null}	2026-04-27 11:33:01.816
d3fc05a1-badd-442f-926b-869bf08657a2	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 24, "total": 13, "source": "real-estate-backend", "filters": {"sort": "latest", "limit": 24}, "receivedAt": "2026-04-27T11:33:07.389Z", "environment": "development", "resultsCount": 13, "schemaVersion": 1, "searchVariant": null}	2026-04-27 11:33:07.4
788f0d3a-1015-4911-96d0-74b4dfca65d8	\N	\N	SEARCH_PERFORMED	\N	search	{"page": 1, "limit": 24, "total": 13, "source": "real-estate-backend", "filters": {"sort": "latest", "limit": 24}, "receivedAt": "2026-04-27T11:33:07.506Z", "environment": "development", "resultsCount": 13, "schemaVersion": 1, "searchVariant": null}	2026-04-27 11:33:07.508
3a752101-40e8-4a2b-b647-eb7f2476278a	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "price": 120000, "source": "explore_feed", "userId": null, "entityId": "c901de33-674a-444d-8892-259897e9e4a9", "listingId": "c901de33-674a-444d-8892-259897e9e4a9", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-27T11:33:08.711Z", "environment": "development", "experiments": {"search_v2": "A", "ai_ranking_v1": "A", "recommendation_v2": "B"}, "schemaVersion": 1}	2026-04-27 11:33:08.712
3c4aae80-b0ff-4f7f-a232-c71da642fb76	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	c901de33-674a-444d-8892-259897e9e4a9	listing	{"city": "Tel Aviv", "mode": "SALE", "type": "HOUSE", "price": 120000, "source": "real-estate-backend", "receivedAt": "2026-04-27T11:33:08.741Z", "environment": "development", "schemaVersion": 1}	2026-04-27 11:33:08.742
06a767af-e494-4a24-8844-e3b0bffdad41	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "price": 150000, "source": "explore_feed", "userId": null, "entityId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-27T11:33:11.081Z", "environment": "development", "experiments": {"search_v2": "A", "ai_ranking_v1": "A", "recommendation_v2": "B"}, "schemaVersion": 1}	2026-04-27 11:33:11.082
079c9263-a4a2-4afd-b921-293bc7f1150d	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	d3f575e9-3959-4945-adf2-cbadbf53f2e0	listing	{"city": "Haifa", "mode": "RENT", "type": "APARTMENT", "price": 150000, "source": "real-estate-backend", "receivedAt": "2026-04-27T11:33:11.110Z", "environment": "development", "schemaVersion": 1}	2026-04-27 11:33:11.11
8de736bd-889a-4100-9ac0-677adea89fdc	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	9cc14069-c507-44df-900b-3833cea37ead	listing	{"city": "Um Al Fahm", "price": 80000, "source": "explore_feed", "userId": null, "entityId": "9cc14069-c507-44df-900b-3833cea37ead", "listingId": "9cc14069-c507-44df-900b-3833cea37ead", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-27T11:33:12.725Z", "environment": "development", "experiments": {"search_v2": "A", "ai_ranking_v1": "A", "recommendation_v2": "B"}, "schemaVersion": 1}	2026-04-27 11:33:12.726
baa382d0-bf13-4e56-93c5-3ebff76c61d8	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	9cc14069-c507-44df-900b-3833cea37ead	listing	{"city": "Um Al Fahm", "mode": "SALE", "type": "APARTMENT", "price": 80000, "source": "real-estate-backend", "receivedAt": "2026-04-27T11:33:12.750Z", "environment": "development", "schemaVersion": 1}	2026-04-27 11:33:12.751
7092ae26-9b4a-4c5b-96c9-c38f90f51c28	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	cb288153-a8d4-4973-9435-75d98775f743	listing	{"city": "Um Al Fahm", "price": 140000, "source": "explore_feed", "userId": null, "entityId": "cb288153-a8d4-4973-9435-75d98775f743", "listingId": "cb288153-a8d4-4973-9435-75d98775f743", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-27T11:33:16.912Z", "environment": "development", "experiments": {"search_v2": "A", "ai_ranking_v1": "A", "recommendation_v2": "B"}, "schemaVersion": 1}	2026-04-27 11:33:16.913
d5247a7f-857d-4beb-90c4-7c8c1c0d64cf	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	cb288153-a8d4-4973-9435-75d98775f743	listing	{"city": "Um Al Fahm", "mode": "RENT", "type": "APARTMENT", "price": 140000, "source": "real-estate-backend", "receivedAt": "2026-04-27T11:33:16.936Z", "environment": "development", "schemaVersion": 1}	2026-04-27 11:33:16.937
f35fcede-dfaf-42a3-93f1-0d0514d49cb6	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"city": "Tel Aviv", "price": 110000, "source": "explore_feed", "userId": null, "entityId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-27T11:33:18.386Z", "environment": "development", "experiments": {"search_v2": "A", "ai_ranking_v1": "A", "recommendation_v2": "B"}, "schemaVersion": 1}	2026-04-27 11:33:18.387
c2b5955a-55a7-4608-a504-f16fe1b6f4ed	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"city": "Tel Aviv", "mode": "RENT", "type": "HOUSE", "price": 110000, "source": "real-estate-backend", "receivedAt": "2026-04-27T11:33:18.413Z", "environment": "development", "schemaVersion": 1}	2026-04-27 11:33:18.414
f7d6c40b-93c3-4a9c-ba18-0ccdb4c7228c	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	EXPERIMENT_EXPOSED	recommendation_v2	experiment	{"source": "real-estate-ui", "userId": null, "surface": "listing_recommendations", "variant": "B", "entityId": "recommendation_v2", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "experiment", "receivedAt": "2026-04-27T11:33:27.844Z", "environment": "development", "experiments": {"search_v2": "A", "ai_ranking_v1": "A", "recommendation_v2": "B"}, "experimentKey": "recommendation_v2", "schemaVersion": 1}	2026-04-27 11:33:27.844
7356657e-ad1a-43f9-bf26-b954fa8a9f48	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	EXPERIMENT_EXPOSED	ai_ranking_v1	experiment	{"source": "real-estate-ui", "userId": null, "surface": "listing_recommendations", "variant": "A", "entityId": "ai_ranking_v1", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "experiment", "receivedAt": "2026-04-27T11:33:27.838Z", "environment": "development", "experiments": {"search_v2": "A", "ai_ranking_v1": "A", "recommendation_v2": "B"}, "experimentKey": "ai_ranking_v1", "schemaVersion": 1}	2026-04-27 11:33:27.84
7ff0662a-acdf-47f6-b3d1-395cbf4649a8	\N	2981a2af-d8f7-4c60-8331-3f910ec51f5f	LISTING_VIEWED	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	listing	{"city": "Tel Aviv", "price": 110000, "source": "real-estate-ui", "userId": null, "entityId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1", "sessionId": "2981a2af-d8f7-4c60-8331-3f910ec51f5f", "entityType": "listing", "receivedAt": "2026-04-27T11:33:28.165Z", "environment": "development", "experiments": {"search_v2": "A", "ai_ranking_v1": "A", "recommendation_v2": "B"}, "schemaVersion": 1}	2026-04-27 11:33:28.165
\.


--
-- Data for Name: Experiment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Experiment" (key, name, description, status, "controlVariant", "treatmentVariant", "treatmentPercentage", "primaryMetric", "winnerVariant", "configJson", "createdAt", "updatedAt") FROM stdin;
recommendation_v2	Recommendation V2	Current recommendation feed versus behavior-based recommendation flow.	RUNNING	A	B	50	leadRate	\N	{"variants": {"A": {"recommendationStrategy": "DEFAULT"}, "B": {"recommendationStrategy": "BEHAVIOR"}}}	2026-04-25 22:37:49.885	2026-04-27 11:33:02.709
ai_ranking_v1	AI Ranking V1	Default recommendation ranking versus AI-driven ranking.	RUNNING	A	B	50	conversion	\N	{"variants": {"A": {"recommendationStrategy": "DEFAULT"}, "B": {"recommendationStrategy": "AI"}}}	2026-04-25 22:37:49.885	2026-04-27 11:33:02.708
search_v2	Search V2	Classic search versus enhanced search with overrides and synonyms.	RUNNING	A	B	50	ctr	\N	{"variants": {"A": {"searchMode": "classic"}, "B": {"searchMode": "enhanced"}}}	2026-04-25 22:37:49.884	2026-04-27 11:33:02.706
\.


--
-- Data for Name: Favorite; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Favorite" (id, "userId", "listingId", "createdAt") FROM stdin;
6282cac4-f793-46bf-acbd-050f1bf62ad6	2464ed65-9c3e-4bf6-981a-c1dafe9c25a0	41367728-e8a5-4232-8a08-520075bc6859	2026-04-09 21:58:01.402
7d1347f9-f551-416b-a640-c5c75813a5a3	0863bc3f-a7c7-464c-9737-1f49ec6d6a65	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	2026-04-14 00:16:44.688
0478d919-4bee-4244-afb1-b6d1bacf5f68	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	2026-04-20 00:22:33.545
56ca28fb-c8f4-4955-851a-f6fcdc186bee	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	d3f575e9-3959-4945-adf2-cbadbf53f2e0	2026-04-20 20:55:21.514
f029abc7-aa6f-4d52-a78f-da4aa7e58c2a	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	c161f02d-7d64-47bd-8412-424d48166b15	2026-04-20 20:55:24.647
0e7c3082-f3d9-46f0-9167-71e26ebcdb71	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	51b8a6d1-6450-49a4-b961-3d9bfe465770	2026-04-20 20:55:28.282
07ac8d0a-eb9a-4f28-b7c5-f7b14df7818c	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	c901de33-674a-444d-8892-259897e9e4a9	2026-04-20 20:55:31.287
9d49c4aa-46a8-4579-8409-a010b11ea356	0863bc3f-a7c7-464c-9737-1f49ec6d6a65	c901de33-674a-444d-8892-259897e9e4a9	2026-04-21 12:26:15.075
383f7f50-a934-4415-b259-db85018daea8	0863bc3f-a7c7-464c-9737-1f49ec6d6a65	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	2026-04-22 23:55:17.807
f6d8ec85-60b7-4a27-aa8b-c7ae23c07f02	f0ce40f7-e29c-4791-8928-fb1bcdf6c85f	d3f575e9-3959-4945-adf2-cbadbf53f2e0	2026-04-23 00:03:06.692
344be9cf-04d9-4fea-9ac9-2f3990e1d082	f0ce40f7-e29c-4791-8928-fb1bcdf6c85f	51b8a6d1-6450-49a4-b961-3d9bfe465770	2026-04-23 16:24:58.103
ac526696-ee38-4dc2-8678-23457ca785cf	056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4	d3f575e9-3959-4945-adf2-cbadbf53f2e0	2026-04-25 21:07:33.664
c3f098da-5ed0-4160-975f-9c3662f41dc5	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	cb288153-a8d4-4973-9435-75d98775f743	2026-04-26 09:18:48.899
\.


--
-- Data for Name: Lead; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Lead" (id, "listingId", name, phone, message, "createdAt", "ownerUserId", "senderUserId", source, status) FROM stdin;
3e1297dc-67a4-4421-9c7f-8caf609efe53	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	Ayham Mhameed	0524868992	Hi aa	2026-04-16 02:28:16.714	0863bc3f-a7c7-464c-9737-1f49ec6d6a65	\N	listing_details	NEW
fd2f4297-1366-4bf8-bcf4-706849a7f671	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	Ayham Mhameed	0524868992	Hii a	2026-04-16 02:28:57.268	0863bc3f-a7c7-464c-9737-1f49ec6d6a65	\N	listing_details	NEW
bbcde06b-2cc5-438c-afc7-3fdfa48e5a40	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	Ayham	0524868990	HIii a	2026-04-16 02:29:19.351	0863bc3f-a7c7-464c-9737-1f49ec6d6a65	\N	listing_details	NEW
469983db-2ffb-4a55-8a38-077d8d716588	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	Ayham	0524868992	Hi A	2026-04-16 10:59:18.237	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	listing_details	CONTACTED
d3e5fffe-9441-4c01-9a64-b66779502aef	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	Ayham	0524868888	AAn a	2026-04-19 23:48:48.625	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	listing_details	CLOSED
bdb696e1-1ede-486c-87b6-6fe78367d7cd	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	Ayham	0524868882	AAa m	2026-04-20 00:23:00.21	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	listing_details	NEW
1d22cfb1-f708-41c0-933b-29a6b76c46cd	c901de33-674a-444d-8892-259897e9e4a9	Ayham	0502004040	aaA  Mn	2026-04-21 12:25:05.728	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	listing_details	NEW
85ec5c6d-a47d-4400-82af-1067b6188d0c	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Ayham	0524868992	GGh f	2026-04-21 12:38:51.656	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	listing_details	CONTACTED
bcc60994-a34c-40df-82e9-160b5af032a0	c901de33-674a-444d-8892-259897e9e4a9	Ayham	0504868999	AAa T	2026-04-21 12:38:04.492	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	listing_details	CLOSED
ea06cd76-96b2-4924-b512-0d14d07fba96	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	AYham	0520011478	aa d	2026-04-22 03:03:52.569	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	listing_details	NEW
565a4e73-9d01-4735-abed-df352fadab44	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Ayham	0502003001	HI w	2026-04-23 16:58:52.183	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	listing_details	NEW
\.


--
-- Data for Name: Listing; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Listing" (id, title, description, price, city, neighborhood, type, mode, rooms, bathrooms, area, image, "createdAt", "createdById", "updatedAt", status, "boostedUntil", "featuredUntil", latitude, longitude) FROM stdin;
51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Created during verification	7777	Haifa	Downtown	APARTMENT	RENT	3	2	110	https://example.com/listing.jpg	2026-04-09 21:58:01.612	95a440b2-4b1c-4a8a-afdc-319e6fd4482e	2026-04-09 21:58:01.612	PUBLISHED	\N	\N	\N	\N
c161f02d-7d64-47bd-8412-424d48166b15	homee	a	6000	um al fahm	\N	APARTMENT	RENT	4	2	70	https://images.unsplash.com/photo-1502672260266-1c1ef2d93688	2026-04-10 11:10:40.253	74539c7a-05f2-43e5-a21b-21123db30f2c	2026-04-10 11:10:40.253	PUBLISHED	\N	\N	\N	\N
de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\n\nContact the owner today to learn more.	110000	Tel Aviv	\N	HOUSE	RENT	4	2	80	https://images.unsplash.com/photo-1568605114967-8130f3a36994	2026-04-21 13:01:55.079	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-22 16:35:20.562	PUBLISHED	\N	2026-04-29 16:35:20.561	\N	\N
9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	A	400	Haifa	\N	APARTMENT	RENT	2	1	40	\N	2026-04-16 02:27:25.07	0863bc3f-a7c7-464c-9737-1f49ec6d6a65	2026-04-16 02:27:25.07	PUBLISHED	\N	\N	\N	\N
9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\n\nContact the owner today to learn more.	80000	Um Al Fahm	\N	APARTMENT	SALE	4	1	70	\N	2026-04-17 22:53:47.413	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-22 16:35:33.923	PUBLISHED	2026-04-25 16:33:00.168	2026-04-29 16:35:33.923	\N	\N
c901de33-674a-444d-8892-259897e9e4a9	Modern property with strong potential	This property offers a practical layout, a clear location advantage, and features that make it suitable for buyers or renters looking for comfort and value.\n\nContact the owner today to learn more.	120000	Tel Aviv	\N	HOUSE	SALE	5	3	125	https://images.unsplash.com/photo-1600585154340-be6161a56a0c	2026-04-20 14:56:34.101	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-22 16:32:42.051	PUBLISHED	\N	2026-04-29 16:32:42.049	\N	\N
d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	.	150000	Haifa	\N	APARTMENT	RENT	5	2	80	https://images.unsplash.com/photo-1564013799919-ab600027ffc6?q=80&w=1200&auto=format&fit=crop	2026-04-10 23:08:19.448	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-22 16:40:31.629	PUBLISHED	2026-04-25 16:40:31.627	\N	\N	\N
41367728-e8a5-4232-8a08-520075bc6859	Home1		6600	um al fahm 	\N	APARTMENT	RENT	2	1	50		2026-04-09 14:20:29.387	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-23 17:01:25.08	PUBLISHED	\N	\N	\N	\N
51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	a	5000	Tel Aviv	\N	APARTMENT	RENT	4	2	66	https://images.unsplash.com/photo-1502672260266-1c1ef2d93688	2026-04-13 13:08:01.943	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-25 22:41:25.046	PUBLISHED	\N	\N	\N	\N
959feec8-ec17-4e75-8d29-af4f57913c84	Apartment1 in Green	This listing offers a practical option in Green. It includes 2 rooms, 1 bathrooms, and 55.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\n\nContact the owner to schedule a viewing.	70000	Tbilisi	Green	APARTMENT	RENT	2	1	55	https://images.unsplash.com/photo-1486406146926-c627a92ad1ab	2026-04-26 09:12:46.662	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	2026-04-26 09:12:46.662	PUBLISHED	\N	\N	\N	\N
7f8bd3c9-8044-4ac4-bce0-9934871cc100	Apartment in Green	This listing offers a practical option in Green. It includes 3 rooms, 2 bathrooms, and 80.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\n\nContact the owner to schedule a viewing.	90000	Tbilisi	Green	APARTMENT	RENT	3	2	80	https://images.unsplash.com/photo-1512917774080-9991f1c4c750	2026-04-26 09:14:35.597	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	2026-04-26 09:14:35.597	PUBLISHED	\N	\N	\N	\N
cb288153-a8d4-4973-9435-75d98775f743	Apartment in Um Al Fahm	This listing offers a practical option in Um Al Fahm. It includes 5 rooms, 3 bathrooms, and 120.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for rent.\n\nContact the owner to schedule a viewing.	140000	Um Al Fahm	\N	APARTMENT	RENT	5	3	120	https://images.unsplash.com/photo-1605276374104-dee2a0ed3cd6	2026-04-26 09:16:30.142	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	2026-04-26 09:16:30.142	PUBLISHED	\N	\N	\N	\N
36ffa8d9-dd90-414d-b257-db98e4a90f70	Apartment in Green	This listing offers a practical option in Green. It includes 4 rooms, 2 bathrooms, and 95.0 m2 of space. Review the photos, layout, condition, and nearby services before making a decision. It may be a good fit for sale.\n\nContact the owner to learn more.	90000	Tblisi	Green	APARTMENT	SALE	4	2	95	https://images.unsplash.com/photo-1545324418-cc1a3fa10c00	2026-04-26 09:18:21.652	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	2026-04-26 09:18:21.652	PUBLISHED	\N	\N	\N	\N
\.


--
-- Data for Name: ListingImage; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."ListingImage" (id, "listingId", url, "createdAt", "sortOrder") FROM stdin;
bb786eeb-0525-4b1f-b965-b665e15cb358	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	https://images.unsplash.com/photo-1568605114967-8130f3a36994	2026-04-21 13:01:55.079	0
9ac416e4-8d5b-4016-a45a-6d5b674e0a5e	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	https://images.unsplash.com/photo-1570129477492-45c003edd2be	2026-04-21 13:01:55.079	1
7f916a44-7dae-4c51-afa4-d4350f10abde	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	https://images.unsplash.com/photo-1605276374104-dee2a0ed3cd6	2026-04-21 13:01:55.079	2
84bda669-5be6-4cce-a94f-a3ff1b098f1a	959feec8-ec17-4e75-8d29-af4f57913c84	https://images.unsplash.com/photo-1486406146926-c627a92ad1ab	2026-04-26 09:12:46.662	0
8962c020-8ea9-4a56-baee-b6ad128f24af	959feec8-ec17-4e75-8d29-af4f57913c84	https://images.unsplash.com/photo-1618221195710-dd6b41faaea6	2026-04-26 09:12:46.662	1
52536932-5d21-498a-8134-42dc955dd8f3	7f8bd3c9-8044-4ac4-bce0-9934871cc100	https://images.unsplash.com/photo-1512917774080-9991f1c4c750	2026-04-26 09:14:35.597	0
8d90b6b1-427f-4230-8696-74c06394143c	7f8bd3c9-8044-4ac4-bce0-9934871cc100	https://images.unsplash.com/photo-1502005229762-cf1b2da7c5d6	2026-04-26 09:14:35.597	1
2c5b5ab9-987a-4946-922e-e533960f9e1f	cb288153-a8d4-4973-9435-75d98775f743	https://images.unsplash.com/photo-1605276374104-dee2a0ed3cd6	2026-04-26 09:16:30.142	0
9c2886df-7fbb-4c79-82d8-a9cde4d914f1	cb288153-a8d4-4973-9435-75d98775f743	https://images.unsplash.com/photo-1493809842364-78817add7ffb	2026-04-26 09:16:30.142	1
eba11311-d275-4111-9ab1-c31dfbf117fe	36ffa8d9-dd90-414d-b257-db98e4a90f70	https://images.unsplash.com/photo-1545324418-cc1a3fa10c00	2026-04-26 09:18:21.652	0
ced40930-900c-4bf2-b95b-2fe4751ad799	36ffa8d9-dd90-414d-b257-db98e4a90f70	https://images.unsplash.com/photo-1505691938895-1758d7feb511	2026-04-26 09:18:21.652	1
\.


--
-- Data for Name: ListingReport; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."ListingReport" (id, "listingId", "userId", "sessionId", reason, message, "createdAt", "adminNotes", "reviewStatus", "reviewedAt", "reviewedById") FROM stdin;
363424e8-ed43-42df-bd2d-e3772d08a3ae	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	WRONG_DETAILS	a	2026-04-21 21:11:40.84	\N	OPEN	\N	\N
5e2c1828-38ea-4670-a4b7-bbad3e85b233	41367728-e8a5-4232-8a08-520075bc6859	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2981a2af-d8f7-4c60-8331-3f910ec51f5f	WRONG_DETAILS	a	2026-04-21 21:13:24.038	\N	OPEN	\N	\N
\.


--
-- Data for Name: ListingView; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."ListingView" (id, "listingId", "userId", "viewedAt") FROM stdin;
9398f069-b3e1-49d8-add4-f2dbd565189e	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-18 20:39:12.399
83fcb3c5-f0ad-47f7-bae0-0d8ce5cd45ba	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-18 20:39:12.412
d6a6b4d4-4dd8-47eb-afe2-82c0ceb1589c	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	\N	2026-04-18 20:39:16.199
c5092b9f-c4fe-4cd5-bb31-476db5541064	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	\N	2026-04-18 20:39:16.201
2f9feb6e-85df-4f44-91b4-62a80b7c3b21	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	\N	2026-04-19 00:47:59.007
f5b14df8-56f1-4ca6-801d-9bbcde540abb	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	\N	2026-04-19 00:47:59.008
1c846d32-0ae3-461b-ab5c-96d418b6493f	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-19 00:48:04.175
72ee6de9-14e6-43fc-ba7f-3d4b36295a08	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-19 00:48:04.176
763951a7-a77b-4e1e-8f48-4d1e8745ec47	9cc14069-c507-44df-900b-3833cea37ead	\N	2026-04-19 00:48:57.06
83835fd9-8a00-4af8-970b-a14ea189466e	9cc14069-c507-44df-900b-3833cea37ead	\N	2026-04-19 00:48:57.075
bbdf63c3-4c1f-45cb-a187-ad05eeda2017	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-19 00:49:44.199
43612369-c43d-4c06-a1e9-e34a0f86da19	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-19 00:49:44.214
29109f96-6700-4fde-93d9-852e865de9e1	c161f02d-7d64-47bd-8412-424d48166b15	\N	2026-04-19 00:49:50.894
2588437f-10af-4dd6-955e-670e0b8a8507	c161f02d-7d64-47bd-8412-424d48166b15	\N	2026-04-19 00:49:50.896
e66fcbdc-b647-475a-aa57-ed740afa78b5	9cc14069-c507-44df-900b-3833cea37ead	\N	2026-04-19 00:49:55.263
53e60cfc-7517-45e9-9e89-92bd3f0275d3	9cc14069-c507-44df-900b-3833cea37ead	\N	2026-04-19 00:49:55.264
97f48d76-0fa0-42f7-a3cc-a6bade2784d2	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-19 00:50:29.48
5a0ec9ab-a22a-4c76-bb0d-2cef0db561a2	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-19 00:50:29.495
4ac17eb9-7036-4d0f-acb0-77112d357f96	c161f02d-7d64-47bd-8412-424d48166b15	\N	2026-04-19 00:50:50.452
905a1dfa-da65-4381-ac9f-cb7042263179	c161f02d-7d64-47bd-8412-424d48166b15	\N	2026-04-19 00:50:50.452
0fdfd8a1-ad5a-4c39-b587-5f1e55ee319b	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-19 01:01:41.556
cc46dead-8679-4d57-8515-bf65a5f71cd6	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-19 01:01:41.574
7b2b7e37-2d7f-4c81-902c-6bd35ce0bcc3	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-19 01:23:48.637
1ca7e285-3ae8-45c4-8c89-925ca9a17e3c	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-19 01:23:48.663
dcc40fe7-7f46-4cff-a090-ba20bfbfcd45	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-19 19:42:56.731
bc826377-a492-4c4d-b28b-142d247172d6	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-19 19:42:56.763
9d592841-c331-4f86-b207-0c7bc73d92ed	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	\N	2026-04-19 19:43:17.507
92a86acd-7b59-44a7-890f-447907ca3ad9	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	\N	2026-04-19 19:43:17.517
9099fcc9-b06c-4442-bbd8-8cffdc3067d4	c161f02d-7d64-47bd-8412-424d48166b15	\N	2026-04-19 19:43:25.161
d9d6ec55-a84b-429c-85a3-c6758fd257ad	c161f02d-7d64-47bd-8412-424d48166b15	\N	2026-04-19 19:43:25.17
d70ca166-a8f1-4256-a045-44e34603d5c7	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	\N	2026-04-19 20:36:29.777
7b53a158-6421-4c97-9c20-93b162a1322a	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	\N	2026-04-19 20:36:29.801
cc456a61-bb4e-4c7f-a285-1a4543959d5f	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-19 20:44:20.853
815f1d03-2d8a-46a3-aa65-4d8872dc92e5	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-19 20:44:20.878
a1e0da61-101b-4447-8963-380366a52728	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-19 20:46:32.8
49d5f45f-1419-4343-bf57-d0acdf53e392	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-19 20:46:32.843
8c8372ad-c511-407f-aa5c-a88f7ea4e714	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	\N	2026-04-19 21:01:18.668
0911c164-a2f0-4bd7-a92b-e1af81c214bf	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	\N	2026-04-19 21:01:18.703
e15e62e5-a9a6-4d4a-a199-eea574d42019	9cc14069-c507-44df-900b-3833cea37ead	\N	2026-04-19 23:47:50.322
938c0292-8a7c-48db-a156-5d5311a49ed7	9cc14069-c507-44df-900b-3833cea37ead	\N	2026-04-19 23:47:50.347
07d274e2-64c5-4454-a7f7-80263a251a0d	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	\N	2026-04-19 23:48:30.33
284e238a-7dc7-4fc1-a059-02e6b6706e6d	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	\N	2026-04-19 23:48:30.365
fb86179d-e374-4ded-8adc-17a21db7ad0e	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	\N	2026-04-20 00:22:44.847
d157e8b7-00b3-41f0-ba82-cf6ed1e05146	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	\N	2026-04-20 00:22:44.877
0ea9c227-989a-4703-95f9-981056ba687d	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-20 00:41:21.597
ac470a65-f0e4-4131-91e6-c271168d1c6e	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-20 00:41:21.644
949809d6-bb5e-4cae-bb1c-8060cb5554b0	c161f02d-7d64-47bd-8412-424d48166b15	\N	2026-04-20 00:41:32.778
eeb603cd-ca9a-4ffc-87e6-974afde89400	c161f02d-7d64-47bd-8412-424d48166b15	\N	2026-04-20 00:41:32.808
ab130747-d972-4ef5-94ff-a38dae435667	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	\N	2026-04-20 02:22:51.557
6ab1426a-1c54-42ae-b190-6418ec14dfdd	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	\N	2026-04-20 02:22:51.581
ee8e1239-080a-4c0f-9442-ecd55aeff372	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-20 02:31:22.464
6e95abb1-eb20-4a40-b863-e6da3700e637	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-20 02:31:22.531
b3109565-be9b-4669-b0ea-39f8c538a811	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	\N	2026-04-20 14:07:54.662
3103b7bb-c771-44f2-8fca-56c24552e98a	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	\N	2026-04-20 14:07:54.666
56a191b7-9fa0-46d4-bfca-6679c896404a	9cc14069-c507-44df-900b-3833cea37ead	\N	2026-04-20 14:08:08.207
250d0428-783d-4adf-b80f-3e6758c160fd	9cc14069-c507-44df-900b-3833cea37ead	\N	2026-04-20 14:08:08.225
02463086-d013-4bbc-ad3e-7266c73a94c1	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-20 14:09:14.945
e51c2836-d245-4507-8e05-b8d34729720f	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-20 14:09:14.989
7faeb40e-d7f8-454e-9693-41d28de1d710	9cc14069-c507-44df-900b-3833cea37ead	\N	2026-04-20 14:20:49.567
3fbf38df-7f55-4f3f-b3cf-66e43dad27de	9cc14069-c507-44df-900b-3833cea37ead	\N	2026-04-20 14:20:49.571
c0f46dd0-bca1-4150-ba2a-3c38dc1683f5	c901de33-674a-444d-8892-259897e9e4a9	\N	2026-04-20 14:56:36.723
af308ef4-6c45-464d-8ffb-1f5874e2622f	c901de33-674a-444d-8892-259897e9e4a9	\N	2026-04-20 14:56:36.763
b59f5a05-8451-4a7b-93aa-b6823d623460	c901de33-674a-444d-8892-259897e9e4a9	\N	2026-04-20 20:34:03.094
063a1bd8-7df6-4c03-9ae8-fe4a006d7d6b	c901de33-674a-444d-8892-259897e9e4a9	\N	2026-04-20 20:34:03.129
c1c9163a-c313-42ab-a89d-a6b08411e198	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-20 20:34:29.56
a4e9e3f0-96bd-491c-93f9-bf50f1ec3e09	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-20 20:34:29.592
103babfe-4d8f-4d66-ab5a-9a8e54be64f9	c901de33-674a-444d-8892-259897e9e4a9	\N	2026-04-20 23:08:15.704
2f68f20f-0b5b-4c3b-bbc7-65da862f32bc	c901de33-674a-444d-8892-259897e9e4a9	\N	2026-04-20 23:08:15.743
5c7d25cc-3bd6-4a87-b0f6-8b289547ab16	c161f02d-7d64-47bd-8412-424d48166b15	\N	2026-04-20 23:08:22.815
7f9c8bc5-a1c4-40a2-98d2-4ea3fba817a3	c161f02d-7d64-47bd-8412-424d48166b15	\N	2026-04-20 23:08:22.82
29f7c284-45fd-4292-bcf6-a663b3d1b7ce	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-20 23:08:33.612
2f377d98-6a8d-4514-a24c-ec378c200748	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-20 23:08:33.615
367777fb-aef0-4410-952d-c3e0db90b554	c901de33-674a-444d-8892-259897e9e4a9	\N	2026-04-20 23:41:07.579
2fcc383c-a551-4411-bb80-690b399dd112	c901de33-674a-444d-8892-259897e9e4a9	\N	2026-04-20 23:41:07.639
4eb09270-8481-412a-8da9-1baac88e23f5	c901de33-674a-444d-8892-259897e9e4a9	\N	2026-04-21 03:17:26.223
32443b04-b3d4-4a12-8039-c1ebc710dac0	c901de33-674a-444d-8892-259897e9e4a9	\N	2026-04-21 03:17:26.271
a9119706-ed21-4a2d-8700-ad5c93ebe707	c901de33-674a-444d-8892-259897e9e4a9	\N	2026-04-21 12:24:40.079
bdb2be52-8bc2-4d44-8adb-f32065cd5758	c901de33-674a-444d-8892-259897e9e4a9	\N	2026-04-21 12:24:40.129
c27e516c-d30f-419e-83bd-500edb93f824	c901de33-674a-444d-8892-259897e9e4a9	\N	2026-04-21 12:25:22.558
58b4a38c-bfc2-47a9-b8f4-dcdf76aa23ff	c901de33-674a-444d-8892-259897e9e4a9	\N	2026-04-21 12:25:22.56
9c6d0601-324d-41ec-b89c-4f7f3bcfaf5d	c901de33-674a-444d-8892-259897e9e4a9	\N	2026-04-21 12:26:21.902
29ce755b-0b6d-4a29-aa41-6c277d0c516d	c901de33-674a-444d-8892-259897e9e4a9	\N	2026-04-21 12:26:21.923
b34420f9-3e1d-48b1-86ee-a1c470cceef1	c901de33-674a-444d-8892-259897e9e4a9	\N	2026-04-21 12:37:45.662
fdd218e9-78b8-44dd-adfa-4810026315eb	c901de33-674a-444d-8892-259897e9e4a9	\N	2026-04-21 12:37:45.715
85bff21d-8e1c-472e-9dc5-97cef9a9dce6	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-21 12:38:39.02
a843c3a8-783b-40ba-9524-8fc9fb43dee0	d3f575e9-3959-4945-adf2-cbadbf53f2e0	\N	2026-04-21 12:38:39.047
38ca0bb3-59e8-41cf-a4cf-b7ff6bcc6927	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	2981a2af-d8f7-4c60-8331-3f910ec51f5f	2026-04-21 13:01:58.652
f003175a-aa5d-4d0c-adf1-a7eb9cc613ff	c901de33-674a-444d-8892-259897e9e4a9	2981a2af-d8f7-4c60-8331-3f910ec51f5f	2026-04-21 13:09:33.051
dd7c210d-d5ab-48e7-9b23-571d8f7cce77	c901de33-674a-444d-8892-259897e9e4a9	2981a2af-d8f7-4c60-8331-3f910ec51f5f	2026-04-21 13:09:33.058
6a2241ef-6f39-46b1-a080-d51792b7455e	c161f02d-7d64-47bd-8412-424d48166b15	2981a2af-d8f7-4c60-8331-3f910ec51f5f	2026-04-21 13:31:46.062
41a21ffb-d1ec-4251-bf96-850593df2bb7	c161f02d-7d64-47bd-8412-424d48166b15	2981a2af-d8f7-4c60-8331-3f910ec51f5f	2026-04-21 13:31:46.075
bc752e0c-d73d-461b-9963-a4e0ccee65f1	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	2981a2af-d8f7-4c60-8331-3f910ec51f5f	2026-04-21 21:11:25.744
92d170cb-a9a6-45d9-8450-9829b58e3bd0	41367728-e8a5-4232-8a08-520075bc6859	2981a2af-d8f7-4c60-8331-3f910ec51f5f	2026-04-21 21:13:17.811
7154ef51-ac96-4f62-81c6-02d13779bfa1	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	2981a2af-d8f7-4c60-8331-3f910ec51f5f	2026-04-22 00:20:30.349
73c3fd4d-2e77-44a7-8081-c8874c791057	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	2981a2af-d8f7-4c60-8331-3f910ec51f5f	2026-04-22 01:12:16.216
62dc096b-4a4c-4f9b-8458-af213ac027f8	c901de33-674a-444d-8892-259897e9e4a9	2981a2af-d8f7-4c60-8331-3f910ec51f5f	2026-04-22 01:12:44.537
0ab39eb1-3ab1-4c1c-9ad9-9590f3bccb19	c901de33-674a-444d-8892-259897e9e4a9	2981a2af-d8f7-4c60-8331-3f910ec51f5f	2026-04-22 01:12:44.544
689af414-0892-45a2-9748-72859a2a379e	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-22 03:03:19.692
ec6cb1e0-f6df-43cd-b5b0-b66e556c345a	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-22 03:03:19.751
4861ebca-e6d7-461b-855d-46a302b67229	9cc14069-c507-44df-900b-3833cea37ead	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-22 16:33:20.625
7062669d-e08c-431c-95b1-8ed75a2ddfba	c901de33-674a-444d-8892-259897e9e4a9	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-22 16:33:48.119
557a2d7a-e72b-4735-9cbc-0584dcccb177	c901de33-674a-444d-8892-259897e9e4a9	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-22 16:33:48.122
bc42f33e-d8c5-47aa-9961-4a7fc8382d10	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-22 16:34:56.458
e100e30c-079f-46f7-a2a6-7eeb2c5cfc1c	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-22 16:34:56.463
bf3cfbd5-4517-46ee-80d3-b45bf65b800e	d3f575e9-3959-4945-adf2-cbadbf53f2e0	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-22 22:12:31.174
6418254e-93d7-4cbe-b290-e90880b3c55c	d3f575e9-3959-4945-adf2-cbadbf53f2e0	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-22 22:12:31.177
6d9e94fc-6dc0-4327-8680-b112cbac301f	51b8a6d1-6450-49a4-b961-3d9bfe465770	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-22 22:12:41.675
99f5e352-3cf1-4e28-b3e3-60200005cdef	51b8a6d1-6450-49a4-b961-3d9bfe465770	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-22 22:12:41.696
b36cbaa1-a208-4e62-847d-a4fecf4f09c1	d3f575e9-3959-4945-adf2-cbadbf53f2e0	f0ce40f7-e29c-4791-8928-fb1bcdf6c85f	2026-04-23 00:03:11.718
954c7abb-3fbe-4be6-ace9-342c0dda394b	9cc14069-c507-44df-900b-3833cea37ead	f0ce40f7-e29c-4791-8928-fb1bcdf6c85f	2026-04-23 15:36:46.653
6d5271de-cf4a-4124-987b-3458f2dc9030	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	f0ce40f7-e29c-4791-8928-fb1bcdf6c85f	2026-04-23 15:36:54.38
8eaece91-0816-48cf-83ee-3cf60ef7965e	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	2981a2af-d8f7-4c60-8331-3f910ec51f5f	2026-04-23 16:23:53.538
05e60c3f-6fd2-4ce3-978a-db5fda8da263	51b8a6d1-6450-49a4-b961-3d9bfe465770	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-23 16:58:14.076
568f6907-8f86-49f2-a665-3fce0276847e	d3f575e9-3959-4945-adf2-cbadbf53f2e0	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-23 16:58:20.888
8accf7fa-38b4-4597-b526-6219c58f4b28	d3f575e9-3959-4945-adf2-cbadbf53f2e0	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-24 07:44:18.161
2fe80557-a249-4a68-8d9e-cc6894deaad4	d3f575e9-3959-4945-adf2-cbadbf53f2e0	056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4	2026-04-25 21:07:12.347
70776b7a-0cf6-4853-88f7-69b2a9b95130	d3f575e9-3959-4945-adf2-cbadbf53f2e0	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-25 22:38:54.952
8b425ec2-e6ff-4c4f-aa01-af796f7baf6d	c901de33-674a-444d-8892-259897e9e4a9	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	2026-04-25 22:39:01.214
9c3730ec-dd81-49ed-ae56-25a0a15d99d2	959feec8-ec17-4e75-8d29-af4f57913c84	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	2026-04-26 09:12:50.651
c1e20836-9068-47f5-b9e8-2a32ebf3f91b	7f8bd3c9-8044-4ac4-bce0-9934871cc100	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	2026-04-26 09:14:36.78
01e6b247-5c97-4f9d-848f-0ca0fb502cf2	cb288153-a8d4-4973-9435-75d98775f743	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	2026-04-26 09:16:30.975
f27a2c69-7a45-4a50-9af8-104f90633af6	36ffa8d9-dd90-414d-b257-db98e4a90f70	f4ce3817-ad27-471d-9dac-20d07a0d1d0d	2026-04-26 09:18:22.474
9b55cdec-32ca-4c5f-a1b8-635b36f3bc58	c901de33-674a-444d-8892-259897e9e4a9	2981a2af-d8f7-4c60-8331-3f910ec51f5f	2026-04-27 11:33:08.733
390a8607-eae4-4816-be40-ba4e2c147f0c	d3f575e9-3959-4945-adf2-cbadbf53f2e0	2981a2af-d8f7-4c60-8331-3f910ec51f5f	2026-04-27 11:33:11.1
78216fad-4db0-45b6-849f-bfe4a532dbcd	9cc14069-c507-44df-900b-3833cea37ead	2981a2af-d8f7-4c60-8331-3f910ec51f5f	2026-04-27 11:33:12.744
4ca5cac7-05fa-4183-8a67-017a1332819e	cb288153-a8d4-4973-9435-75d98775f743	2981a2af-d8f7-4c60-8331-3f910ec51f5f	2026-04-27 11:33:16.93
34cb45ef-f18f-481a-8dd7-778ad63bfc75	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	2981a2af-d8f7-4c60-8331-3f910ec51f5f	2026-04-27 11:33:18.406
\.


--
-- Data for Name: Message; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Message" (id, "conversationId", "senderUserId", "recipientUserId", body, "readAt", "createdAt") FROM stdin;
\.


--
-- Data for Name: Notification; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Notification" (id, "userId", type, title, message, "entityType", "entityId", metadata, "readAt", "dedupeKey", "createdAt") FROM stdin;
6c8805ac-338d-4d63-a14b-e501d358f76a	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	INQUIRY_CREATED	New inquiry	AYham sent an inquiry about your listing.	lead	ea06cd76-96b2-4924-b512-0d14d07fba96	{"source": "listing_details", "listingId": "de47b7a3-b7f4-4016-bbb1-b154988ab7e1"}	2026-04-22 03:03:57.888	lead:ea06cd76-96b2-4924-b512-0d14d07fba96:created	2026-04-22 03:03:52.603
794c3064-8722-4aa6-8a49-bf72b5e8a224	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	INQUIRY_CREATED	New inquiry	Ayham sent an inquiry about your listing.	lead	565a4e73-9d01-4735-abed-df352fadab44	{"source": "listing_details", "listingId": "d3f575e9-3959-4945-adf2-cbadbf53f2e0"}	2026-04-23 17:00:55.966	lead:565a4e73-9d01-4735-abed-df352fadab44:created	2026-04-23 16:58:52.438
39b4b69e-2acc-400d-96f8-0166793a0439	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	SAVED_SEARCH_MATCH	New matching listing	Apartment in Green matches your saved search.	listing	7f8bd3c9-8044-4ac4-bce0-9934871cc100	{"city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "price": 90000, "savedSearchId": "0df360de-4e69-45bc-9e1d-3b09396dccc1", "savedSearchName": "Saved search2"}	\N	saved-search:0df360de-4e69-45bc-9e1d-3b09396dccc1:listing:7f8bd3c9-8044-4ac4-bce0-9934871cc100	2026-04-26 09:14:36.107
fede7fe5-a85c-4edc-8dd9-2a94fb83166d	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	SAVED_SEARCH_MATCH	New matching listing	Apartment in Green matches your saved search.	listing	7f8bd3c9-8044-4ac4-bce0-9934871cc100	{"city": "Tbilisi", "mode": "RENT", "type": "APARTMENT", "price": 90000, "savedSearchId": "134f606d-c9c4-4e33-afb8-45dd57b1a237", "savedSearchName": "Saved search3"}	\N	saved-search:134f606d-c9c4-4e33-afb8-45dd57b1a237:listing:7f8bd3c9-8044-4ac4-bce0-9934871cc100	2026-04-26 09:14:36.107
bb1721bf-77d8-4aac-94e2-df46d5e37868	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	SAVED_SEARCH_MATCH	New matching listing	Apartment in Um Al Fahm matches your saved search.	listing	cb288153-a8d4-4973-9435-75d98775f743	{"city": "Um Al Fahm", "mode": "RENT", "type": "APARTMENT", "price": 140000, "savedSearchId": "0df360de-4e69-45bc-9e1d-3b09396dccc1", "savedSearchName": "Saved search2"}	\N	saved-search:0df360de-4e69-45bc-9e1d-3b09396dccc1:listing:cb288153-a8d4-4973-9435-75d98775f743	2026-04-26 09:16:30.365
0ea370f7-349e-4b85-9153-3860dfd0e15f	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	SAVED_SEARCH_MATCH	New matching listing	Apartment in Um Al Fahm matches your saved search.	listing	cb288153-a8d4-4973-9435-75d98775f743	{"city": "Um Al Fahm", "mode": "RENT", "type": "APARTMENT", "price": 140000, "savedSearchId": "134f606d-c9c4-4e33-afb8-45dd57b1a237", "savedSearchName": "Saved search3"}	\N	saved-search:134f606d-c9c4-4e33-afb8-45dd57b1a237:listing:cb288153-a8d4-4973-9435-75d98775f743	2026-04-26 09:16:30.365
c93000eb-dccb-4977-8aaf-92fb68263a81	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	SAVED_SEARCH_MATCH	New matching listing	Apartment in Green matches your saved search.	listing	36ffa8d9-dd90-414d-b257-db98e4a90f70	{"city": "Tblisi", "mode": "SALE", "type": "APARTMENT", "price": 90000, "savedSearchId": "0df360de-4e69-45bc-9e1d-3b09396dccc1", "savedSearchName": "Saved search2"}	\N	saved-search:0df360de-4e69-45bc-9e1d-3b09396dccc1:listing:36ffa8d9-dd90-414d-b257-db98e4a90f70	2026-04-26 09:18:21.881
\.


--
-- Data for Name: OwnerRating; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."OwnerRating" (id, "ownerUserId", "raterUserId", "listingId", score, comment, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: PasswordResetToken; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."PasswordResetToken" (id, "userId", "tokenHash", "expiresAt", "usedAt", "createdAt") FROM stdin;
\.


--
-- Data for Name: Payment; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."Payment" (id, "userId", "listingId", purpose, status, plan, amount, currency, provider, metadata, "paidAt", "createdAt", "updatedAt") FROM stdin;
acc20ee7-f1bd-4cdd-a685-6b9485dcfb44	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	SUBSCRIPTION	PAID	AGENT	29	USD	local	{"mode": "local_checkout"}	2026-04-22 16:32:12.888	2026-04-22 16:32:12.85	2026-04-22 16:32:12.892
5b6d8c90-3886-4f69-a85d-92b529ed8404	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	c901de33-674a-444d-8892-259897e9e4a9	FEATURED_LISTING	PAID	\N	19	USD	local	{"mode": "local_checkout"}	2026-04-22 16:32:42.044	2026-04-22 16:32:42.021	2026-04-22 16:32:42.044
b3687b0d-0eae-4a8c-915c-f43500c17d79	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	9cc14069-c507-44df-900b-3833cea37ead	BOOST_LISTING	PAID	\N	9	USD	local	{"mode": "local_checkout"}	2026-04-22 16:33:00.162	2026-04-22 16:33:00.135	2026-04-22 16:33:00.162
4fdd61b5-f3b4-48eb-b741-e2e0d5c7e86f	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	FEATURED_LISTING	PAID	\N	19	USD	local	{"mode": "local_checkout"}	2026-04-22 16:35:20.557	2026-04-22 16:35:20.534	2026-04-22 16:35:20.557
93cbb38f-4a8e-4d6e-9831-67da2d27bfd6	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	9cc14069-c507-44df-900b-3833cea37ead	FEATURED_LISTING	PAID	\N	19	USD	local	{"mode": "local_checkout"}	2026-04-22 16:35:33.919	2026-04-22 16:35:33.898	2026-04-22 16:35:33.919
deca1ad5-8151-4533-a97f-20567dae7fa6	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	d3f575e9-3959-4945-adf2-cbadbf53f2e0	BOOST_LISTING	PAID	\N	9	USD	local	{"mode": "local_checkout"}	2026-04-22 16:40:31.616	2026-04-22 16:40:31.587	2026-04-22 16:40:31.622
8099f332-56c1-47dd-8a93-955b0ea85382	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	\N	SUBSCRIPTION	PAID	PREMIUM	79	USD	local	{"mode": "local_checkout"}	2026-04-22 23:48:22.466	2026-04-22 23:48:22.436	2026-04-22 23:48:22.471
5f8cdf3b-5b13-4736-8181-a76384880425	0863bc3f-a7c7-464c-9737-1f49ec6d6a65	\N	SUBSCRIPTION	PAID	AGENT	29	USD	local	{"mode": "local_checkout"}	2026-04-22 23:56:02.575	2026-04-22 23:56:02.544	2026-04-22 23:56:02.58
9799c762-c370-46c4-838c-8059ed3bbe81	f0ce40f7-e29c-4791-8928-fb1bcdf6c85f	\N	SUBSCRIPTION	PAID	AGENT	29	USD	local	{"mode": "local_checkout"}	2026-04-22 23:58:34.521	2026-04-22 23:58:34.468	2026-04-22 23:58:34.522
03194990-5d53-4426-80ff-d6671687852b	056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4	\N	SUBSCRIPTION	PAID	AGENT	29	USD	local	{"mode": "local_checkout"}	2026-04-25 21:08:35.816	2026-04-25 21:08:35.766	2026-04-25 21:08:35.823
\.


--
-- Data for Name: RankingDecision; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."RankingDecision" (id, objective, "queryText", strategy, "filtersJson", "viewerJson", "engineVersion", "weightsJson", "createdAt") FROM stdin;
337caaf0-3c21-4494-9340-63b05e504cf4	SEARCH	\N	\N	{}	\N	hybrid_ai_v1	{"ai": 0.45, "rules": 0.55}	2026-04-26 09:09:45.194
c8906dda-c164-4f47-b2ba-277c602d7565	SEARCH	\N	\N	{}	\N	hybrid_ai_v1	{"ai": 0.45, "rules": 0.55}	2026-04-26 09:09:45.198
a417a8a5-befb-458d-ac29-8b1666877f7d	SEARCH	\N	\N	{}	\N	hybrid_ai_v1	{"ai": 0.45, "rules": 0.55}	2026-04-26 09:09:45.46
cb0487e4-662b-450c-9626-03d55b86ae72	SEARCH	\N	\N	{}	\N	hybrid_ai_v1	{"ai": 0.45, "rules": 0.55}	2026-04-26 09:09:45.801
665f614e-4317-4d54-82e2-437afe897cf4	SEARCH	\N	\N	{}	\N	hybrid_ai_v1	{"ai": 0.45, "rules": 0.55}	2026-04-26 09:09:45.856
a21916d5-5654-4ac6-b20f-021943fa398a	SEARCH	\N	\N	{}	\N	hybrid_ai_v1	{"ai": 0.45, "rules": 0.55}	2026-04-26 09:09:45.984
b53de7dd-d198-4126-a066-8371fcf2cce1	SEARCH	\N	\N	{}	\N	hybrid_ai_v1	{"ai": 0.45, "rules": 0.55}	2026-04-26 09:10:41.044
657c463a-1e7e-41b3-893a-4aedc7bf1ce8	SEARCH	\N	\N	{}	\N	hybrid_ai_v1	{"ai": 0.45, "rules": 0.55}	2026-04-26 09:10:41.089
f30acdad-79ce-4d7c-b190-4f30ba0225ee	RECOMMENDATION	\N	AI	\N	{"preferredModes": [], "preferredTypes": [], "preferredCities": []}	hybrid_ai_v1	{"ai": 0.35, "rules": 0.65}	2026-04-26 09:12:54.547
0a7d19f3-6a92-4f6e-a533-53d5d6f61261	RECOMMENDATION	\N	AI	\N	{"maxArea": 74.25, "minArea": 35.75, "maxPrice": 94500, "minPrice": 45500, "preferredModes": ["RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tbilisi"]}	hybrid_ai_v1	{"ai": 0.35, "rules": 0.65}	2026-04-26 09:12:54.881
cc01582a-3e62-4d27-b609-bede125d923e	RECOMMENDATION	\N	AI	\N	{"maxArea": 74.25, "minArea": 35.75, "maxPrice": 94500, "minPrice": 45500, "preferredModes": ["RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tbilisi"]}	hybrid_ai_v1	{"ai": 0.35, "rules": 0.65}	2026-04-26 09:14:40.648
1d157efc-aaba-4770-9792-def054c7efb1	RECOMMENDATION	\N	AI	\N	{"maxArea": 74.25, "minArea": 35.75, "maxPrice": 94500, "minPrice": 45500, "preferredModes": ["RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tbilisi"]}	hybrid_ai_v1	{"ai": 0.35, "rules": 0.65}	2026-04-26 09:14:40.843
61d135b2-1363-497e-9f5e-d98b30d8b311	RECOMMENDATION	\N	AI	\N	{"maxArea": 91.125, "minArea": 43.875, "maxPrice": 108000, "minPrice": 52000, "preferredModes": ["RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tbilisi"]}	hybrid_ai_v1	{"ai": 0.35, "rules": 0.65}	2026-04-26 09:14:47.641
65c085d5-2990-4825-90ed-f37ee6d29c2f	RECOMMENDATION	\N	AI	\N	{"maxArea": 91.125, "minArea": 43.875, "maxPrice": 108000, "minPrice": 52000, "preferredModes": ["RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tbilisi"]}	hybrid_ai_v1	{"ai": 0.35, "rules": 0.65}	2026-04-26 09:14:47.687
4cdaec6a-832d-4546-a2a9-f1ec0c83f83c	RECOMMENDATION	\N	AI	\N	{"maxArea": 91.125, "minArea": 43.875, "maxPrice": 108000, "minPrice": 52000, "preferredModes": ["RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tbilisi"]}	hybrid_ai_v1	{"ai": 0.35, "rules": 0.65}	2026-04-26 09:16:34.677
cc641112-62d3-487c-b86f-0ca79ccf4a3c	RECOMMENDATION	\N	AI	\N	{"maxArea": 91.125, "minArea": 43.875, "maxPrice": 108000, "minPrice": 52000, "preferredModes": ["RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tbilisi"]}	hybrid_ai_v1	{"ai": 0.35, "rules": 0.65}	2026-04-26 09:16:35.636
e92ee9c2-546e-4f7e-b239-9d9cffb30477	RECOMMENDATION	\N	AI	\N	{"maxArea": 114.75000000000001, "minArea": 55.25, "maxPrice": 135000, "minPrice": 65000, "preferredModes": ["RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Um Al Fahm", "Tbilisi"]}	hybrid_ai_v1	{"ai": 0.35, "rules": 0.65}	2026-04-26 09:18:26.992
1ac01f16-4085-4168-a13a-f60ee036d2ba	RECOMMENDATION	\N	AI	\N	{"maxArea": 118.12500000000001, "minArea": 56.875, "maxPrice": 131625, "minPrice": 63375, "preferredModes": ["SALE", "RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tblisi", "Um Al Fahm", "Tbilisi"]}	hybrid_ai_v1	{"ai": 0.35, "rules": 0.65}	2026-04-26 09:18:30.084
31a0df73-e910-40b8-9052-d900f69e304b	RECOMMENDATION	\N	AI	\N	{"maxArea": 118.12500000000001, "minArea": 56.875, "maxPrice": 131625, "minPrice": 63375, "preferredModes": ["SALE", "RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tblisi", "Um Al Fahm", "Tbilisi"]}	hybrid_ai_v1	{"ai": 0.35, "rules": 0.65}	2026-04-26 09:18:30.455
bf08146a-6c62-4a56-b317-a89092cb67ef	RECOMMENDATION	\N	AI	\N	{"maxArea": 114.75000000000001, "minArea": 55.25, "maxPrice": 135000, "minPrice": 65000, "preferredModes": ["RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Um Al Fahm", "Tbilisi"]}	hybrid_ai_v1	{"ai": 0.35, "rules": 0.65}	2026-04-26 09:18:39.027
13be373a-d676-436b-81f6-252532e34865	RECOMMENDATION	\N	AI	\N	{"maxArea": 126.9, "minArea": 61.1, "maxPrice": 143100, "minPrice": 68900, "preferredModes": ["SALE", "RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tblisi", "Um Al Fahm", "Tbilisi"]}	hybrid_ai_v1	{"ai": 0.35, "rules": 0.65}	2026-04-26 09:19:30.065
9e1bdcbd-aaa1-42e0-a661-3bed478a7e84	RECOMMENDATION	\N	AI	\N	{"maxArea": 126.9, "minArea": 61.1, "maxPrice": 143100, "minPrice": 68900, "preferredModes": ["SALE", "RENT"], "preferredTypes": ["APARTMENT"], "preferredCities": ["Tblisi", "Um Al Fahm", "Tbilisi"]}	hybrid_ai_v1	{"ai": 0.35, "rules": 0.65}	2026-04-26 09:19:30.816
bd22e583-4093-411a-ab61-aea95e9f15c9	SEARCH	\N	\N	{}	\N	hybrid_ai_v1	{"ai": 0.45, "rules": 0.55}	2026-04-27 11:33:01.819
c471bff0-3aef-48b6-ac4e-131b1e6d9cae	SEARCH	\N	\N	{}	\N	hybrid_ai_v1	{"ai": 0.45, "rules": 0.55}	2026-04-27 11:33:01.821
dda48ad9-530a-4811-a0d4-9b066aa2683f	SEARCH	\N	\N	{}	\N	hybrid_ai_v1	{"ai": 0.45, "rules": 0.55}	2026-04-27 11:33:07.407
1ba1cbe2-e6f4-40b6-a8dd-1dcbc77e81d8	SEARCH	\N	\N	{}	\N	hybrid_ai_v1	{"ai": 0.45, "rules": 0.55}	2026-04-27 11:33:07.51
6c293be2-5e68-4df2-9a81-015fc88ef4f4	RECOMMENDATION	\N	BEHAVIOR	\N	{"maxArea": 135.84375, "minArea": 65.40625, "maxPrice": 160312.5, "minPrice": 77187.5, "preferredModes": ["RENT", "SALE"], "preferredTypes": ["HOUSE", "APARTMENT"], "preferredCities": ["Tel Aviv", "Um Al Fahm", "Haifa"]}	hybrid_ai_v1	{"ai": 0.35, "rules": 0.65}	2026-04-27 11:33:32.264
1436282b-5169-48b2-a81a-2d39832da405	RECOMMENDATION	\N	BEHAVIOR	\N	{"maxArea": 135.84375, "minArea": 65.40625, "maxPrice": 160312.5, "minPrice": 77187.5, "preferredModes": ["RENT", "SALE"], "preferredTypes": ["HOUSE", "APARTMENT"], "preferredCities": ["Tel Aviv", "Um Al Fahm", "Haifa"]}	hybrid_ai_v1	{"ai": 0.35, "rules": 0.65}	2026-04-27 11:33:32.889
\.


--
-- Data for Name: RankingDecisionItem; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."RankingDecisionItem" (id, "decisionId", "listingId", "listingTitle", city, price, rank, score, "baseScore", "aiScore", reason, "createdAt") FROM stdin;
d72b2eb0-dd61-4fc7-a1a5-0d86f83536c8	c8906dda-c164-4f47-b2ba-277c602d7565	c901de33-674a-444d-8892-259897e9e4a9	Modern property with strong potential	Tel Aviv	120000	1	55.5	61.8	47.8	hybrid fallback	2026-04-26 09:09:45.198
85195df1-bb77-45db-88d1-73a73d75f2a4	c8906dda-c164-4f47-b2ba-277c602d7565	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	2	51.4	54.06	48.15	hybrid fallback	2026-04-26 09:09:45.198
53d6f06d-4325-4e98-b8de-c1dbd54ed3d6	c8906dda-c164-4f47-b2ba-277c602d7565	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	3	48.15	50.2	45.65	trust penalty	2026-04-26 09:09:45.198
88ce2da9-92e0-4070-ac2e-45636b2f98f0	c8906dda-c164-4f47-b2ba-277c602d7565	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	4	48.04	54.04	40.7	hybrid fallback	2026-04-26 09:09:45.198
a2b0407e-9572-43e2-bdf7-70bfd9843635	c8906dda-c164-4f47-b2ba-277c602d7565	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	5	47.54	49.86	44.7	hybrid fallback	2026-04-26 09:09:45.198
39219a72-df2f-4d42-b188-bd109a79b238	c8906dda-c164-4f47-b2ba-277c602d7565	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	6	45.24	47.64	42.3	hybrid fallback	2026-04-26 09:09:45.198
593a3342-5f1a-4120-b635-9f04d5a56d10	c8906dda-c164-4f47-b2ba-277c602d7565	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	7	43.44	45.56	40.85	hybrid fallback	2026-04-26 09:09:45.198
20d03dcd-ade5-4862-ab10-c28bd6cb2bbe	c8906dda-c164-4f47-b2ba-277c602d7565	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	8	43.44	45.76	40.6	hybrid fallback	2026-04-26 09:09:45.198
80e0eb8c-d666-4232-804d-b5a18c800588	c8906dda-c164-4f47-b2ba-277c602d7565	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	9	33.11	35.16	30.6	trust penalty	2026-04-26 09:09:45.198
5afa150d-57e4-49b8-afe7-e5c19e5900b1	337caaf0-3c21-4494-9340-63b05e504cf4	c901de33-674a-444d-8892-259897e9e4a9	Modern property with strong potential	Tel Aviv	120000	1	55.5	61.8	47.8	hybrid fallback	2026-04-26 09:09:45.194
1af38db5-7c70-408a-b838-3f89179a21ab	337caaf0-3c21-4494-9340-63b05e504cf4	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	2	51.4	54.06	48.15	hybrid fallback	2026-04-26 09:09:45.194
075ed9c0-f382-41d0-93db-563d8dd6a777	337caaf0-3c21-4494-9340-63b05e504cf4	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	3	48.15	50.2	45.65	trust penalty	2026-04-26 09:09:45.194
2b4e23c8-c53a-47d3-b481-3dfcabc21489	337caaf0-3c21-4494-9340-63b05e504cf4	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	4	48.04	54.04	40.7	hybrid fallback	2026-04-26 09:09:45.194
41e68c86-832c-4fd1-a147-61a700512afc	337caaf0-3c21-4494-9340-63b05e504cf4	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	5	47.54	49.86	44.7	hybrid fallback	2026-04-26 09:09:45.194
4a213cc0-9e0e-476e-9cd4-05d17e513073	337caaf0-3c21-4494-9340-63b05e504cf4	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	6	45.24	47.64	42.3	hybrid fallback	2026-04-26 09:09:45.194
b15fcbf8-73bf-4cf5-aff4-4cc9c0f0dd00	337caaf0-3c21-4494-9340-63b05e504cf4	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	7	43.44	45.56	40.85	hybrid fallback	2026-04-26 09:09:45.194
1ad0a244-1c43-470a-ba53-37766ea46d12	337caaf0-3c21-4494-9340-63b05e504cf4	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	8	43.44	45.76	40.6	hybrid fallback	2026-04-26 09:09:45.194
e35f4fd8-0b0d-4020-b1ae-8ac154d58978	337caaf0-3c21-4494-9340-63b05e504cf4	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	9	33.11	35.16	30.6	trust penalty	2026-04-26 09:09:45.194
6bf1b2c0-c059-4a15-ad7f-ede1884cd8be	a417a8a5-befb-458d-ac29-8b1666877f7d	c901de33-674a-444d-8892-259897e9e4a9	Modern property with strong potential	Tel Aviv	120000	1	55.5	61.8	47.8	hybrid fallback	2026-04-26 09:09:45.46
63d8f3a5-a21b-489a-bde7-a99c6ea3cc70	a417a8a5-befb-458d-ac29-8b1666877f7d	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	2	51.4	54.06	48.15	hybrid fallback	2026-04-26 09:09:45.46
c70b0529-38ef-470e-ab41-b4f1226a9155	a417a8a5-befb-458d-ac29-8b1666877f7d	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	3	48.15	50.2	45.65	trust penalty	2026-04-26 09:09:45.46
e6587882-d291-4277-b812-55ecf161fb2e	a417a8a5-befb-458d-ac29-8b1666877f7d	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	4	48.04	54.04	40.7	hybrid fallback	2026-04-26 09:09:45.46
3fd1b8f8-fe6e-40dd-9a98-bf86e03fe31a	a417a8a5-befb-458d-ac29-8b1666877f7d	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	5	47.54	49.86	44.7	hybrid fallback	2026-04-26 09:09:45.46
ffa2bc83-332a-4b04-ba46-4d6d343319ca	a417a8a5-befb-458d-ac29-8b1666877f7d	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	6	45.24	47.64	42.3	hybrid fallback	2026-04-26 09:09:45.46
b9e3a02c-b851-4b35-8680-a0ca9ce2c031	a417a8a5-befb-458d-ac29-8b1666877f7d	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	7	43.44	45.56	40.85	hybrid fallback	2026-04-26 09:09:45.46
15d59fdd-0abf-4e05-b1fc-809ece83b6be	a417a8a5-befb-458d-ac29-8b1666877f7d	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	8	43.44	45.76	40.6	hybrid fallback	2026-04-26 09:09:45.46
06f690a6-94fc-4a8d-9e16-2aceca7cd7aa	a417a8a5-befb-458d-ac29-8b1666877f7d	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	9	33.11	35.16	30.6	trust penalty	2026-04-26 09:09:45.46
0dea0e22-0d61-4c05-81a6-b31f04470e0b	cb0487e4-662b-450c-9626-03d55b86ae72	c901de33-674a-444d-8892-259897e9e4a9	Modern property with strong potential	Tel Aviv	120000	1	55.5	61.8	47.8	hybrid fallback	2026-04-26 09:09:45.801
245daf38-aa67-4166-bfb3-b66c947b9762	cb0487e4-662b-450c-9626-03d55b86ae72	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	2	51.4	54.06	48.15	hybrid fallback	2026-04-26 09:09:45.801
fb456a3a-3f00-4f0e-90b6-18d790c1f6a8	cb0487e4-662b-450c-9626-03d55b86ae72	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	3	48.15	50.2	45.65	trust penalty	2026-04-26 09:09:45.801
025e26a3-4290-46b2-9d7e-2354f1b6b9ad	cb0487e4-662b-450c-9626-03d55b86ae72	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	4	48.04	54.04	40.7	hybrid fallback	2026-04-26 09:09:45.801
f2661693-ee56-4631-86a3-6992260bcb73	cb0487e4-662b-450c-9626-03d55b86ae72	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	5	47.54	49.86	44.7	hybrid fallback	2026-04-26 09:09:45.801
6d1787eb-a212-4c18-b40e-7f4e92429169	cb0487e4-662b-450c-9626-03d55b86ae72	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	6	45.24	47.64	42.3	hybrid fallback	2026-04-26 09:09:45.801
2d1b37e3-6235-43e5-92c6-b81a49759879	cb0487e4-662b-450c-9626-03d55b86ae72	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	7	43.44	45.56	40.85	hybrid fallback	2026-04-26 09:09:45.801
2b7d1ee5-5d4a-43dc-a224-529d6b22bbd4	cb0487e4-662b-450c-9626-03d55b86ae72	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	8	43.44	45.76	40.6	hybrid fallback	2026-04-26 09:09:45.801
c6e85553-b4f4-486a-98af-44ad2255f8d2	cb0487e4-662b-450c-9626-03d55b86ae72	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	9	33.11	35.16	30.6	trust penalty	2026-04-26 09:09:45.801
67e027d5-1730-40a2-9002-d811d1fcc56b	665f614e-4317-4d54-82e2-437afe897cf4	c901de33-674a-444d-8892-259897e9e4a9	Modern property with strong potential	Tel Aviv	120000	1	55.5	61.8	47.8	hybrid fallback	2026-04-26 09:09:45.856
aad21145-a311-4b1c-8e42-0f5e9d123158	665f614e-4317-4d54-82e2-437afe897cf4	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	2	51.4	54.06	48.15	hybrid fallback	2026-04-26 09:09:45.856
5bfc6c44-8649-4840-bd79-b533ba885ba1	665f614e-4317-4d54-82e2-437afe897cf4	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	3	48.15	50.2	45.65	trust penalty	2026-04-26 09:09:45.856
4538c7f9-f290-4c48-9b63-f42279333c7f	665f614e-4317-4d54-82e2-437afe897cf4	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	4	48.04	54.04	40.7	hybrid fallback	2026-04-26 09:09:45.856
6935f61d-08c4-49f7-9ece-01fba1dc5445	665f614e-4317-4d54-82e2-437afe897cf4	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	5	47.54	49.86	44.7	hybrid fallback	2026-04-26 09:09:45.856
9248a013-a9c8-4ddc-b0a0-3809f4305d55	665f614e-4317-4d54-82e2-437afe897cf4	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	6	45.24	47.64	42.3	hybrid fallback	2026-04-26 09:09:45.856
4b254863-b361-4dba-bf8e-c4c52a2d16f0	665f614e-4317-4d54-82e2-437afe897cf4	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	7	43.44	45.56	40.85	hybrid fallback	2026-04-26 09:09:45.856
aac419f7-712d-49a4-9160-15dcff1e730d	665f614e-4317-4d54-82e2-437afe897cf4	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	8	43.44	45.76	40.6	hybrid fallback	2026-04-26 09:09:45.856
4d65e08e-9cff-4e09-adf5-cb06f2547240	665f614e-4317-4d54-82e2-437afe897cf4	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	9	33.11	35.16	30.6	trust penalty	2026-04-26 09:09:45.856
b3eb9975-5e9a-4504-9c70-d3cb267ab80a	a21916d5-5654-4ac6-b20f-021943fa398a	c901de33-674a-444d-8892-259897e9e4a9	Modern property with strong potential	Tel Aviv	120000	1	55.5	61.8	47.8	hybrid fallback	2026-04-26 09:09:45.984
bad0812d-e49c-4b87-988d-82d3e22f2a40	a21916d5-5654-4ac6-b20f-021943fa398a	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	2	51.4	54.06	48.15	hybrid fallback	2026-04-26 09:09:45.984
3d76bae8-dd16-45dd-b4bc-69b29568a870	a21916d5-5654-4ac6-b20f-021943fa398a	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	3	48.15	50.2	45.65	trust penalty	2026-04-26 09:09:45.984
e9f754dc-4f23-4e97-9c99-63e7a0c20d62	a21916d5-5654-4ac6-b20f-021943fa398a	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	4	48.04	54.04	40.7	hybrid fallback	2026-04-26 09:09:45.984
2e3ed9f0-d123-429a-87bc-005cd1cd922f	a21916d5-5654-4ac6-b20f-021943fa398a	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	5	47.54	49.86	44.7	hybrid fallback	2026-04-26 09:09:45.984
c1987dca-02bd-4eff-9048-dd7ad486a016	a21916d5-5654-4ac6-b20f-021943fa398a	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	6	45.24	47.64	42.3	hybrid fallback	2026-04-26 09:09:45.984
174812dd-b7eb-42d4-a11d-994404452e5e	a21916d5-5654-4ac6-b20f-021943fa398a	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	7	43.44	45.56	40.85	hybrid fallback	2026-04-26 09:09:45.984
be95ef11-cff7-405b-b66b-4d66bf14642a	a21916d5-5654-4ac6-b20f-021943fa398a	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	8	43.44	45.76	40.6	hybrid fallback	2026-04-26 09:09:45.984
c42433dc-d0d9-4413-aadb-5364bec6cc39	a21916d5-5654-4ac6-b20f-021943fa398a	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	9	33.11	35.16	30.6	trust penalty	2026-04-26 09:09:45.984
aeb5fe5c-6d94-4909-8754-1fb0bf76308f	b53de7dd-d198-4126-a066-8371fcf2cce1	c901de33-674a-444d-8892-259897e9e4a9	Modern property with strong potential	Tel Aviv	120000	1	61.8	61.8	61.8	ai fallback	2026-04-26 09:10:41.044
3d7ae0a0-8492-48b0-9136-ef8ca8881e8f	b53de7dd-d198-4126-a066-8371fcf2cce1	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	2	54.06	54.06	54.06	ai fallback	2026-04-26 09:10:41.044
f0786e06-528b-450c-961b-c0466e220081	b53de7dd-d198-4126-a066-8371fcf2cce1	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	3	54.04	54.04	54.04	ai fallback	2026-04-26 09:10:41.044
2b22f867-fce9-4ea7-b496-202e50485dfd	b53de7dd-d198-4126-a066-8371fcf2cce1	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	4	50.2	50.2	50.2	ai fallback	2026-04-26 09:10:41.044
220fc2c1-f5aa-4903-8ed5-0363c708f18c	b53de7dd-d198-4126-a066-8371fcf2cce1	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	5	49.86	49.86	49.86	ai fallback	2026-04-26 09:10:41.044
fe791959-7e0a-467d-87c9-fc1f6d11cedb	b53de7dd-d198-4126-a066-8371fcf2cce1	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	6	47.64	47.64	47.64	ai fallback	2026-04-26 09:10:41.044
1441251d-1126-401d-a120-11331245653d	b53de7dd-d198-4126-a066-8371fcf2cce1	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	7	45.76	45.76	45.76	ai fallback	2026-04-26 09:10:41.044
851d84d6-70db-41c9-aaa3-dbc633ab9383	b53de7dd-d198-4126-a066-8371fcf2cce1	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	8	45.56	45.56	45.56	ai fallback	2026-04-26 09:10:41.044
7c7191b2-53b8-4d21-9ca3-b900767dd1a3	b53de7dd-d198-4126-a066-8371fcf2cce1	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	9	35.16	35.16	35.16	ai fallback	2026-04-26 09:10:41.044
e96cb0a5-9d16-4ff3-9b93-d8a860186379	657c463a-1e7e-41b3-893a-4aedc7bf1ce8	c901de33-674a-444d-8892-259897e9e4a9	Modern property with strong potential	Tel Aviv	120000	1	61.8	61.8	61.8	ai fallback	2026-04-26 09:10:41.089
61f367c6-57f2-4977-96c4-9cdc6b0d5cb5	657c463a-1e7e-41b3-893a-4aedc7bf1ce8	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	2	54.06	54.06	54.06	ai fallback	2026-04-26 09:10:41.089
cda69509-7781-42f1-a631-0eea065937a6	657c463a-1e7e-41b3-893a-4aedc7bf1ce8	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	3	54.04	54.04	54.04	ai fallback	2026-04-26 09:10:41.089
881c31c1-6406-419a-8f64-f0d4378844c6	657c463a-1e7e-41b3-893a-4aedc7bf1ce8	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	4	50.2	50.2	50.2	ai fallback	2026-04-26 09:10:41.089
c9c9e44a-0f04-499d-bbf5-49c0d9c3d6ab	657c463a-1e7e-41b3-893a-4aedc7bf1ce8	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	5	49.86	49.86	49.86	ai fallback	2026-04-26 09:10:41.089
86906de4-347a-4d43-aa7f-2f8ad39a3410	657c463a-1e7e-41b3-893a-4aedc7bf1ce8	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	6	47.64	47.64	47.64	ai fallback	2026-04-26 09:10:41.089
8313ff97-64a6-4617-8b38-aba3e785d3c4	657c463a-1e7e-41b3-893a-4aedc7bf1ce8	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	7	45.76	45.76	45.76	ai fallback	2026-04-26 09:10:41.089
4eb2915e-286f-4981-a75e-585a20946876	657c463a-1e7e-41b3-893a-4aedc7bf1ce8	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	8	45.56	45.56	45.56	ai fallback	2026-04-26 09:10:41.089
407ad429-9596-4d13-89a3-f082dc9e61b7	657c463a-1e7e-41b3-893a-4aedc7bf1ce8	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	9	35.16	35.16	35.16	ai fallback	2026-04-26 09:10:41.089
3242d644-8367-4334-a0d3-92e9a42840e0	f30acdad-79ce-4d7c-b190-4f30ba0225ee	c901de33-674a-444d-8892-259897e9e4a9	Modern property with strong potential	Tel Aviv	120000	1	60.8	67.8	47.8	hybrid fallback	2026-04-26 09:12:54.547
a08b1fcb-93b6-46e6-85db-e436aae30ded	f30acdad-79ce-4d7c-b190-4f30ba0225ee	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	2	55.89	60.06	48.15	hybrid fallback	2026-04-26 09:12:54.547
dfc6a7ed-541a-499c-84bd-1d01b1725e56	f30acdad-79ce-4d7c-b190-4f30ba0225ee	959feec8-ec17-4e75-8d29-af4f57913c84	Apartment1 in Green	Tbilisi	70000	3	54.95	56	53	hybrid fallback	2026-04-26 09:12:54.547
df99d83e-3680-4b6a-8f31-6b89d7e1e293	f30acdad-79ce-4d7c-b190-4f30ba0225ee	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	4	53.27	60.04	40.7	hybrid fallback	2026-04-26 09:12:54.547
31a8e000-0ecc-4e60-85a9-6d47c6e31ef7	f30acdad-79ce-4d7c-b190-4f30ba0225ee	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	5	52.51	56.2	45.65	trust penalty	2026-04-26 09:12:54.547
61ed7614-e318-4e64-8d6e-221d18238653	f30acdad-79ce-4d7c-b190-4f30ba0225ee	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	6	51.95	55.86	44.7	hybrid fallback	2026-04-26 09:12:54.547
81038adb-75eb-471a-96b1-8073c7da2289	f30acdad-79ce-4d7c-b190-4f30ba0225ee	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	7	49.67	53.64	42.3	hybrid fallback	2026-04-26 09:12:54.547
844ef43c-aa37-4a30-aa10-72da8dfa9bd6	f30acdad-79ce-4d7c-b190-4f30ba0225ee	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	8	47.85	51.76	40.6	hybrid fallback	2026-04-26 09:12:54.547
7a9e1c96-e50e-493b-8360-1e72459a57c6	f30acdad-79ce-4d7c-b190-4f30ba0225ee	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	9	47.81	51.56	40.85	hybrid fallback	2026-04-26 09:12:54.547
3cdca176-bbf7-4153-a1de-27d804ab5502	f30acdad-79ce-4d7c-b190-4f30ba0225ee	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	10	37.46	41.16	30.6	trust penalty	2026-04-26 09:12:54.547
a6af4ecc-2d27-4f66-bfed-bfe3579fe075	0a7d19f3-6a92-4f6e-a533-53d5d6f61261	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	1	68.62	75.04	56.7	hybrid fallback	2026-04-26 09:12:54.881
f556ef13-8910-41e2-bb51-86cef6ed96a7	0a7d19f3-6a92-4f6e-a533-53d5d6f61261	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	2	65.95	69.86	58.7	hybrid fallback	2026-04-26 09:12:54.881
c9f6c9b4-4804-4ddc-b8d8-e9da47bf8bca	0a7d19f3-6a92-4f6e-a533-53d5d6f61261	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	3	65.89	70.06	58.15	hybrid fallback	2026-04-26 09:12:54.881
4aa89a51-59ef-41f2-bc33-45bc5086a079	0a7d19f3-6a92-4f6e-a533-53d5d6f61261	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	4	61.85	65.76	54.6	hybrid fallback	2026-04-26 09:12:54.881
e44040ea-3618-4aa1-9752-1019b47b1881	0a7d19f3-6a92-4f6e-a533-53d5d6f61261	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	5	61.81	65.56	54.85	hybrid fallback	2026-04-26 09:12:54.881
51b46973-ba03-4b4f-8a09-dfd6211eaa7a	0a7d19f3-6a92-4f6e-a533-53d5d6f61261	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	6	59.67	63.64	52.3	hybrid fallback	2026-04-26 09:12:54.881
f4a96add-0722-46b0-a436-f6886e08180d	0a7d19f3-6a92-4f6e-a533-53d5d6f61261	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	7	56.51	60.2	49.65	trust penalty	2026-04-26 09:12:54.881
12835d18-5888-4111-9d33-ca6f8bcd0906	0a7d19f3-6a92-4f6e-a533-53d5d6f61261	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	8	51.46	55.16	44.6	trust penalty	2026-04-26 09:12:54.881
2fb03f1a-58ff-47ff-b263-a6570ee8bee3	cc01582a-3e62-4d27-b609-bede125d923e	7f8bd3c9-8044-4ac4-bce0-9934871cc100	Apartment in Green	Tbilisi	90000	1	80.95	82	79	city preference	2026-04-26 09:14:40.648
05629516-544f-4d72-8b68-6e49c3ae353f	cc01582a-3e62-4d27-b609-bede125d923e	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	2	68.62	75.04	56.7	hybrid fallback	2026-04-26 09:14:40.648
394ae509-6c57-4105-9a4a-62ee768d3096	cc01582a-3e62-4d27-b609-bede125d923e	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	3	65.95	69.86	58.7	hybrid fallback	2026-04-26 09:14:40.648
fb1ad7d1-ac23-4984-aec1-d47adf5ee3ff	cc01582a-3e62-4d27-b609-bede125d923e	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	4	65.89	70.06	58.15	hybrid fallback	2026-04-26 09:14:40.648
952b4e9a-6254-483e-b27c-0835fa844138	cc01582a-3e62-4d27-b609-bede125d923e	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	5	61.85	65.76	54.6	hybrid fallback	2026-04-26 09:14:40.648
45a2fb53-f727-4ec1-93c4-c5c28eb54249	cc01582a-3e62-4d27-b609-bede125d923e	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	6	61.81	65.56	54.85	hybrid fallback	2026-04-26 09:14:40.648
d2986453-4656-48e5-9da9-0548d045e492	cc01582a-3e62-4d27-b609-bede125d923e	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	7	59.67	63.64	52.3	hybrid fallback	2026-04-26 09:14:40.648
543e5cc6-1563-424b-a0c3-32a194257caa	cc01582a-3e62-4d27-b609-bede125d923e	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	8	56.51	60.2	49.65	trust penalty	2026-04-26 09:14:40.648
226b7ddb-d1ff-426e-8ab3-b0a895caf501	cc01582a-3e62-4d27-b609-bede125d923e	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	9	51.46	55.16	44.6	trust penalty	2026-04-26 09:14:40.648
77e66943-8016-48ee-82c4-c62410112c7d	1d157efc-aaba-4770-9792-def054c7efb1	7f8bd3c9-8044-4ac4-bce0-9934871cc100	Apartment in Green	Tbilisi	90000	1	81.12	82.18	79.15	city preference	2026-04-26 09:14:40.843
d9a50f37-0162-44d2-886c-e4103406124e	1d157efc-aaba-4770-9792-def054c7efb1	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	2	68.62	75.04	56.7	hybrid fallback	2026-04-26 09:14:40.843
11159455-cb2d-4dae-bb53-fb3d62faedd4	1d157efc-aaba-4770-9792-def054c7efb1	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	3	65.95	69.86	58.7	hybrid fallback	2026-04-26 09:14:40.843
675ff44f-c955-4c5d-9a36-b948cfaf3d57	1d157efc-aaba-4770-9792-def054c7efb1	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	4	65.89	70.06	58.15	hybrid fallback	2026-04-26 09:14:40.843
5d5e2722-ac96-41a6-8fea-c5e75645ce83	1d157efc-aaba-4770-9792-def054c7efb1	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	5	61.85	65.76	54.6	hybrid fallback	2026-04-26 09:14:40.843
d7bbeb11-8216-4bbe-b0cf-712c851fc6a0	1d157efc-aaba-4770-9792-def054c7efb1	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	6	61.81	65.56	54.85	hybrid fallback	2026-04-26 09:14:40.843
aed8618a-6404-450a-b4b0-f6254e94f6d1	1d157efc-aaba-4770-9792-def054c7efb1	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	7	59.67	63.64	52.3	hybrid fallback	2026-04-26 09:14:40.843
613a977d-1749-47b8-97b5-81cb1f236223	1d157efc-aaba-4770-9792-def054c7efb1	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	8	56.51	60.2	49.65	trust penalty	2026-04-26 09:14:40.843
d9d8a972-1b73-498a-bda3-98037e458969	1d157efc-aaba-4770-9792-def054c7efb1	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	9	51.46	55.16	44.6	trust penalty	2026-04-26 09:14:40.843
1c87129f-6871-49f9-8c2f-32c506486e1f	61d135b2-1363-497e-9f5e-d98b30d8b311	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	1	69.89	74.06	62.15	hybrid fallback	2026-04-26 09:14:47.641
763fcd4e-0019-4a16-b812-6659a4299ba5	61d135b2-1363-497e-9f5e-d98b30d8b311	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	2	68.62	75.04	56.7	hybrid fallback	2026-04-26 09:14:47.641
7add6a57-a3aa-4eaf-a057-e0d884664707	61d135b2-1363-497e-9f5e-d98b30d8b311	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	3	65.95	69.86	58.7	hybrid fallback	2026-04-26 09:14:47.641
65e7c684-bda6-4d3c-a4e0-130098b38222	61d135b2-1363-497e-9f5e-d98b30d8b311	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	4	61.85	65.76	54.6	hybrid fallback	2026-04-26 09:14:47.641
ec5559f6-3aa7-43ee-8479-184a7db0df03	61d135b2-1363-497e-9f5e-d98b30d8b311	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	5	60.51	64.2	53.65	trust penalty	2026-04-26 09:14:47.641
4abfc243-c52d-46b6-a418-136796501586	61d135b2-1363-497e-9f5e-d98b30d8b311	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	6	59.67	63.64	52.3	hybrid fallback	2026-04-26 09:14:47.641
5e2c9ffd-1c6c-4987-895e-49e5fde95944	61d135b2-1363-497e-9f5e-d98b30d8b311	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	7	57.81	61.56	50.85	hybrid fallback	2026-04-26 09:14:47.641
366b1c9d-5016-441e-a850-13377dce6267	61d135b2-1363-497e-9f5e-d98b30d8b311	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	8	51.46	55.16	44.6	trust penalty	2026-04-26 09:14:47.641
d37b783b-f196-4655-aa19-758779569874	65c085d5-2990-4825-90ed-f37ee6d29c2f	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	1	69.89	74.06	62.15	hybrid fallback	2026-04-26 09:14:47.687
1be82433-5911-4755-baf4-b516c4b48c06	65c085d5-2990-4825-90ed-f37ee6d29c2f	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	2	68.62	75.04	56.7	hybrid fallback	2026-04-26 09:14:47.687
da1e3c61-29a9-40bc-b3d4-fe7ccc28dd33	65c085d5-2990-4825-90ed-f37ee6d29c2f	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	3	65.95	69.86	58.7	hybrid fallback	2026-04-26 09:14:47.687
896d7bd8-e798-494e-8981-9cf9984cbd78	65c085d5-2990-4825-90ed-f37ee6d29c2f	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	4	61.85	65.76	54.6	hybrid fallback	2026-04-26 09:14:47.687
14b978dd-90c9-47a7-a544-f89d658b2008	65c085d5-2990-4825-90ed-f37ee6d29c2f	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	5	60.51	64.2	53.65	trust penalty	2026-04-26 09:14:47.687
d3a0c493-3fa0-418b-8bc9-ba4b95c13311	65c085d5-2990-4825-90ed-f37ee6d29c2f	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	6	59.67	63.64	52.3	hybrid fallback	2026-04-26 09:14:47.687
67af2894-5846-4196-8b19-72d1e8b9408c	65c085d5-2990-4825-90ed-f37ee6d29c2f	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	7	57.81	61.56	50.85	hybrid fallback	2026-04-26 09:14:47.687
fa9c90dc-aa29-4df0-a4e7-22adce242f18	65c085d5-2990-4825-90ed-f37ee6d29c2f	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	8	51.46	55.16	44.6	trust penalty	2026-04-26 09:14:47.687
f482890f-fdc0-40b9-9613-3a12a5ff39f8	4cdaec6a-832d-4546-a2a9-f1ec0c83f83c	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	1	69.89	74.06	62.15	hybrid fallback	2026-04-26 09:16:34.677
fc0ce862-ce53-46d4-b26f-81f4998e4cb2	4cdaec6a-832d-4546-a2a9-f1ec0c83f83c	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	2	68.62	75.04	56.7	hybrid fallback	2026-04-26 09:16:34.677
2718bfb4-6c17-4514-9324-1480caf3290a	4cdaec6a-832d-4546-a2a9-f1ec0c83f83c	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	3	65.95	69.86	58.7	hybrid fallback	2026-04-26 09:16:34.677
ac71f822-8165-4151-a4c3-45981dcb172d	4cdaec6a-832d-4546-a2a9-f1ec0c83f83c	cb288153-a8d4-4973-9435-75d98775f743	Apartment in Um Al Fahm	Um Al Fahm	140000	4	64.95	66	63	hybrid fallback	2026-04-26 09:16:34.677
eabf206d-10fa-4683-8195-fe307d73ea0f	4cdaec6a-832d-4546-a2a9-f1ec0c83f83c	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	5	61.85	65.76	54.6	hybrid fallback	2026-04-26 09:16:34.677
d9893689-8fd3-477c-9957-edbdf084d62e	4cdaec6a-832d-4546-a2a9-f1ec0c83f83c	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	6	60.51	64.2	53.65	trust penalty	2026-04-26 09:16:34.677
a3863733-6cbb-4e4e-8202-4498653ff0fd	4cdaec6a-832d-4546-a2a9-f1ec0c83f83c	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	7	59.67	63.64	52.3	hybrid fallback	2026-04-26 09:16:34.677
e7eb5dbc-5696-4d44-9d1b-f822dbaa7f81	4cdaec6a-832d-4546-a2a9-f1ec0c83f83c	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	8	57.81	61.56	50.85	hybrid fallback	2026-04-26 09:16:34.677
e7406c06-7656-49c0-a1b6-9ebedd136a4e	4cdaec6a-832d-4546-a2a9-f1ec0c83f83c	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	9	51.46	55.16	44.6	trust penalty	2026-04-26 09:16:34.677
428e3207-7dd2-4c14-b6b4-9ddc279a6cd6	cc641112-62d3-487c-b86f-0ca79ccf4a3c	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	1	69.89	74.06	62.15	hybrid fallback	2026-04-26 09:16:35.636
7ec0da12-e674-49c8-a4c0-4aeba951356a	cc641112-62d3-487c-b86f-0ca79ccf4a3c	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	2	68.62	75.04	56.7	hybrid fallback	2026-04-26 09:16:35.636
2ff43aaa-ed7f-4049-ac74-7349c1d4418d	cc641112-62d3-487c-b86f-0ca79ccf4a3c	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	3	65.95	69.86	58.7	hybrid fallback	2026-04-26 09:16:35.636
ca544006-5b3a-476f-ae6f-121d8efe46ab	cc641112-62d3-487c-b86f-0ca79ccf4a3c	cb288153-a8d4-4973-9435-75d98775f743	Apartment in Um Al Fahm	Um Al Fahm	140000	4	64.95	66	63	hybrid fallback	2026-04-26 09:16:35.636
8fd153e0-2676-4dc4-9c61-7fd30cbf19fa	cc641112-62d3-487c-b86f-0ca79ccf4a3c	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	5	61.85	65.76	54.6	hybrid fallback	2026-04-26 09:16:35.636
c0d979ed-d880-4863-bcd0-21957155b01a	cc641112-62d3-487c-b86f-0ca79ccf4a3c	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	6	60.51	64.2	53.65	trust penalty	2026-04-26 09:16:35.636
d0cfe97c-476a-4055-a43b-c2b80171bf90	cc641112-62d3-487c-b86f-0ca79ccf4a3c	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	7	59.67	63.64	52.3	hybrid fallback	2026-04-26 09:16:35.636
52d02b1d-cb72-453a-9325-00989c27c9e1	cc641112-62d3-487c-b86f-0ca79ccf4a3c	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	8	57.81	61.56	50.85	hybrid fallback	2026-04-26 09:16:35.636
e5388da1-4891-4755-9705-89faf52fd61f	cc641112-62d3-487c-b86f-0ca79ccf4a3c	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	9	51.46	55.16	44.6	trust penalty	2026-04-26 09:16:35.636
6ad79285-840d-4c49-bf41-01e23e6106f6	e92ee9c2-546e-4f7e-b239-9d9cffb30477	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	1	79.27	86.04	66.7	city preference	2026-04-26 09:18:26.992
a946265a-acb7-4352-9d67-4e453c97de23	e92ee9c2-546e-4f7e-b239-9d9cffb30477	36ffa8d9-dd90-414d-b257-db98e4a90f70	Apartment in Green	Tblisi	90000	2	70.3	71	69	hybrid fallback	2026-04-26 09:18:26.992
ab216cb5-390c-4212-8cea-496c4dc49d47	e92ee9c2-546e-4f7e-b239-9d9cffb30477	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	3	69.89	74.06	62.15	hybrid fallback	2026-04-26 09:18:26.992
777c6dba-5946-40fd-bd99-0e0c3bb95a79	e92ee9c2-546e-4f7e-b239-9d9cffb30477	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	4	65.95	69.86	58.7	hybrid fallback	2026-04-26 09:18:26.992
996829be-5756-4549-b0ae-4079fceefe48	e92ee9c2-546e-4f7e-b239-9d9cffb30477	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	5	65.86	69.2	59.65	trust penalty	2026-04-26 09:18:26.992
45c12380-bdd3-41ad-90ea-ec90e1b6fdae	e92ee9c2-546e-4f7e-b239-9d9cffb30477	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	6	63.67	67.64	56.3	hybrid fallback	2026-04-26 09:18:26.992
400c4e8d-a59b-491c-a1d2-a067ce6d25ea	e92ee9c2-546e-4f7e-b239-9d9cffb30477	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	7	61.85	65.76	54.6	hybrid fallback	2026-04-26 09:18:26.992
524403f7-3ddc-4078-accf-f5e2e9a2bd0b	e92ee9c2-546e-4f7e-b239-9d9cffb30477	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	8	57.81	61.56	50.85	hybrid fallback	2026-04-26 09:18:26.992
153c3c6a-d908-47ea-b3a5-7c6e4cfa8951	e92ee9c2-546e-4f7e-b239-9d9cffb30477	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	9	47.46	51.16	40.6	trust penalty	2026-04-26 09:18:26.992
4df0329c-8753-453d-a332-782757e13bf2	1ac01f16-4085-4168-a13a-f60ee036d2ba	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	1	83.27	90.04	70.7	city preference	2026-04-26 09:18:30.084
7e9dfc3e-e495-4a35-9dfd-c11d963aeb15	1ac01f16-4085-4168-a13a-f60ee036d2ba	c901de33-674a-444d-8892-259897e9e4a9	Modern property with strong potential	Tel Aviv	120000	2	70.15	76.8	57.8	hybrid fallback	2026-04-26 09:18:30.084
5de59777-f746-4735-8e3a-309b16452a34	1ac01f16-4085-4168-a13a-f60ee036d2ba	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	3	69.89	74.06	62.15	hybrid fallback	2026-04-26 09:18:30.084
7696e589-ff0e-44e5-b108-3573ff9389d3	1ac01f16-4085-4168-a13a-f60ee036d2ba	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	4	65.95	69.86	58.7	hybrid fallback	2026-04-26 09:18:30.084
c5bf5485-e4f6-4727-82f3-ed83287f2450	1ac01f16-4085-4168-a13a-f60ee036d2ba	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	5	65.86	69.2	59.65	trust penalty	2026-04-26 09:18:30.084
d9bb6318-676c-4300-872f-2f9754f6f854	1ac01f16-4085-4168-a13a-f60ee036d2ba	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	6	63.67	67.64	56.3	hybrid fallback	2026-04-26 09:18:30.084
c9caf968-f2bf-4d8d-80ca-22355b7e2ee8	1ac01f16-4085-4168-a13a-f60ee036d2ba	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	7	61.85	65.76	54.6	hybrid fallback	2026-04-26 09:18:30.084
c868bcbf-d542-4286-b73e-bcf337764876	1ac01f16-4085-4168-a13a-f60ee036d2ba	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	8	57.81	61.56	50.85	hybrid fallback	2026-04-26 09:18:30.084
51fd1a70-eba0-4654-8db0-b95aad72fc7b	1ac01f16-4085-4168-a13a-f60ee036d2ba	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	9	47.46	51.16	40.6	trust penalty	2026-04-26 09:18:30.084
9090b212-6f4d-4c83-a435-7cf08b140be5	31a0df73-e910-40b8-9052-d900f69e304b	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	1	83.27	90.04	70.7	city preference	2026-04-26 09:18:30.455
5238cdf7-0a13-462f-bc47-4fedbd44e2fc	31a0df73-e910-40b8-9052-d900f69e304b	c901de33-674a-444d-8892-259897e9e4a9	Modern property with strong potential	Tel Aviv	120000	2	70.15	76.8	57.8	hybrid fallback	2026-04-26 09:18:30.455
0c56df93-d232-4f97-9311-7a10bfec7511	31a0df73-e910-40b8-9052-d900f69e304b	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	3	69.89	74.06	62.15	hybrid fallback	2026-04-26 09:18:30.455
d8c2dad9-e7b4-421e-bf90-347f2237a44c	31a0df73-e910-40b8-9052-d900f69e304b	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	4	65.95	69.86	58.7	hybrid fallback	2026-04-26 09:18:30.455
db548a73-0046-42f8-a8e1-ce1f4e10f67e	31a0df73-e910-40b8-9052-d900f69e304b	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	5	65.86	69.2	59.65	trust penalty	2026-04-26 09:18:30.455
efc6957f-39e8-455e-8414-0cb262090e47	31a0df73-e910-40b8-9052-d900f69e304b	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	6	63.67	67.64	56.3	hybrid fallback	2026-04-26 09:18:30.455
714d8d7e-70eb-4ede-b667-625bd351acd0	31a0df73-e910-40b8-9052-d900f69e304b	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	7	61.85	65.76	54.6	hybrid fallback	2026-04-26 09:18:30.455
6d9cac5e-18e9-4955-9f1b-752682752daf	31a0df73-e910-40b8-9052-d900f69e304b	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	8	57.81	61.56	50.85	hybrid fallback	2026-04-26 09:18:30.455
adfef290-2fdc-4a66-9ecc-bf2ebd87fdcc	31a0df73-e910-40b8-9052-d900f69e304b	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	9	47.46	51.16	40.6	trust penalty	2026-04-26 09:18:30.455
7c38a5fa-69d4-44be-a6e0-d49f6e001ca0	bf08146a-6c62-4a56-b317-a89092cb67ef	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	1	79.27	86.04	66.7	city preference	2026-04-26 09:18:39.027
6d1baac3-b785-490c-bf3c-bc102088145d	bf08146a-6c62-4a56-b317-a89092cb67ef	36ffa8d9-dd90-414d-b257-db98e4a90f70	Apartment in Green	Tblisi	90000	2	70.3	71	69	hybrid fallback	2026-04-26 09:18:39.027
1c625636-3cb6-4b8f-8158-7f65cbd02d02	bf08146a-6c62-4a56-b317-a89092cb67ef	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	3	69.89	74.06	62.15	hybrid fallback	2026-04-26 09:18:39.027
a2615240-0d70-4a0c-b0c7-6abeddc73158	bf08146a-6c62-4a56-b317-a89092cb67ef	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	4	65.95	69.86	58.7	hybrid fallback	2026-04-26 09:18:39.027
5a892849-a665-42a8-8389-5b3f7ae1815a	bf08146a-6c62-4a56-b317-a89092cb67ef	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	5	65.86	69.2	59.65	trust penalty	2026-04-26 09:18:39.027
1685dff2-f9b9-4ba5-8a0e-d9a3b789a48a	bf08146a-6c62-4a56-b317-a89092cb67ef	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	6	63.67	67.64	56.3	hybrid fallback	2026-04-26 09:18:39.027
1795f331-eb9b-4933-8f65-1f1695f29c3b	bf08146a-6c62-4a56-b317-a89092cb67ef	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	7	61.85	65.76	54.6	hybrid fallback	2026-04-26 09:18:39.027
575ce46d-a343-45b6-9b7f-276ee52a1f11	bf08146a-6c62-4a56-b317-a89092cb67ef	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	8	57.81	61.56	50.85	hybrid fallback	2026-04-26 09:18:39.027
9b90ba44-897f-4522-8020-a25d57a82c96	bf08146a-6c62-4a56-b317-a89092cb67ef	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	9	47.46	51.16	40.6	trust penalty	2026-04-26 09:18:39.027
6640e657-8c37-4748-9d13-c4475009a084	13be373a-d676-436b-81f6-252532e34865	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	1	83.27	90.04	70.7	city preference	2026-04-26 09:19:30.065
f55a7135-5caf-486f-8396-a8da64e06275	13be373a-d676-436b-81f6-252532e34865	c901de33-674a-444d-8892-259897e9e4a9	Modern property with strong potential	Tel Aviv	120000	2	74.15	80.8	61.8	hybrid fallback	2026-04-26 09:19:30.065
2971bac0-1eb8-4914-a330-3cf982fdd1c7	13be373a-d676-436b-81f6-252532e34865	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	3	69.89	74.06	62.15	hybrid fallback	2026-04-26 09:19:30.065
52586e73-8426-4ea4-b11b-eebccea25636	13be373a-d676-436b-81f6-252532e34865	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	4	65.95	69.86	58.7	hybrid fallback	2026-04-26 09:19:30.065
9a800ba1-73cb-468c-80bf-bbf88eaa6363	13be373a-d676-436b-81f6-252532e34865	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	5	65.86	69.2	59.65	trust penalty	2026-04-26 09:19:30.065
67a8066f-326c-46ca-beef-0049c8c283da	13be373a-d676-436b-81f6-252532e34865	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	6	63.67	67.64	56.3	hybrid fallback	2026-04-26 09:19:30.065
18162b45-1952-4b92-b508-bb139e4826dc	13be373a-d676-436b-81f6-252532e34865	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	7	61.85	65.76	54.6	hybrid fallback	2026-04-26 09:19:30.065
938955aa-a99f-43ef-9fa5-45c469f126d4	13be373a-d676-436b-81f6-252532e34865	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	8	57.81	61.56	50.85	hybrid fallback	2026-04-26 09:19:30.065
0ec5b177-8337-4c51-ac4d-d28f48649a57	13be373a-d676-436b-81f6-252532e34865	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	9	47.46	51.16	40.6	trust penalty	2026-04-26 09:19:30.065
7208f510-6031-47ed-b513-e2f87f0861c6	9e1bdcbd-aaa1-42e0-a661-3bed478a7e84	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	1	83.27	90.04	70.7	city preference	2026-04-26 09:19:30.816
90744234-b806-4e5b-a1e2-e09ee35d7ca6	9e1bdcbd-aaa1-42e0-a661-3bed478a7e84	c901de33-674a-444d-8892-259897e9e4a9	Modern property with strong potential	Tel Aviv	120000	2	74.15	80.8	61.8	hybrid fallback	2026-04-26 09:19:30.816
031b4dba-1c69-4a27-9370-4ea1e4600309	9e1bdcbd-aaa1-42e0-a661-3bed478a7e84	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	3	69.89	74.06	62.15	hybrid fallback	2026-04-26 09:19:30.816
72134774-29bc-4aef-9008-3bbd0865a3d6	9e1bdcbd-aaa1-42e0-a661-3bed478a7e84	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	4	65.95	69.86	58.7	hybrid fallback	2026-04-26 09:19:30.816
72e68a8e-e10c-4110-aadf-3f8ce81f65b0	9e1bdcbd-aaa1-42e0-a661-3bed478a7e84	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	5	65.86	69.2	59.65	trust penalty	2026-04-26 09:19:30.816
7a018d4e-cd03-4cbc-acc2-ad1e647d50b5	9e1bdcbd-aaa1-42e0-a661-3bed478a7e84	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	6	63.67	67.64	56.3	hybrid fallback	2026-04-26 09:19:30.816
2a88e4f6-d4cc-4ac6-8357-453135781099	9e1bdcbd-aaa1-42e0-a661-3bed478a7e84	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	7	61.85	65.76	54.6	hybrid fallback	2026-04-26 09:19:30.816
515806bf-46e6-4ff1-9216-a5088aca196f	9e1bdcbd-aaa1-42e0-a661-3bed478a7e84	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	8	57.81	61.56	50.85	hybrid fallback	2026-04-26 09:19:30.816
05370781-374a-4e1a-8ede-c18df1047a5b	9e1bdcbd-aaa1-42e0-a661-3bed478a7e84	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	9	47.46	51.16	40.6	trust penalty	2026-04-26 09:19:30.816
9c569651-5735-4d84-8e0c-8effe7f1f20f	c471bff0-3aef-48b6-ac4e-131b1e6d9cae	c901de33-674a-444d-8892-259897e9e4a9	Modern property with strong potential	Tel Aviv	120000	1	55.5	61.8	47.8	hybrid fallback	2026-04-27 11:33:01.821
a1ecac85-7e85-4340-a41b-f16f96754281	c471bff0-3aef-48b6-ac4e-131b1e6d9cae	cb288153-a8d4-4973-9435-75d98775f743	Apartment in Um Al Fahm	Um Al Fahm	140000	2	52.32	50.98	53.95	hybrid fallback	2026-04-27 11:33:01.821
79f82663-69f9-4ff7-80d3-bee205a84cf3	c471bff0-3aef-48b6-ac4e-131b1e6d9cae	36ffa8d9-dd90-414d-b257-db98e4a90f70	Apartment in Green	Tblisi	90000	3	51.52	50.18	53.15	hybrid fallback	2026-04-27 11:33:01.821
b0c6fa76-6f4f-412c-ab8e-7a2395e05867	c471bff0-3aef-48b6-ac4e-131b1e6d9cae	7f8bd3c9-8044-4ac4-bce0-9934871cc100	Apartment in Green	Tbilisi	90000	4	51.52	50.18	53.15	hybrid fallback	2026-04-27 11:33:01.821
6beba04d-99c4-4cf0-997b-f462935f03ff	c471bff0-3aef-48b6-ac4e-131b1e6d9cae	959feec8-ec17-4e75-8d29-af4f57913c84	Apartment1 in Green	Tbilisi	70000	5	51.52	50.18	53.15	hybrid fallback	2026-04-27 11:33:01.821
af95dd9a-a0c0-4986-8f53-8d4b892c89ab	c471bff0-3aef-48b6-ac4e-131b1e6d9cae	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	6	51.4	54.06	48.15	hybrid fallback	2026-04-27 11:33:01.821
da461b7b-b88c-4996-97c1-ed3a5dd71925	c471bff0-3aef-48b6-ac4e-131b1e6d9cae	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	7	48.15	50.2	45.65	trust penalty	2026-04-27 11:33:01.821
933412a1-7cc4-460f-a3a8-6f3b4608c902	c471bff0-3aef-48b6-ac4e-131b1e6d9cae	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	8	48.04	54.04	40.7	hybrid fallback	2026-04-27 11:33:01.821
574ac824-0ab6-425b-9c17-aee9db20fb2e	c471bff0-3aef-48b6-ac4e-131b1e6d9cae	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	9	47.54	49.86	44.7	hybrid fallback	2026-04-27 11:33:01.821
9dc0d199-20b9-4951-b81b-0323eaf6e347	c471bff0-3aef-48b6-ac4e-131b1e6d9cae	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	10	45.24	47.64	42.3	hybrid fallback	2026-04-27 11:33:01.821
ea6a2872-3f92-413c-ae32-8a952394b72f	c471bff0-3aef-48b6-ac4e-131b1e6d9cae	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	11	43.44	45.56	40.85	hybrid fallback	2026-04-27 11:33:01.821
883709e4-3096-416b-a95f-404e4784b24d	bd22e583-4093-411a-ab61-aea95e9f15c9	c901de33-674a-444d-8892-259897e9e4a9	Modern property with strong potential	Tel Aviv	120000	1	55.5	61.8	47.8	hybrid fallback	2026-04-27 11:33:01.819
e6b45b4a-840a-4337-9fd5-82faca4362d0	bd22e583-4093-411a-ab61-aea95e9f15c9	cb288153-a8d4-4973-9435-75d98775f743	Apartment in Um Al Fahm	Um Al Fahm	140000	2	52.32	50.98	53.95	hybrid fallback	2026-04-27 11:33:01.819
9113e276-15a6-4188-bff8-c43164abf3b0	bd22e583-4093-411a-ab61-aea95e9f15c9	36ffa8d9-dd90-414d-b257-db98e4a90f70	Apartment in Green	Tblisi	90000	3	51.52	50.18	53.15	hybrid fallback	2026-04-27 11:33:01.819
46f2ef06-60d7-4334-b820-a404dbad4a5c	bd22e583-4093-411a-ab61-aea95e9f15c9	7f8bd3c9-8044-4ac4-bce0-9934871cc100	Apartment in Green	Tbilisi	90000	4	51.52	50.18	53.15	hybrid fallback	2026-04-27 11:33:01.819
df055336-dd28-4726-bf76-28e1714432ab	bd22e583-4093-411a-ab61-aea95e9f15c9	959feec8-ec17-4e75-8d29-af4f57913c84	Apartment1 in Green	Tbilisi	70000	5	51.52	50.18	53.15	hybrid fallback	2026-04-27 11:33:01.819
3b491f36-5678-4d3d-bfae-89d58dd1e3a6	bd22e583-4093-411a-ab61-aea95e9f15c9	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	6	51.4	54.06	48.15	hybrid fallback	2026-04-27 11:33:01.819
6263e229-b5ca-434f-ad6b-1f69eb9f623c	bd22e583-4093-411a-ab61-aea95e9f15c9	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	7	48.15	50.2	45.65	trust penalty	2026-04-27 11:33:01.819
23fdd3b7-d9c8-4860-bda6-02261f020d9d	bd22e583-4093-411a-ab61-aea95e9f15c9	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	8	48.04	54.04	40.7	hybrid fallback	2026-04-27 11:33:01.819
52791125-f123-4063-a237-672cba73e8ed	bd22e583-4093-411a-ab61-aea95e9f15c9	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	9	47.54	49.86	44.7	hybrid fallback	2026-04-27 11:33:01.819
2fc7e6c4-b558-4390-aefe-319cdd3c280e	bd22e583-4093-411a-ab61-aea95e9f15c9	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	10	45.24	47.64	42.3	hybrid fallback	2026-04-27 11:33:01.819
51eee0b5-e053-4a62-9f1f-857bb22ddc04	bd22e583-4093-411a-ab61-aea95e9f15c9	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	11	43.44	45.56	40.85	hybrid fallback	2026-04-27 11:33:01.819
ad85ee3f-aca9-45c7-b5b6-923c52fa20fa	bd22e583-4093-411a-ab61-aea95e9f15c9	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	12	43.44	45.76	40.6	hybrid fallback	2026-04-27 11:33:01.819
a0800f28-cbb8-4e71-8ba4-1bbbcd01fd59	bd22e583-4093-411a-ab61-aea95e9f15c9	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	13	33.11	35.16	30.6	trust penalty	2026-04-27 11:33:01.819
83e41fc1-1bb0-43b2-9632-19b15684b2dd	c471bff0-3aef-48b6-ac4e-131b1e6d9cae	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	12	43.44	45.76	40.6	hybrid fallback	2026-04-27 11:33:01.821
ba8fac0b-73b9-4452-9ec3-4738088f9747	c471bff0-3aef-48b6-ac4e-131b1e6d9cae	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	13	33.11	35.16	30.6	trust penalty	2026-04-27 11:33:01.821
796d06e9-0b20-4e6b-b4a5-79b1edac14ec	dda48ad9-530a-4811-a0d4-9b066aa2683f	c901de33-674a-444d-8892-259897e9e4a9	Modern property with strong potential	Tel Aviv	120000	1	61.8	61.8	61.8	ai fallback	2026-04-27 11:33:07.407
0c0d0aa1-af75-4e8b-aa30-d2e8cdada917	dda48ad9-530a-4811-a0d4-9b066aa2683f	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	2	54.06	54.06	54.06	ai fallback	2026-04-27 11:33:07.407
d9581110-7892-44c9-af62-e537d5330c70	dda48ad9-530a-4811-a0d4-9b066aa2683f	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	3	54.04	54.04	54.04	ai fallback	2026-04-27 11:33:07.407
107bb64f-c2bc-4b43-ab82-d5650eb84881	dda48ad9-530a-4811-a0d4-9b066aa2683f	cb288153-a8d4-4973-9435-75d98775f743	Apartment in Um Al Fahm	Um Al Fahm	140000	4	50.98	50.98	50.98	ai fallback	2026-04-27 11:33:07.407
c1878257-0937-4322-94d9-cf75885cb852	dda48ad9-530a-4811-a0d4-9b066aa2683f	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	5	50.2	50.2	50.2	ai fallback	2026-04-27 11:33:07.407
87a8be0a-f3ec-446d-8287-a82cfe55069a	dda48ad9-530a-4811-a0d4-9b066aa2683f	36ffa8d9-dd90-414d-b257-db98e4a90f70	Apartment in Green	Tblisi	90000	6	50.18	50.18	50.18	ai fallback	2026-04-27 11:33:07.407
660e606e-d604-46a8-8185-38b7bf236910	dda48ad9-530a-4811-a0d4-9b066aa2683f	7f8bd3c9-8044-4ac4-bce0-9934871cc100	Apartment in Green	Tbilisi	90000	7	50.18	50.18	50.18	ai fallback	2026-04-27 11:33:07.407
723969cd-921f-4b6d-8ce2-61da850b0727	dda48ad9-530a-4811-a0d4-9b066aa2683f	959feec8-ec17-4e75-8d29-af4f57913c84	Apartment1 in Green	Tbilisi	70000	8	50.18	50.18	50.18	ai fallback	2026-04-27 11:33:07.407
78a2ea2f-c22d-4f9e-8bd7-5538d3a11cab	dda48ad9-530a-4811-a0d4-9b066aa2683f	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	9	49.86	49.86	49.86	ai fallback	2026-04-27 11:33:07.407
dbe5998a-e2c9-45f8-b0ec-41529d162149	dda48ad9-530a-4811-a0d4-9b066aa2683f	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	10	47.64	47.64	47.64	ai fallback	2026-04-27 11:33:07.407
6373669a-3084-4350-9bbd-d9ec1e4a6cd8	dda48ad9-530a-4811-a0d4-9b066aa2683f	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	11	45.76	45.76	45.76	ai fallback	2026-04-27 11:33:07.407
2da5884c-790f-4577-aec4-efeb8cbb5b49	dda48ad9-530a-4811-a0d4-9b066aa2683f	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	12	45.56	45.56	45.56	ai fallback	2026-04-27 11:33:07.407
df0ad4eb-8d77-42e1-95b9-1d34faf7fd00	dda48ad9-530a-4811-a0d4-9b066aa2683f	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	13	35.16	35.16	35.16	ai fallback	2026-04-27 11:33:07.407
bc677d74-3119-44de-bcce-fcc410aadce0	1ba1cbe2-e6f4-40b6-a8dd-1dcbc77e81d8	c901de33-674a-444d-8892-259897e9e4a9	Modern property with strong potential	Tel Aviv	120000	1	61.8	61.8	61.8	ai fallback	2026-04-27 11:33:07.51
066728a0-ae1f-486a-ab76-2eef8171ccd0	1ba1cbe2-e6f4-40b6-a8dd-1dcbc77e81d8	d3f575e9-3959-4945-adf2-cbadbf53f2e0	Home	Haifa	150000	2	54.06	54.06	54.06	ai fallback	2026-04-27 11:33:07.51
cf27d149-c245-4d19-be21-18fb7ca4750a	1ba1cbe2-e6f4-40b6-a8dd-1dcbc77e81d8	9cc14069-c507-44df-900b-3833cea37ead	Modern property with strong potential	Um Al Fahm	80000	3	54.04	54.04	54.04	ai fallback	2026-04-27 11:33:07.51
e39099d4-a77e-4ade-a6f0-63bb6cf2f8dd	1ba1cbe2-e6f4-40b6-a8dd-1dcbc77e81d8	cb288153-a8d4-4973-9435-75d98775f743	Apartment in Um Al Fahm	Um Al Fahm	140000	4	50.98	50.98	50.98	ai fallback	2026-04-27 11:33:07.51
86a2fad3-9313-4f36-8e36-8402086f97a9	1ba1cbe2-e6f4-40b6-a8dd-1dcbc77e81d8	de47b7a3-b7f4-4016-bbb1-b154988ab7e1	Modern property with strong potential	Tel Aviv	110000	5	50.2	50.2	50.2	ai fallback	2026-04-27 11:33:07.51
8a18d29b-f8b8-4bd9-a32e-1f61653587ca	1ba1cbe2-e6f4-40b6-a8dd-1dcbc77e81d8	36ffa8d9-dd90-414d-b257-db98e4a90f70	Apartment in Green	Tblisi	90000	6	50.18	50.18	50.18	ai fallback	2026-04-27 11:33:07.51
4270b5be-6438-48aa-b519-82999ecd9c0f	1ba1cbe2-e6f4-40b6-a8dd-1dcbc77e81d8	7f8bd3c9-8044-4ac4-bce0-9934871cc100	Apartment in Green	Tbilisi	90000	7	50.18	50.18	50.18	ai fallback	2026-04-27 11:33:07.51
2d8fb60e-7a94-4af2-8337-28a79b4ff37d	1ba1cbe2-e6f4-40b6-a8dd-1dcbc77e81d8	959feec8-ec17-4e75-8d29-af4f57913c84	Apartment1 in Green	Tbilisi	70000	8	50.18	50.18	50.18	ai fallback	2026-04-27 11:33:07.51
e1d33b02-0186-45fe-95bf-0ff2befc2a78	1ba1cbe2-e6f4-40b6-a8dd-1dcbc77e81d8	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	9	49.86	49.86	49.86	ai fallback	2026-04-27 11:33:07.51
efd4bc8d-2ca8-48cb-a451-90fe5570ec51	1ba1cbe2-e6f4-40b6-a8dd-1dcbc77e81d8	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	10	47.64	47.64	47.64	ai fallback	2026-04-27 11:33:07.51
97fcec9e-dd70-4b2a-8d1f-b996d9a1d6cb	1ba1cbe2-e6f4-40b6-a8dd-1dcbc77e81d8	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	11	45.76	45.76	45.76	ai fallback	2026-04-27 11:33:07.51
27d495d7-97ab-40a6-a557-9c65aa98f372	1ba1cbe2-e6f4-40b6-a8dd-1dcbc77e81d8	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	12	45.56	45.56	45.56	ai fallback	2026-04-27 11:33:07.51
f7722b73-8f79-4664-8e96-687881235f8c	1ba1cbe2-e6f4-40b6-a8dd-1dcbc77e81d8	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	13	35.16	35.16	35.16	ai fallback	2026-04-27 11:33:07.51
d8bfd120-ad65-48cd-921e-e9260b766c15	6c293be2-5e68-4df2-9a81-015fc88ef4f4	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	1	76.6	80.86	68.7	city preference	2026-04-27 11:33:32.264
7337557d-8690-4b79-a482-0bec15d0ec50	6c293be2-5e68-4df2-9a81-015fc88ef4f4	36ffa8d9-dd90-414d-b257-db98e4a90f70	Apartment in Green	Tblisi	90000	2	74.47	75.18	73.15	hybrid fallback	2026-04-27 11:33:32.264
4ce0437d-6e69-40d6-92ff-4dca05617fa2	6c293be2-5e68-4df2-9a81-015fc88ef4f4	7f8bd3c9-8044-4ac4-bce0-9934871cc100	Apartment in Green	Tbilisi	90000	3	74.47	75.18	73.15	hybrid fallback	2026-04-27 11:33:32.264
ab76a6f2-28d9-4a8a-83d6-86204d0ebcaa	6c293be2-5e68-4df2-9a81-015fc88ef4f4	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	4	74.32	78.64	66.3	city preference	2026-04-27 11:33:32.264
57bc84a1-3280-4b45-829f-bc96fef133b4	6c293be2-5e68-4df2-9a81-015fc88ef4f4	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	5	68.46	72.56	60.85	city preference	2026-04-27 11:33:32.264
7bb6a8c2-8895-4a2f-ad65-14cc219cb4bd	6c293be2-5e68-4df2-9a81-015fc88ef4f4	959feec8-ec17-4e75-8d29-af4f57913c84	Apartment1 in Green	Tbilisi	70000	6	65.12	66.18	63.15	hybrid fallback	2026-04-27 11:33:32.264
7b306461-ba91-4fa3-8b4c-4ff0db150e96	6c293be2-5e68-4df2-9a81-015fc88ef4f4	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	7	61.85	65.76	54.6	hybrid fallback	2026-04-27 11:33:32.264
7053549d-45dd-45dc-b1de-58639ec6b755	6c293be2-5e68-4df2-9a81-015fc88ef4f4	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	8	47.46	51.16	40.6	trust penalty	2026-04-27 11:33:32.264
ca31bb4a-9b66-402b-adc1-87bd31e70b16	1436282b-5169-48b2-a81a-2d39832da405	51da0eb6-5ea0-47c6-9388-7f9a9a85d3f7	home1	Tel Aviv	5000	1	76.6	80.86	68.7	city preference	2026-04-27 11:33:32.889
61a20e35-d5ab-4f98-8e87-246684ff67bf	1436282b-5169-48b2-a81a-2d39832da405	36ffa8d9-dd90-414d-b257-db98e4a90f70	Apartment in Green	Tblisi	90000	2	74.47	75.18	73.15	hybrid fallback	2026-04-27 11:33:32.889
28d745a8-1f33-4b6c-9ecf-0cfba310d89f	1436282b-5169-48b2-a81a-2d39832da405	7f8bd3c9-8044-4ac4-bce0-9934871cc100	Apartment in Green	Tbilisi	90000	3	74.47	75.18	73.15	hybrid fallback	2026-04-27 11:33:32.889
9f3fdff3-92e9-471b-bf83-d717c94c51f2	1436282b-5169-48b2-a81a-2d39832da405	51b8a6d1-6450-49a4-b961-3d9bfe465770	Codex Test Listing	Haifa	7777	4	74.32	78.64	66.3	city preference	2026-04-27 11:33:32.889
a9b2e26b-ffb1-4dfe-8e54-6416ff08c930	1436282b-5169-48b2-a81a-2d39832da405	9cd6f7ba-e28a-456c-8ad6-3edce35a4543	HH	Haifa	400	5	68.46	72.56	60.85	city preference	2026-04-27 11:33:32.889
d20ea2b8-d490-4f7a-85ca-740883eee133	1436282b-5169-48b2-a81a-2d39832da405	959feec8-ec17-4e75-8d29-af4f57913c84	Apartment1 in Green	Tbilisi	70000	6	65.12	66.18	63.15	hybrid fallback	2026-04-27 11:33:32.889
e2065eb0-a67b-4bf5-8d0f-739d1f4f0e0d	1436282b-5169-48b2-a81a-2d39832da405	c161f02d-7d64-47bd-8412-424d48166b15	homee	um al fahm	6000	7	61.85	65.76	54.6	hybrid fallback	2026-04-27 11:33:32.889
667cd35e-eba8-42bb-9074-5c41014530cb	1436282b-5169-48b2-a81a-2d39832da405	41367728-e8a5-4232-8a08-520075bc6859	Home1	um al fahm 	6600	8	47.46	51.16	40.6	trust penalty	2026-04-27 11:33:32.889
\.


--
-- Data for Name: RankingFeedback; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."RankingFeedback" (id, "decisionItemId", "actorUserId", quality, relevance, "reviewerNote", "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: SavedSearch; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."SavedSearch" (id, "userId", name, "filtersJson", "createdAt", "updatedAt") FROM stdin;
0df360de-4e69-45bc-9e1d-3b09396dccc1	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	Saved search2	{"sort": "price_low", "rooms": "2", "maxArea": "200", "minArea": "70", "maxPrice": "200000", "minPrice": "60000", "bathrooms": "1"}	2026-04-21 13:29:18.246	2026-04-21 13:29:18.246
134f606d-c9c4-4e33-afb8-45dd57b1a237	b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	Saved search3	{"mode": "RENT", "sort": "price_high", "type": "APARTMENT", "rooms": "3", "maxArea": "300", "minArea": "50", "maxPrice": "200000", "minPrice": "1000", "bathrooms": "2"}	2026-04-24 07:43:40.846	2026-04-24 07:43:40.846
\.


--
-- Data for Name: SearchOverride; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."SearchOverride" (id, query, "normalizedQuery", "rewrittenQuery", "filtersJson", note, active, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: SearchSynonym; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."SearchSynonym" (id, term, synonym, "createdAt", "updatedAt") FROM stdin;
\.


--
-- Data for Name: SystemSetting; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."SystemSetting" (key, "valueJson", "updatedAt") FROM stdin;
\.


--
-- Data for Name: User; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public."User" (id, name, email, phone, "createdAt", "isVerified", "passwordHash", "updatedAt", role, plan, "planExpiresAt") FROM stdin;
d6574ca5-8f39-4a24-8dcd-fef4a7ef8419	UserTest	UserTest@gmail.com	\N	2026-04-08 01:36:34.987	f		1969-12-31 22:00:00	USER	FREE	\N
f9fee17a-b0fa-4ce8-b811-3050b051ca94	Ayham	ayham969@gmail.com	0524868993	2026-04-08 11:37:21.08	f	$2b$10$t.yQHrmG85LXiIKM7D69r.NEBG8BsqFF2lxa3K2HNMKLBPBAkXMXy	2026-04-08 11:37:21.08	USER	FREE	\N
f4ce3817-ad27-471d-9dac-20d07a0d1d0d	Ayham1	ayham1@gmail.com	0524868991	2026-04-08 17:06:22.52	f	$2b$10$/ixR.42kUgUPmG2wncJYQuIrrb8DspzuTysDDd8CHtR3upSaQQlaa	2026-04-08 17:06:22.52	USER	FREE	\N
12b2ba74-e9e3-44a8-be7c-67a8131e4f6d	Codex Fix	codex.fix.1775771852@example.com	0500000000	2026-04-09 21:57:33.387	f	$2b$10$6uNMArcdhPcrTWtLn7lAXOgtzVzQBEQKQZlSw6R3mXmB.T0Q48Vpq	2026-04-09 21:57:33.387	USER	FREE	\N
2464ed65-9c3e-4bf6-981a-c1dafe9c25a0	Codex Favorite	codex.favorite.1775771880@example.com	0500000003	2026-04-09 21:58:01.128	f	$2b$10$0sMWQAw4kn32W1J.H5ZK4e.tmduknpMO2fxVlddnD/dS5YB8bG3wi	2026-04-09 21:58:01.128	USER	FREE	\N
c53a3395-736b-4817-85b0-1b3d2b8dce8c	Codex Flow	codex.flow.1775771880@example.com	0500000001	2026-04-09 21:58:01.358	f	$2b$10$hbi9e41lAy/PDUQqtFfyjuLnxJnfAE6jRJ4Xhk9ePqtTVRtv9E.4i	2026-04-09 21:58:01.358	USER	FREE	\N
95a440b2-4b1c-4a8a-afdc-319e6fd4482e	Codex Listing	codex.listing.1775771880@example.com	0500000002	2026-04-09 21:58:01.392	f	$2b$10$deuYCBS7JmDLrq3yBXJDUuEnlaIf/fXzeetd/YdaOOLmUdILZcYXu	2026-04-09 21:58:01.392	USER	FREE	\N
e4a9b138-1c18-42e0-9d80-b8ec65c09989	Ayham3	ayham3@gmail.com	0524868992	2026-04-09 22:04:10.824	f	$2b$10$A4B9NEMq2cxYJg1BG56Rge9MtMCLVJADG2jMKTwbfPHdLorgFQ7.e	2026-04-09 22:04:10.824	USER	FREE	\N
74539c7a-05f2-43e5-a21b-21123db30f2c	Ayham11	ayham511@gmail.com	0504868229	2026-04-10 11:06:23.749	f	$2b$10$VtOLQj/7.ktIEvecOdIw6.uO86vhx8KIl7EYdkrweVRlUZr1HWN/.	2026-04-10 11:06:23.749	USER	FREE	\N
b375ad6a-cb3e-4dd8-b1e5-64609aa4b73c	Ayham Mhameed	ayham9659@gmail.com	0524868992	2026-04-08 11:35:38.66	f	$2b$10$ikk3TtAklyzoDi2HwgXie.55oDvjlyxp7lMpb2o/kfPwkieZ3kfOu	2026-04-22 23:48:22.48	ADMIN	PREMIUM	2026-05-22 23:48:22.479
f0ce40f7-e29c-4791-8928-fb1bcdf6c85f	Ayham8	ayham8@gmail.com	0524868777	2026-04-22 23:58:01.017	f	$2b$10$oMQtTIlfzUA7N4EHH2byueUqTTnt0vILqohVuwsUBQB97fn6k62xi	2026-04-22 23:58:34.528	USER	AGENT	2026-05-22 23:58:34.527
0863bc3f-a7c7-464c-9737-1f49ec6d6a65	Ayham6	ayham6@gmail.com	0524868227	2026-04-14 00:16:13.739	f	$2b$10$MFkKntcD1YOKADoxK5P3F.emfatGUzy3pVmrI75wQREdyTWbJv5lO	2026-04-23 15:39:18.658	USER	PREMIUM	2026-05-22 23:56:02.585
056ecb9e-1460-42b0-b22e-bf5d2ad5c6b4	ayham22	ayham22@gmail.com	0524868222	2026-04-24 07:46:34.995	f	$2b$10$sWVIEUwhpZt8TX37tEXwqekz8cS.qwRUnp8gj2bGw6UV.jaI9qFr.	2026-04-25 21:08:35.839	USER	AGENT	2026-05-25 21:08:35.835
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
653e44fe-4be0-4e1f-9a20-d42f1c25a82f	91f7f6375cbb9782e16fdbef0cc13f51cc5afa37dbdd6aa451c2a3bcdbb09cf8	2026-04-08 00:35:02.561217+00	20260406182820_init	\N	\N	2026-04-08 00:35:02.438453+00	1
\.


--
-- Name: AiFeedback AiFeedback_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."AiFeedback"
    ADD CONSTRAINT "AiFeedback_pkey" PRIMARY KEY (id);


--
-- Name: AiRequestLog AiRequestLog_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."AiRequestLog"
    ADD CONSTRAINT "AiRequestLog_pkey" PRIMARY KEY (id);


--
-- Name: AuditLog AuditLog_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."AuditLog"
    ADD CONSTRAINT "AuditLog_pkey" PRIMARY KEY (id);


--
-- Name: Conversation Conversation_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Conversation"
    ADD CONSTRAINT "Conversation_pkey" PRIMARY KEY (id);


--
-- Name: EmailLog EmailLog_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."EmailLog"
    ADD CONSTRAINT "EmailLog_pkey" PRIMARY KEY (id);


--
-- Name: Event Event_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Event"
    ADD CONSTRAINT "Event_pkey" PRIMARY KEY (id);


--
-- Name: Experiment Experiment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Experiment"
    ADD CONSTRAINT "Experiment_pkey" PRIMARY KEY (key);


--
-- Name: Favorite Favorite_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Favorite"
    ADD CONSTRAINT "Favorite_pkey" PRIMARY KEY (id);


--
-- Name: Lead Lead_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Lead"
    ADD CONSTRAINT "Lead_pkey" PRIMARY KEY (id);


--
-- Name: ListingImage ListingImage_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ListingImage"
    ADD CONSTRAINT "ListingImage_pkey" PRIMARY KEY (id);


--
-- Name: ListingReport ListingReport_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ListingReport"
    ADD CONSTRAINT "ListingReport_pkey" PRIMARY KEY (id);


--
-- Name: ListingView ListingView_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ListingView"
    ADD CONSTRAINT "ListingView_pkey" PRIMARY KEY (id);


--
-- Name: Listing Listing_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Listing"
    ADD CONSTRAINT "Listing_pkey" PRIMARY KEY (id);


--
-- Name: Message Message_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_pkey" PRIMARY KEY (id);


--
-- Name: Notification Notification_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Notification"
    ADD CONSTRAINT "Notification_pkey" PRIMARY KEY (id);


--
-- Name: OwnerRating OwnerRating_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."OwnerRating"
    ADD CONSTRAINT "OwnerRating_pkey" PRIMARY KEY (id);


--
-- Name: PasswordResetToken PasswordResetToken_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PasswordResetToken"
    ADD CONSTRAINT "PasswordResetToken_pkey" PRIMARY KEY (id);


--
-- Name: Payment Payment_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Payment"
    ADD CONSTRAINT "Payment_pkey" PRIMARY KEY (id);


--
-- Name: RankingDecisionItem RankingDecisionItem_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."RankingDecisionItem"
    ADD CONSTRAINT "RankingDecisionItem_pkey" PRIMARY KEY (id);


--
-- Name: RankingDecision RankingDecision_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."RankingDecision"
    ADD CONSTRAINT "RankingDecision_pkey" PRIMARY KEY (id);


--
-- Name: RankingFeedback RankingFeedback_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."RankingFeedback"
    ADD CONSTRAINT "RankingFeedback_pkey" PRIMARY KEY (id);


--
-- Name: SavedSearch SavedSearch_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SavedSearch"
    ADD CONSTRAINT "SavedSearch_pkey" PRIMARY KEY (id);


--
-- Name: SearchOverride SearchOverride_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SearchOverride"
    ADD CONSTRAINT "SearchOverride_pkey" PRIMARY KEY (id);


--
-- Name: SearchSynonym SearchSynonym_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SearchSynonym"
    ADD CONSTRAINT "SearchSynonym_pkey" PRIMARY KEY (id);


--
-- Name: SystemSetting SystemSetting_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SystemSetting"
    ADD CONSTRAINT "SystemSetting_pkey" PRIMARY KEY (key);


--
-- Name: User User_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."User"
    ADD CONSTRAINT "User_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: AiFeedback_actorUserId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "AiFeedback_actorUserId_idx" ON public."AiFeedback" USING btree ("actorUserId");


--
-- Name: AiFeedback_approval_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "AiFeedback_approval_idx" ON public."AiFeedback" USING btree (approval);


--
-- Name: AiFeedback_correctness_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "AiFeedback_correctness_idx" ON public."AiFeedback" USING btree (correctness);


--
-- Name: AiFeedback_endpoint_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "AiFeedback_endpoint_idx" ON public."AiFeedback" USING btree (endpoint);


--
-- Name: AiFeedback_requestLogId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "AiFeedback_requestLogId_key" ON public."AiFeedback" USING btree ("requestLogId");


--
-- Name: AiFeedback_updatedAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "AiFeedback_updatedAt_idx" ON public."AiFeedback" USING btree ("updatedAt");


--
-- Name: AiFeedback_usefulness_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "AiFeedback_usefulness_idx" ON public."AiFeedback" USING btree (usefulness);


--
-- Name: AiRequestLog_cacheHit_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "AiRequestLog_cacheHit_idx" ON public."AiRequestLog" USING btree ("cacheHit");


--
-- Name: AiRequestLog_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "AiRequestLog_createdAt_idx" ON public."AiRequestLog" USING btree ("createdAt");


--
-- Name: AiRequestLog_endpoint_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "AiRequestLog_endpoint_idx" ON public."AiRequestLog" USING btree (endpoint);


--
-- Name: AiRequestLog_fallbackUsed_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "AiRequestLog_fallbackUsed_idx" ON public."AiRequestLog" USING btree ("fallbackUsed");


--
-- Name: AiRequestLog_success_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "AiRequestLog_success_idx" ON public."AiRequestLog" USING btree (success);


--
-- Name: AuditLog_action_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "AuditLog_action_idx" ON public."AuditLog" USING btree (action);


--
-- Name: AuditLog_actorUserId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "AuditLog_actorUserId_idx" ON public."AuditLog" USING btree ("actorUserId");


--
-- Name: AuditLog_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "AuditLog_createdAt_idx" ON public."AuditLog" USING btree ("createdAt");


--
-- Name: AuditLog_targetId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "AuditLog_targetId_idx" ON public."AuditLog" USING btree ("targetId");


--
-- Name: AuditLog_targetType_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "AuditLog_targetType_idx" ON public."AuditLog" USING btree ("targetType");


--
-- Name: Conversation_buyerUserId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Conversation_buyerUserId_idx" ON public."Conversation" USING btree ("buyerUserId");


--
-- Name: Conversation_lastMessageAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Conversation_lastMessageAt_idx" ON public."Conversation" USING btree ("lastMessageAt");


--
-- Name: Conversation_listingId_buyerUserId_ownerUserId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Conversation_listingId_buyerUserId_ownerUserId_key" ON public."Conversation" USING btree ("listingId", "buyerUserId", "ownerUserId");


--
-- Name: Conversation_listingId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Conversation_listingId_idx" ON public."Conversation" USING btree ("listingId");


--
-- Name: Conversation_ownerUserId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Conversation_ownerUserId_idx" ON public."Conversation" USING btree ("ownerUserId");


--
-- Name: EmailLog_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "EmailLog_createdAt_idx" ON public."EmailLog" USING btree ("createdAt");


--
-- Name: EmailLog_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "EmailLog_status_idx" ON public."EmailLog" USING btree (status);


--
-- Name: EmailLog_type_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "EmailLog_type_idx" ON public."EmailLog" USING btree (type);


--
-- Name: EmailLog_userId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "EmailLog_userId_idx" ON public."EmailLog" USING btree ("userId");


--
-- Name: Event_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Event_createdAt_idx" ON public."Event" USING btree ("createdAt");


--
-- Name: Event_entityId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Event_entityId_idx" ON public."Event" USING btree ("entityId");


--
-- Name: Event_entityType_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Event_entityType_idx" ON public."Event" USING btree ("entityType");


--
-- Name: Event_sessionId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Event_sessionId_idx" ON public."Event" USING btree ("sessionId");


--
-- Name: Event_type_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Event_type_idx" ON public."Event" USING btree (type);


--
-- Name: Event_userId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Event_userId_idx" ON public."Event" USING btree ("userId");


--
-- Name: Experiment_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Experiment_status_idx" ON public."Experiment" USING btree (status);


--
-- Name: Experiment_updatedAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Experiment_updatedAt_idx" ON public."Experiment" USING btree ("updatedAt");


--
-- Name: Favorite_userId_listingId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Favorite_userId_listingId_key" ON public."Favorite" USING btree ("userId", "listingId");


--
-- Name: Lead_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Lead_createdAt_idx" ON public."Lead" USING btree ("createdAt");


--
-- Name: Lead_listingId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Lead_listingId_idx" ON public."Lead" USING btree ("listingId");


--
-- Name: Lead_ownerUserId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Lead_ownerUserId_idx" ON public."Lead" USING btree ("ownerUserId");


--
-- Name: Lead_senderUserId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Lead_senderUserId_idx" ON public."Lead" USING btree ("senderUserId");


--
-- Name: Lead_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Lead_status_idx" ON public."Lead" USING btree (status);


--
-- Name: ListingImage_listingId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "ListingImage_listingId_idx" ON public."ListingImage" USING btree ("listingId");


--
-- Name: ListingReport_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "ListingReport_createdAt_idx" ON public."ListingReport" USING btree ("createdAt");


--
-- Name: ListingReport_listingId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "ListingReport_listingId_idx" ON public."ListingReport" USING btree ("listingId");


--
-- Name: ListingReport_reason_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "ListingReport_reason_idx" ON public."ListingReport" USING btree (reason);


--
-- Name: ListingReport_reviewStatus_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "ListingReport_reviewStatus_idx" ON public."ListingReport" USING btree ("reviewStatus");


--
-- Name: ListingReport_sessionId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "ListingReport_sessionId_idx" ON public."ListingReport" USING btree ("sessionId");


--
-- Name: ListingReport_userId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "ListingReport_userId_idx" ON public."ListingReport" USING btree ("userId");


--
-- Name: ListingView_listingId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "ListingView_listingId_idx" ON public."ListingView" USING btree ("listingId");


--
-- Name: ListingView_userId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "ListingView_userId_idx" ON public."ListingView" USING btree ("userId");


--
-- Name: ListingView_viewedAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "ListingView_viewedAt_idx" ON public."ListingView" USING btree ("viewedAt");


--
-- Name: Listing_boostedUntil_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Listing_boostedUntil_idx" ON public."Listing" USING btree ("boostedUntil");


--
-- Name: Listing_city_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Listing_city_idx" ON public."Listing" USING btree (city);


--
-- Name: Listing_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Listing_createdAt_idx" ON public."Listing" USING btree ("createdAt");


--
-- Name: Listing_createdById_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Listing_createdById_idx" ON public."Listing" USING btree ("createdById");


--
-- Name: Listing_featuredUntil_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Listing_featuredUntil_idx" ON public."Listing" USING btree ("featuredUntil");


--
-- Name: Listing_latitude_longitude_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Listing_latitude_longitude_idx" ON public."Listing" USING btree (latitude, longitude);


--
-- Name: Listing_mode_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Listing_mode_idx" ON public."Listing" USING btree (mode);


--
-- Name: Listing_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Listing_status_idx" ON public."Listing" USING btree (status);


--
-- Name: Listing_type_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Listing_type_idx" ON public."Listing" USING btree (type);


--
-- Name: Message_conversationId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Message_conversationId_idx" ON public."Message" USING btree ("conversationId");


--
-- Name: Message_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Message_createdAt_idx" ON public."Message" USING btree ("createdAt");


--
-- Name: Message_readAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Message_readAt_idx" ON public."Message" USING btree ("readAt");


--
-- Name: Message_recipientUserId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Message_recipientUserId_idx" ON public."Message" USING btree ("recipientUserId");


--
-- Name: Message_senderUserId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Message_senderUserId_idx" ON public."Message" USING btree ("senderUserId");


--
-- Name: Notification_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Notification_createdAt_idx" ON public."Notification" USING btree ("createdAt");


--
-- Name: Notification_dedupeKey_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "Notification_dedupeKey_key" ON public."Notification" USING btree ("dedupeKey");


--
-- Name: Notification_readAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Notification_readAt_idx" ON public."Notification" USING btree ("readAt");


--
-- Name: Notification_type_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Notification_type_idx" ON public."Notification" USING btree (type);


--
-- Name: Notification_userId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Notification_userId_idx" ON public."Notification" USING btree ("userId");


--
-- Name: OwnerRating_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "OwnerRating_createdAt_idx" ON public."OwnerRating" USING btree ("createdAt");


--
-- Name: OwnerRating_listingId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "OwnerRating_listingId_idx" ON public."OwnerRating" USING btree ("listingId");


--
-- Name: OwnerRating_ownerUserId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "OwnerRating_ownerUserId_idx" ON public."OwnerRating" USING btree ("ownerUserId");


--
-- Name: OwnerRating_ownerUserId_raterUserId_listingId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "OwnerRating_ownerUserId_raterUserId_listingId_key" ON public."OwnerRating" USING btree ("ownerUserId", "raterUserId", "listingId");


--
-- Name: OwnerRating_raterUserId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "OwnerRating_raterUserId_idx" ON public."OwnerRating" USING btree ("raterUserId");


--
-- Name: OwnerRating_score_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "OwnerRating_score_idx" ON public."OwnerRating" USING btree (score);


--
-- Name: PasswordResetToken_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "PasswordResetToken_createdAt_idx" ON public."PasswordResetToken" USING btree ("createdAt");


--
-- Name: PasswordResetToken_expiresAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "PasswordResetToken_expiresAt_idx" ON public."PasswordResetToken" USING btree ("expiresAt");


--
-- Name: PasswordResetToken_tokenHash_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "PasswordResetToken_tokenHash_key" ON public."PasswordResetToken" USING btree ("tokenHash");


--
-- Name: PasswordResetToken_usedAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "PasswordResetToken_usedAt_idx" ON public."PasswordResetToken" USING btree ("usedAt");


--
-- Name: PasswordResetToken_userId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "PasswordResetToken_userId_idx" ON public."PasswordResetToken" USING btree ("userId");


--
-- Name: Payment_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Payment_createdAt_idx" ON public."Payment" USING btree ("createdAt");


--
-- Name: Payment_listingId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Payment_listingId_idx" ON public."Payment" USING btree ("listingId");


--
-- Name: Payment_purpose_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Payment_purpose_idx" ON public."Payment" USING btree (purpose);


--
-- Name: Payment_status_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Payment_status_idx" ON public."Payment" USING btree (status);


--
-- Name: Payment_userId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "Payment_userId_idx" ON public."Payment" USING btree ("userId");


--
-- Name: RankingDecisionItem_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "RankingDecisionItem_createdAt_idx" ON public."RankingDecisionItem" USING btree ("createdAt");


--
-- Name: RankingDecisionItem_decisionId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "RankingDecisionItem_decisionId_idx" ON public."RankingDecisionItem" USING btree ("decisionId");


--
-- Name: RankingDecisionItem_listingId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "RankingDecisionItem_listingId_idx" ON public."RankingDecisionItem" USING btree ("listingId");


--
-- Name: RankingDecisionItem_rank_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "RankingDecisionItem_rank_idx" ON public."RankingDecisionItem" USING btree (rank);


--
-- Name: RankingDecisionItem_score_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "RankingDecisionItem_score_idx" ON public."RankingDecisionItem" USING btree (score);


--
-- Name: RankingDecision_createdAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "RankingDecision_createdAt_idx" ON public."RankingDecision" USING btree ("createdAt");


--
-- Name: RankingDecision_objective_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "RankingDecision_objective_idx" ON public."RankingDecision" USING btree (objective);


--
-- Name: RankingDecision_strategy_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "RankingDecision_strategy_idx" ON public."RankingDecision" USING btree (strategy);


--
-- Name: RankingFeedback_actorUserId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "RankingFeedback_actorUserId_idx" ON public."RankingFeedback" USING btree ("actorUserId");


--
-- Name: RankingFeedback_decisionItemId_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "RankingFeedback_decisionItemId_key" ON public."RankingFeedback" USING btree ("decisionItemId");


--
-- Name: RankingFeedback_quality_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "RankingFeedback_quality_idx" ON public."RankingFeedback" USING btree (quality);


--
-- Name: RankingFeedback_relevance_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "RankingFeedback_relevance_idx" ON public."RankingFeedback" USING btree (relevance);


--
-- Name: RankingFeedback_updatedAt_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "RankingFeedback_updatedAt_idx" ON public."RankingFeedback" USING btree ("updatedAt");


--
-- Name: SavedSearch_userId_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "SavedSearch_userId_idx" ON public."SavedSearch" USING btree ("userId");


--
-- Name: SearchOverride_active_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "SearchOverride_active_idx" ON public."SearchOverride" USING btree (active);


--
-- Name: SearchOverride_normalizedQuery_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "SearchOverride_normalizedQuery_key" ON public."SearchOverride" USING btree ("normalizedQuery");


--
-- Name: SearchOverride_query_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "SearchOverride_query_idx" ON public."SearchOverride" USING btree (query);


--
-- Name: SearchSynonym_synonym_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "SearchSynonym_synonym_idx" ON public."SearchSynonym" USING btree (synonym);


--
-- Name: SearchSynonym_term_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX "SearchSynonym_term_idx" ON public."SearchSynonym" USING btree (term);


--
-- Name: SearchSynonym_term_synonym_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "SearchSynonym_term_synonym_key" ON public."SearchSynonym" USING btree (term, synonym);


--
-- Name: User_email_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX "User_email_key" ON public."User" USING btree (email);


--
-- Name: AiFeedback AiFeedback_requestLogId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."AiFeedback"
    ADD CONSTRAINT "AiFeedback_requestLogId_fkey" FOREIGN KEY ("requestLogId") REFERENCES public."AiRequestLog"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Conversation Conversation_buyerUserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Conversation"
    ADD CONSTRAINT "Conversation_buyerUserId_fkey" FOREIGN KEY ("buyerUserId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Conversation Conversation_listingId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Conversation"
    ADD CONSTRAINT "Conversation_listingId_fkey" FOREIGN KEY ("listingId") REFERENCES public."Listing"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Conversation Conversation_ownerUserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Conversation"
    ADD CONSTRAINT "Conversation_ownerUserId_fkey" FOREIGN KEY ("ownerUserId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: EmailLog EmailLog_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."EmailLog"
    ADD CONSTRAINT "EmailLog_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Favorite Favorite_listingId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Favorite"
    ADD CONSTRAINT "Favorite_listingId_fkey" FOREIGN KEY ("listingId") REFERENCES public."Listing"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Favorite Favorite_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Favorite"
    ADD CONSTRAINT "Favorite_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Lead Lead_listingId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Lead"
    ADD CONSTRAINT "Lead_listingId_fkey" FOREIGN KEY ("listingId") REFERENCES public."Listing"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Lead Lead_ownerUserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Lead"
    ADD CONSTRAINT "Lead_ownerUserId_fkey" FOREIGN KEY ("ownerUserId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Lead Lead_senderUserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Lead"
    ADD CONSTRAINT "Lead_senderUserId_fkey" FOREIGN KEY ("senderUserId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ListingImage ListingImage_listingId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ListingImage"
    ADD CONSTRAINT "ListingImage_listingId_fkey" FOREIGN KEY ("listingId") REFERENCES public."Listing"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ListingReport ListingReport_listingId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ListingReport"
    ADD CONSTRAINT "ListingReport_listingId_fkey" FOREIGN KEY ("listingId") REFERENCES public."Listing"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: ListingReport ListingReport_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ListingReport"
    ADD CONSTRAINT "ListingReport_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: ListingView ListingView_listingId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."ListingView"
    ADD CONSTRAINT "ListingView_listingId_fkey" FOREIGN KEY ("listingId") REFERENCES public."Listing"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Listing Listing_createdById_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Listing"
    ADD CONSTRAINT "Listing_createdById_fkey" FOREIGN KEY ("createdById") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Message Message_conversationId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_conversationId_fkey" FOREIGN KEY ("conversationId") REFERENCES public."Conversation"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Message Message_recipientUserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_recipientUserId_fkey" FOREIGN KEY ("recipientUserId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Message Message_senderUserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Message"
    ADD CONSTRAINT "Message_senderUserId_fkey" FOREIGN KEY ("senderUserId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Notification Notification_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Notification"
    ADD CONSTRAINT "Notification_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: OwnerRating OwnerRating_listingId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."OwnerRating"
    ADD CONSTRAINT "OwnerRating_listingId_fkey" FOREIGN KEY ("listingId") REFERENCES public."Listing"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: OwnerRating OwnerRating_ownerUserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."OwnerRating"
    ADD CONSTRAINT "OwnerRating_ownerUserId_fkey" FOREIGN KEY ("ownerUserId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: OwnerRating OwnerRating_raterUserId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."OwnerRating"
    ADD CONSTRAINT "OwnerRating_raterUserId_fkey" FOREIGN KEY ("raterUserId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: PasswordResetToken PasswordResetToken_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."PasswordResetToken"
    ADD CONSTRAINT "PasswordResetToken_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Payment Payment_listingId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Payment"
    ADD CONSTRAINT "Payment_listingId_fkey" FOREIGN KEY ("listingId") REFERENCES public."Listing"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: Payment Payment_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."Payment"
    ADD CONSTRAINT "Payment_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: RankingDecisionItem RankingDecisionItem_decisionId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."RankingDecisionItem"
    ADD CONSTRAINT "RankingDecisionItem_decisionId_fkey" FOREIGN KEY ("decisionId") REFERENCES public."RankingDecision"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: RankingFeedback RankingFeedback_decisionItemId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."RankingFeedback"
    ADD CONSTRAINT "RankingFeedback_decisionItemId_fkey" FOREIGN KEY ("decisionItemId") REFERENCES public."RankingDecisionItem"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: SavedSearch SavedSearch_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public."SavedSearch"
    ADD CONSTRAINT "SavedSearch_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."User"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict vslfMWgKYaYCkrIhw237B9v4CrrVOHI8TkWVka493RcfPgrkJTjTOHn7skSPIDW

