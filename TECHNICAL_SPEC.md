# ZEENGO — Technical Specification (Role-by-Role Feature & Control Document)

> Companion documents:
> - `USER_FLOW.md` — user journeys and lifecycles
> - `BACKEND_SPEC.md` — system architecture, database schema, API contract
>
> This document defines **exactly what every user type sees, controls, and the data each screen/tab must load**, based on the approved dashboard screenshots. It is the build checklist for frontend + backend.

---

## 0. System Overview

| Property | Value |
|---|---|
| Product | Travel operations platform for Arab tourists visiting Russia |
| Surfaces | **Ops Dashboard (web)** — 5 staff roles · **Client App (Flutter)** — 1 client role |
| Staff roles | `admin`, `ops_manager`, `splizer`, `support`, `driver` |
| Client role | `client` (mobile app only, never sees dashboard) |
| Universal key | **ZN booking code** (`ZN####`, auto-generated) — every payment, chat, SOS, task, edit request, and notification references it |
| Languages | Dashboard: AR ↔ EN toggle · Client↔staff chat: auto-translated **Arabic ↔ Russian** · AI email drafts: EN/RU/AR |
| Realtime | Dashboard auto-refresh (30s) + Operations Room (15s) + WebSocket pushes + driver GPS every 30s + Stripe webhooks |
| AI (Claude) | Itinerary parser · Russia Ops chatbot · vendor email drafting · End-of-Day report |
| Payments | Cash, Stripe (payment links), Rajhi Transfer, USDT TRC20 |

### 0.1 Global dashboard shell (all staff roles)

Every dashboard role gets the same shell, with a **role-scoped sidebar**:

| Element | Behaviour | Data required |
|---|---|---|
| Global search bar | Search clients by name / ZN code / phone from anywhere; results deep-link to client profile | `GET /clients?search=` |
| Language toggle | AR ↔ EN, flips UI copy + RTL/LTR | local + user preference |
| Theme toggle | dark / light | local preference |
| Notification bell | Unread count badge; dropdown of latest; links to Notifications page | `GET /notifications?unread=true` + WS `notification.new` |
| Profile menu | Name, role label, avatar; change password; logout | `GET /auth/me` |
| Sidebar badges | SOS Alerts active count (red), Notifications unread count | WS-updated counters |
| Logout | Kills session/refresh token | `POST /auth/logout` |

### 0.2 Role → sidebar matrix (source of truth)

| Sidebar item | Admin | Ops Manager | Splizer | Support | Driver |
|---|:-:|:-:|:-:|:-:|:-:|
| Dashboard | ✅ | ✅ | | | |
| Operations Room | ✅ | ✅ | | | |
| Daily Operations | ✅ | ✅ | | | |
| SOS Alerts | ✅ | ✅ | | ✅ | |
| Clients | ✅ | ✅ | | ✅ | |
| Edit Requests | ✅ | ✅ | | ✅ | |
| Drivers | ✅ | ✅ | | | |
| Vendors | ✅ | ✅ | | ✅ | |
| Splizer (Cash Collection) | ✅ | ✅ | ✅ | | |
| Finance | ✅ | ✅ (view) | | | |
| Packages | ✅ | ✅ (view) | | | |
| Zeen Rafeq VIP | ✅ | ✅ | | | |
| Team Chat | ✅ | ✅ | | ✅ | |
| Client Chat | | | ✅ | | ✅ |
| My Schedule | | | | | ✅ |
| AI Parser | ✅ | ✅ | | | |
| Russia Chatbot | ✅ | ✅ | ✅ | ✅ | ✅ |
| Email System | ✅ | ✅ | | ✅ | |
| Notifications | ✅ | ✅ | ✅ | ✅ | ✅ |
| Support (System Status) | ✅ | ✅ | | | |
| User Management | ✅ | | | | |
| Settings | ✅ | | | | |

---

## 1. ADMIN — Full Feature Specification

Admin has **every module** and is the only role with User Management + Settings. Everything below also applies to **Ops Manager** except where marked **[Admin-only]**.

### 1.1 Ops Dashboard (`/dashboard`)

Real-time command overview. **Auto-refresh: 30 seconds** + manual Refresh button. Header shows an "N urgent" badge.

**KPI cards — data contract:**

| Card | Primary value | Secondary values | Click action |
|---|---|---|---|
| Active Clients | count of `bookings.status=active` | arriving today / departing today | → Clients (filtered active) |
| Urgent Tasks | count of open urgent tasks | overdue count / open count | → Operations Room tasks |
| Drivers in Field | drivers not `off_duty` | available count / en-route count | → Drivers |
| Revenue Today | sum of payments `paid` today | pending amount today | → Finance |
| Today's Itinerary | % done (done/total items today) | done / active / total | → Daily Operations (today) |
| Unassigned Clients | active bookings with no driver | — | **"Assign now →"** → Drivers/Scheduling |
| Ops Queue | vendor-pending count | overdue tasks count | → Operations Room |

**Panels:**

1. **Urgent Alerts** — merged, priority-ordered feed:
   - Active SOS alerts (client Arabic name + ZN code) → **View** button → SOS page
   - Pending Edit Requests (type + client + code) → **Review** button → opens review modal inline
   - Urgent tasks with booking code chips
2. **Driver Board** — all drivers: avatar, name, ZN of current assignment, status pill (`AVAILABLE` green / `EN ROUTE` amber / `RESTING` / `OFF DUTY`), call icon (tel: link). **Manage →** opens Drivers.
3. **Pending Urgent Tasks** — checkbox list: title + booking code, client name, due date. Checking = complete task.
4. **Today's Schedule** & **Tomorrow** — event count + event list (time, client, activity). Empty state: "No events scheduled".
5. **End of Day Report** — "AI-powered operations summary" + **Send** button → generates Claude summary of the day (KPIs, completed items, incidents, payments) and distributes it (Team Chat + email).

### 1.2 Operations Room (`/operations-room`)

Live 3-column command center. **Auto-refresh: 15 seconds.** Header: **+ Add Task**.

| Column | Blocks | Controls |
|---|---|---|
| Left | **Today's Events** · **Urgent Tasks** (count badge) · **Other Tasks** | check task complete; priority pills `Urgent`/`Normal`; tasks reference ZN codes |
| Middle | **Driver Board** (status pills) · **Live Map** | Google Maps: live driver markers (GPS every 30s) + client POIs from today's itinerary |
| Right | **SOS Alerts** (red cards) · **Edit Requests** (pending count) · **Quick Actions** | SOS card → SOS page; Edit Request card → review modal |

**Quick Actions (right column):**
- **+ New Client Booking** — opens the booking form (see 1.5)
- **Open Splizer / Collect Payment** — routes to Splizer module
- **AI Package Parser** — routes to AI Parser

**+ Add Task modal:** title*, description, priority (`urgent`/`normal`), linked ZN code (optional autocomplete), assignee (staff dropdown), due date → `POST /tasks`.

### 1.3 Daily Operations (`/daily-operations`)

Per-day itinerary execution board.

- **Week strip:** 7 day-buttons (e.g. Sat 30 … Wed 5), selected day highlighted; under strip: `N clients · N items · N active · N done` counters for selected day.
- **Date picker** (jump to any date) + refresh.
- **Body:** every itinerary item for that date, grouped by client: time, title, client (name + ZN), vendor, driver, status pill (`pending` / `active` / `done`). Staff can mark item started/done here.
- Empty state: "Nothing scheduled — No itinerary items for this date."

### 1.4 SOS Alerts (`/sos`)

- Header: title + "N active emergencies" + **Refresh**.
- Tabs: **Active** / **History**.
- **Active alert card:** red border, "SOS EMERGENCY" label, elapsed time, client avatar + Arabic name + ZN code, **View file →** (client profile), message line (e.g. "طلب طوارئ من محمد العتيبي (ZN0001)"), buttons: **In-App Chat** (opens the client's chat thread) and **Resolve** (green).
- **Resolve** → confirmation → alert moves to History with resolver + timestamp.
- **History tab:** resolved alerts (client, code, created, resolved by, duration).
- Pinned **Emergency Protocol** panel:
  1. Call the client immediately
  2. Notify the nearest driver via the Drivers board
  3. If medical: call 103 (ambulance) or 112 (emergency)
  4. Mark the SOS as resolved once the situation is handled

### 1.5 Clients (`/clients`)

Header: **+ New Client**. Two tabs:

**Tab A — Client List**
- Search: name / ZN code / phone. Filter: status (All / Active / Completed / Cancelled).
- Table columns: **Client** (name, nationality, pax) · **Code** (ZN chip) · **Arrival** · **Package** · **Amount** ($ total) · **Paid** (paid green / due red) · **Status** pill · actions (chat icon, open `>`).

**Tab B — Booking Codes (ZN)**
- Stat cards: **Total / Active / Completed / Cancelled** counts.
- Search: ZN code, name, phone, nationality.
- Table: **ZN code** (+ copy-to-clipboard) · **Client name** (+ phone, ⭐ VIP badge) · **Package** · **Dates** (arrival → departure) · **Status** · **Created** ("2d ago") · **Open ↗**.

**+ New Client Booking form** — banner: "A ZN#### code is auto-generated on creation"
| Section | Fields |
|---|---|
| Client Information | Full Name* · Phone (+966 5…) · Email · Nationality (default Saudi Arabia) · Party Size (default 1) |
| Trip Details | Arrival Date · Departure Date · Package (dropdown from Packages) · Total Amount (USD) · Internal Notes |
| Actions | Cancel · **+ Create Client Booking** (disabled until required fields valid) |

**Client Profile (`/clients/:id`)**
- Header: back, name, ⭐ VIP badge, status pill, action icons (chat, add payment/quick add, edit).
- **Payment bar:** TOTAL · PAID · DUE (red) · ARRIVAL · DEPARTURE · PARTY (pax + nationality).
- **Tabs:**

| Tab | Data shown | Controls |
|---|---|---|
| **Info** | Contact card: phone, email, pax + nationality, **WhatsApp** button. Trip Details card: arrival, departure, package (chip), driver ("Not assigned" or driver name) | edit contact; assign driver shortcut |
| **Program** | Day-by-day itinerary: day header (Day 1 — date), items (time, title, vendor, driver, status) | add/edit/delete/reorder items; import from AI Parser |
| **Payments** | All payments for this booking: date, method, amount, status, collected-by, location | record payment; create Stripe link (routes to Splizer prefilled) |
| **Chat** | Client conversation thread (auto-translated AR↔RU), message composer | send message, attachments |
| **Checklist** | Prep checklist items with done-toggles; badge = remaining count | add / toggle / delete items |
| **Notes** | Internal staff notes (author + timestamp) | add note |

### 1.6 Edit Requests (`/edit-requests`) — feature

"Client program change requests — review and approve."

- Filter tabs: **Pending / Approved / Rejected / All**.
- Request card: status pill (`Pending` amber) · type chip (**Date Change**) · client Arabic name · ZN chip · requested value (e.g. `2026-04-24`) · quoted reason · created timestamp.
- **Review Edit Request modal:**
  - Read-only: Client, Booking Code, Request Type, Status
  - **Original Value** (readonly box) vs **Requested Change** (highlighted box)
  - **Reason** (italic, client-written)
  - **Review Notes (optional)** — "Add a note for the client or team…"
  - Buttons: Cancel · **Reject** (red) · **Approve** (blue)
- **Approve** side-effects: booking/program value updated (e.g. departure date shifted), client push notification, request → Approved.
- **Reject** side-effects: client push notification with note, request → Rejected.
- **VIP Request** is a request type in the same pipeline: "requested Zeen Rafeq VIP upgrade ($100)" → approval triggers VIP activation (see 1.12).

### 1.7 Drivers (`/drivers`)

Top tabs: **Driver Roster** | **Scheduling**.

**Driver Roster:**
- Left panel — **Driver Hub**: filter chips `All / Free N / Active N / Rest N / Off N`, search (name, vehicle, plate), driver cards (avatar, name, ★rating, trip count, status dot).
- Right panel — selected driver:
  - Header: avatar, name, availability pill, ★rating + trips, vehicle ("Mercedes E-Class — White 2022" + plate), phone + **WhatsApp** + GPS last-seen ("GPS 59s ago").
  - Tabs:
    - **Schedule** — date picker + **Today**; programs assigned that date (client, ZN, items). Empty: "No programs scheduled for this date."
    - **Trip History** — completed trips (date, client, route, rating).
    - **Manage** — edit profile: name, phone, vehicle make/model/color/year, plate, status override, deactivate.

**Scheduling tab:** calendar/board to assign drivers to bookings per date → this is what clears the Dashboard "Unassigned Clients" KPI. Assignment = (booking, driver, date range) → driver gets a notification + it appears in his My Schedule.

### 1.8 Vendors (`/vendors`)

"Hotels, restaurants, guides, buses, activities & drivers." Header: **+ Add Vendor**.

- Category tabs: **All / Hotels / Restaurants / Guides / Buses / Activities / Drivers**.
- Vendor card: name · type + city subtitle · contact person · phone · email · **commission %** (top-right) · **Assign Vendor** button · **View details →**.
- **View details** → right side-sheet:
  - Header: vendor name, type · city
  - Tabs: **Info** (Type, Contact, Phone, Email, City, Commission %, partner notes e.g. "Partner since 2022, 10% discount on suites…") · **Bookings** (bookings using this vendor) · **Finance** (commission ledger: earned, paid, outstanding)
- **+ Add Vendor modal:** Name · City · Commission % · Contact Name · Phone · Email · Type (dropdown: Hotel/Restaurant/Guide/Bus/Activity/Driver) → **Create Vendor**.
- **Assign Vendor:** pick booking (+ optional itinerary item) → creates vendor booking, appears in vendor's Bookings tab and in the client Program item.

### 1.9 Splizer — Cash Collection (`/splizer`)

"Manage client payments and send Stripe links." Full spec in §3 (Splizer role) — Admin/Ops see the identical module with all 4 tabs and can record collections and create Stripe links themselves.

### 1.10 Finance & Payments (`/finance`)

"Real-time payment tracking and revenue breakdown."

- KPI cards: **Today $** · **Stripe $** · **Cash $** · **Pending $**.
- **Revenue by Method — Last 30 Days** — stacked bar/line chart, series: Stripe, Cash.
- **All Payments table:** Client (Arabic name) · Code (ZN chip) · Method (`Cash`, `Stripe`, `Rajhi Transfer`, `Usdt Trc20`) · Amount · Status pill (`Paid` green / `Pending` amber / `Sent` blue) · Date-time.
- Filters: All Status · All Methods. (Export CSV — recommended addition.)

### 1.11 Packages (`/packages`) — feature

"Tour packages offered to clients." Header: **+ Add Package**. **[Admin: full CRUD · Ops Manager: view]**

- Package card: name · **$price / per person** · duration + min persons line ("3 days · Min 2-2 persons") · one-line description · ✓ inclusions list · edit ✏ · delete 🗑.
- Seeded examples: Love $225 (3d) · Family $280 (5d) · Relaxation $380 (2d) · Royal $1,200 (5d).
- **New Package modal:** Package Name* · Slug · Price/person ($) · Min persons · Duration (days) · Description · **Inclusions** (text input + Add button / Enter; chips list with ✕ remove) → **Create Package**.
- **Edit — [name] modal:** same fields prefilled, inclusions removable → **Save Changes**.
- Deleting/deactivating a package must not break existing bookings (soft-delete).

### 1.12 Zeen Rafeq VIP (`/vip`)

Premium concierge add-on. Hero card: **$100 per trip · 8 services · 24/7 availability**.

- **Activate for a Client:** "Select active client…" dropdown → **Add VIP — $100** button. Effect: `+$100` to booking total, booking flagged VIP ⭐ (badge shows across all modules + client app).
- Tabs:
  - **Overview** — "What's included" grid: 24/7 Personal Concierge · Priority Driver Assignment · Table Reservations Handled · Event & Ticket Booking · Live Translation Support · Shopping Assistance · Medical Emergency Coordination · Airport Fast-Track (each with one-line description).
  - **Requests** — client-initiated VIP upgrade requests (approve/reject → same engine as Edit Requests).
  - **VIP Clients** (count badge) — all VIP bookings: client, ZN, activated date, trip dates.
- **Zeen Rafeq Ops Line** panel: WhatsApp Hotline (+7 …VIP-LINE) · Response SLA: **Under 5 minutes** · Languages: **Arabic · English · Russian**.

### 1.13 Team Chat (`/team-chat`)

Internal staff messaging. Left: conversation list with **+** (new conversation). Right: thread view.

- Conversation types:
  1. **ZEENGO Ops Team** — all-staff group channel (member count shown)
  2. **Booking support threads** — auto-created per booking, titled `ZN#### Support — <client>`; client app messages land here
  3. **Staff DMs** — 1:1
- Thread: sender name, bubbles, relative timestamps, unread markers, emoji, text composer + send. Last-message preview + unread badge in list.

### 1.14 AI Parser (`/ai-parser`)

"Paste a raw trip itinerary — Claude extracts structured day-by-day JSON."

- Left: **Raw Itinerary Text** textarea (placeholder shows example format: `Day 1 — Moscow Airport Transfer / 08:00 Arrival at Sheremetyevo…`).
- **Parse Itinerary** button + reset icon.
- Right: **Parsed Result** — structured days/items JSON preview; empty state "Parsed structure will appear here".
- Follow-up action: apply parsed result to a booking's Program.

### 1.15 Russia Chatbot (`/russia-chatbot`)

"Internal AI assistant for Russia operations — powered by Claude." Header badge: *Claude AI Active* + reset.

- Quick-prompt chips: Halal restaurants in Moscow · Prayer times today · Emergency numbers · Metro tips · Russian phrases · Visa requirements · Currency & ATMs · Orthodox holidays.
- Welcome message lists capabilities (halal restaurants & Muslim-friendly facilities, prayer times & Qibla, emergency contacts, metro/transport, Russian phrases for Arabic guests, banking & currency, weather, landmarks).
- Chat input: "Ask about halal restaurants, prayer times, Russian phrases, emergency contacts… (Enter to send)". Works in **Arabic or English**.
- Footer disclaimer: "Powered by Claude — internal use only — responses are AI generated and may need verification."

### 1.16 Email System (`/email-system`)

"AI-powered email drafting for vendor bookings."

- **Compose Email form:** Vendor Type (dropdown, default Hotel) · Vendor Name · Booking Date · Number of Guests · Special Requests ("Halal food, prayer room, early check-in…") · Language (English/Russian/Arabic) → **Generate Email**.
- Right panel: **Generated Email** — subject + body, **editable before sending**; Send / Copy actions.

### 1.17 Notifications (`/notifications`)

"All system notifications and alerts." Header: "N new" badge + **Mark all read**.

- Filter chips: **All / Unread (count) / SOS / Payments / Tasks / Chat**.
- Row anatomy: type icon + colored label (`SOS` red, `EDIT REQUEST` amber…), title (client + ZN), body (e.g. "requested Zeen Rafeq VIP upgrade ($100)"), time-ago, unread dot, per-row mark-read ✓. Row click deep-links to the source (SOS page, edit request modal, payment, chat thread).

### 1.18 Support & System Status (`/support`)

- **System Status:** live health rows — REST API · PostgreSQL · WebSocket · Stripe Payments · Claude AI, each `Operational` / `Down` with description.
- **Required Environment Variables** reference grid (DATABASE_URL, JWT_SECRET, JWT_REFRESH_SECRET, STRIPE_SECRET_KEY, STRIPE_WEBHOOK_SECRET, ANTHROPIC_API_KEY, …).
- **Recommended Tech Stack** grid (dashboard, client app, backend, database, AI, maps, push, file storage).
- **FAQ accordion:** reset staff member password (Settings → Staff Accounts → key icon) · client payment not updating from Stripe · add a new client booking · AI features not responding · assign a driver · WebSocket real-time not working · program changes propagation to client app · configure Stripe payment links.
- **Need more help?** contact box (dev email + GitHub issues) + version line.

### 1.19 User Management (`/users`) **[Admin-only]**

"Manage staff accounts and role assignments." Header: **+ Add User**.

- **Role summary cards:** Admin / Operations Manager / Splizer / Driver / Support — each with count; clicking filters the staff list (selected card highlighted).
- **Staff Accounts list** (filtered by role): avatar, name, email, phone, role pill, actions: edit ✏ · change-role/reset 🔑.
- **+ Add User modal:** name*, email*, phone, role*, temp password → creates staff account. Driver role additionally creates driver profile (vehicle etc. completed in Drivers → Manage).

### 1.20 Settings (`/settings`) **[Admin-only]**

Company profile · integration keys (Stripe, Claude/Anthropic, Google Maps, FCM) · payment defaults (link expiry 48h, currency USD) · VIP price ($100) · languages · staff password resets.

---

## 2. OPERATIONS MANAGER — Feature Specification

**Sidebar:** everything in §1 **except** User Management and Settings. Finance and Packages are **view-only** (no package CRUD, no payment edits — recording collections via Splizer module is allowed).

| Capability | Ops Manager |
|---|---|
| Dashboard, Operations Room, Daily Operations | ✅ full (tasks CRUD, EOD report send) |
| SOS resolve | ✅ |
| Clients: create booking, edit profile, program, checklist, notes | ✅ |
| Edit Requests: approve / reject | ✅ |
| Drivers: roster, scheduling, manage driver profiles | ✅ |
| Vendors: add, assign, details | ✅ |
| Splizer module: record cash, Stripe links | ✅ |
| Finance | 👁 view dashboards + table |
| Packages | 👁 view cards only (no add/edit/delete) |
| Zeen Rafeq VIP: activate for client, approve requests | ✅ |
| Team Chat / AI Parser / Russia Chatbot / Email System | ✅ |
| Notifications, Support page | ✅ |
| User Management, Settings | ❌ hidden |

---

## 3. SPLIZER — Feature Specification

**Sidebar:** FINANCE: **Splizer** · TOOLS: **Client Chat** · **Russia Chatbot** · SYSTEM: **Notifications**. Nothing else. Splizer must never see other clients' programs, staff management, or vendors.

### 3.1 Splizer — Cash Collection (`/splizer`) — home

"Manage client payments and send Stripe links." Four tabs:

**Tab 1 — Clients**
- Search: "Search name, code, phone…" + All Status filter.
- Client card: name + status pill · ZN chip · nationality · pax · package · arrival date · money boxes: **Total** (blue) / **Paid** (green) / **Due** (red) · chevron to select.
- Selecting a client pins their banner (name, ZN, Total/Paid/Pending) across the Collect Cash and Stripe Link tabs.

**Tab 2 — Collect Cash**
| Field | Spec |
|---|---|
| Amount (USD)* | numeric; helper link **"Fill pending: $X"** autofills the due amount |
| Method | dropdown: **Cash** (default) · Rajhi Transfer · USDT TRC20 |
| Location (optional) | free text — "e.g. Hotel lobby, Red Square…" |
| Notes (optional) | textarea |
| **Record Collection** | disabled until amount > 0; creates a `paid` payment attributed to this Splizer; updates Paid/Due everywhere instantly |

**Tab 3 — Stripe Link**
| Field | Spec |
|---|---|
| Amount (USD)* | numeric |
| Link Expires | dropdown: 24 hours / **48 hours** (default) / 72 hours / 7 days |
| Info banner | "The link will be tracked: **Sent → Opened → Paid** via Stripe Webhooks." |
| **Create & Copy Payment Link** | creates Stripe payment link, records a `sent` payment, copies URL to clipboard for WhatsApp/chat delivery |

**Tab 4 — History**
- Date-range pickers (from → to) + search: "Search client, code, staff…".
- Rows: date-time · client + ZN · amount · method · location · collected-by staff. Empty: "No collections found for this range."

**Bottom utility card — Search Client by Code:** ZN input + **Find** (jumps straight to that client selected) + **Browse List**.

### 3.2 Client Chat (`/client-chat`)

- Left: **Client Chat** list — search; each row: avatar, name, ZN code, **due amount in red** (payment context always visible), online/offline dot, ⭐ VIP.
- Right: thread. Empty state: "Select a client to start chatting — Messages are auto-translated **Arabic ↔ Russian**."
- Composer: text + send; messages display original + translated per viewer language.

### 3.3 Russia Chatbot — same as §1.15.

### 3.4 Notifications
Same page as §1.17 with filters All / Unread / SOS / Payments / Tasks / Chat. Splizer primarily receives: payment events (link opened/paid), chat messages, task assignments.

**Splizer permission boundary:** can read client payment status + chat; can create payments/links; **cannot** edit bookings, programs, or see Finance analytics.

---

## 4. SUPPORT — Feature Specification

**Sidebar:** **SOS Alerts** · CLIENTS: **Clients**, **Edit Requests**, **Vendors** · TOOLS: **Team Chat**, **Russia Chatbot**, **Email System** · SYSTEM: **Notifications**.

| Module | Spec | Differences vs Admin |
|---|---|---|
| **SOS Alerts** (home) | identical to §1.4 — Active/History, In-App Chat, Resolve, protocol panel | none — Support is first responder |
| **Clients** | identical to §1.5 — Client List + Booking Codes tabs, **+ New Client** allowed, full profile (Info/Program/Payments/Chat/Checklist/Notes) | Payments tab is **view-only** (no recording — that's Splizer/Admin/Ops) |
| **Edit Requests** | identical to §1.6 — full review modal, Approve/Reject with notes | none |
| **Vendors** | identical to §1.8 — **+ Add Vendor**, Assign Vendor, details sheet | Finance tab of vendor sheet view-only |
| **Team Chat** | identical to §1.13 — Ops Team channel, `ZN#### Support` threads (Support owns these), DMs | none |
| **Russia Chatbot** | §1.15 | none |
| **Email System** | §1.16 — vendor booking emails | none |
| **Notifications** | §1.17 | receives SOS, edit requests, chat, tasks |

**Support permission boundary:** no Finance module, no Splizer module, no Drivers module (uses Team Chat/ops to coordinate drivers), no packages, no user management.

---

## 5. DRIVER — Feature Specification

**Sidebar:** **My Schedule** · TOOLS: **Client Chat**, **Russia Chatbot** · SYSTEM: **Notifications**. Mobile-friendly layout.

### 5.1 My Schedule (`/my-schedule`) — home

- Header: "My Schedule" + today's date + own name.
- **Status toggle (top-right): `En Route` / `Resting` / `Off Duty`** — single-select buttons; writes driver status live to the Driver Board, Dashboard KPIs, and Operations Room.
- Info banner: **"GPS broadcasting every 30s — visible to ops"** — the dashboard client sends `POST /drivers/me/gps` (or WS event) every 30s while not off-duty.
- Counters: **TOTAL / ACTIVE / DONE** trips today.
- Trip list (today): each card = client name + ZN, pickup time & location, itinerary items in order, per-item action: **Start → En Route → Done**. Completing items updates Daily Operations + Dashboard itinerary %.
- Empty state: "No trips assigned for today — Contact operations if you expect an assignment."
- Date is fixed to *today* for the driver (history visible via past dates optional).

### 5.2 Client Chat (`/client-chat`)
Same component as Splizer's (§3.2) but the list is **scoped to clients assigned to this driver**. Auto-translated Arabic ↔ Russian (Russian driver ↔ Arabic client).

### 5.3 Russia Chatbot — §1.15 (driver asks halal restaurants, metro, phrases on the road).

### 5.4 Notifications
Receives: new trip assignment, itinerary change on his trips, SOS involving his client (high priority), chat messages, task assignments.

**Driver permission boundary:** sees only own schedule + own assigned clients' chat. No client financials, no other drivers, no vendors, no bookings CRUD.

---

## 6. CLIENT (Mobile App — Flutter) — Feature Specification

Auth-based app; every screen scoped to **the client's own booking(s)**.

### 6.1 Auth
- Register: name, phone (+966), email, password → **OTP verification** (SMS) → email verification.
- Login (phone/email + password) · Forgot password → OTP → new password · Change password · Logout.
- Session: JWT + refresh, persisted.

### 6.2 Home — My Trip
| Block | Data |
|---|---|
| Booking header | ZN code, status pill, ⭐ VIP badge |
| Package card | package name, duration, inclusions |
| Dates | arrival → departure countdown, party size |
| Today | today's itinerary items with times |
| Driver card | name, photo, ★rating, vehicle + plate, **Call** + **WhatsApp** (hidden until assigned) |

### 6.3 Program
Full day-by-day itinerary (read-only): Day N header, items (time, title, place, vendor), live status (upcoming/active/done). Receives WebSocket updates when ops edits the program.

### 6.4 Checklist
Trip-prep checklist synced with dashboard Checklist tab; client can tick personal items.

### 6.5 Payments
- Summary: **Total / Paid / Due**.
- History list: date, amount, method (cash shows collector location note; Stripe shows link status).
- **Pay Now:** opens active Stripe payment link (expiry shown); after webhook confirms → instant status update + push notification.

### 6.6 Chat
Single support thread (→ `ZN#### Support` in dashboard Team Chat). Client writes Arabic; staff sees translated; replies auto-translate back. Attachments (images) supported.

### 6.7 Edit Requests
- **New request:** type picker (**Date Change** / Itinerary Change / Other), original value auto-filled, new value picker, reason textarea → submit.
- **My requests list:** status (Pending/Approved/Rejected) + staff review note.
- Push notification on decision.

### 6.8 Zeen Rafeq VIP
- Promo screen: $100 add-on, the 8 included services, ops line SLA.
- **Request VIP upgrade** → creates VIP request (staff approves → +$100 to total, VIP active, badge appears).
- If VIP active: concierge screen with WhatsApp hotline button (AR/EN/RU, <5 min SLA).

### 6.9 SOS
- Prominent red SOS button (home + persistent) → confirm → `POST /sos` with booking + optional message + GPS position.
- After trigger: "Help is on the way" state, direct chat opens, staff calls.
- Client sees resolution status.

### 6.10 Map
Itinerary POIs for the trip; live driver marker when driver `en_route` on client's trip.

### 6.11 Account & Notifications
Profile (name, phone, email, nationality, avatar) · language AR/EN · change password · logout. Push (FCM): program changes, edit-request decision, payment link received, payment confirmed, driver assigned, chat replies, VIP approval.

---

## 7. Shared Feature Deep-Specs (cross-role)

### 7.1 Auto-translation chat pipeline
- Staff↔client messages store: `body` (original), `body_translated`, `source_lang`, `target_lang`.
- Direction: client writes `ar` → translate `ru` (and `en`); staff writes `ru`/`en` → translate `ar`.
- Translation is async (queue) but should target <2s; message delivers immediately with original text, translation patches in.

### 7.2 Presence & GPS
- Driver GPS ping every 30s (only while status ≠ off_duty). Latest position cached (Redis) for Live Map; history persisted for audit.
- Client chat online dots = WebSocket presence.

### 7.3 Notification fan-out rules
| Event | Notifies |
|---|---|
| SOS created | admin, ops_manager, support (+ assigned driver) — bell + push + dashboard badges |
| Edit request created | admin, ops_manager, support |
| Edit request decided | the client (push) |
| Payment link opened / paid | splizer who created it, admin, ops_manager |
| Cash recorded | admin, ops_manager |
| Trip assigned / changed | the driver |
| Program changed | the client |
| Task assigned | the assignee |
| Chat message | thread participants (unread badge) |
| VIP request / approved | staff / client respectively |

### 7.4 Status enums (UI pills)
- Booking: `active` · `completed` · `cancelled`
- Payment: `pending` · `sent` · `opened` · `paid` · `expired` · `failed`
- Driver: `available` · `en_route` · `resting` · `off_duty`
- Task: `open` · `done` (+ priority `urgent`/`normal`)
- SOS: `active` · `resolved`
- Edit request: `pending` · `approved` · `rejected`
- Itinerary item: `pending` · `active` · `done` · `cancelled`

### 7.5 Auto-refresh / realtime budget
| Surface | Mechanism |
|---|---|
| Dashboard | 30s polling + WS invalidation |
| Operations Room | 15s polling + WS |
| SOS badge / notifications | WS push (instant) |
| Live Map | WS GPS stream (30s cadence) |
| Client app program/payments | WS + FCM push |
| Stripe status | webhook → WS broadcast |
