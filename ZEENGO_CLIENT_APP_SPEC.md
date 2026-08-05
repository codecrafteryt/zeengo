# Zeengo Client App — User Flow & Technical Spec

**App:** Zeengo (Travel guest / client mobile app)  
**Platform:** Flutter (iOS / Android)  
**Version:** `1.0.0+1`  
**Architecture:** GetX (DI · navigation · i18n · reactive state)  
**Design size:** 390 × 844 (`flutter_screenutil`)  
**Document type:** Client app structure · user flows · technical reference  
**Last updated:** August 2026  

---

## 1. Product overview

Zeengo is a **guest-facing travel companion** for package trips (demo context: Moscow / Russia + GCC travelers — bilungual **English / Arabic**, mosques, halal food, splizer/driver/support chat, multi-rail payments).

### 1.1 Client goals (current UI scope)

| Goal | How the app supports it |
|------|-------------------------|
| See trip at a glance | Explore header, stats, schedule, payment progress |
| Get help on the go | AI assistant sheet, Suggestions tips, Inbox chat |
| Navigate nearby | Map (mosques, halah, ATM, malls) + directions |
| Pay outstanding balance | Pay tab / Pay Balance sheet (card, bank, USDT, cash, Apple Pay path) |
| Manage preferences | Language, light/dark theme on Profile |

### 1.2 Persona (demo)

- **Role:** Guest / traveler  
- **Demo identity:** Guest (`محمد`), booking **ZN0001**, package **Love Package – 20 Apr 2026**  
- **Status:** No forced login gate — splash → home shell  

---

## 2. High-level architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        main.dart                            │
│  dotenv → DependencyInjection → Stripe.init → GetMaterialApp │
└────────────────────────────┬────────────────────────────────┘
                             │
                    SplashScreen (~1.1s)
                             │
                         HomePages
                             │
                          NavBar (IndexedStack)
        ┌────────┬───────────┼───────────┬──────────┐
        ▼        ▼           ▼           ▼          ▼
     Explore    Map        Inbox        Pay      Profile
        │        │           │           │          │
   bottom sheets  places   local chat  methods   settings
```

### 2.1 Folder map (source)

| Layer | Path | Responsibility |
|-------|------|----------------|
| Entry | `lib/main.dart` | Bootstrap, theme/locale binding |
| DI | `lib/data/helper/get_di.dart` | GetX registration |
| Controllers | `lib/controller/` | Business / UI state |
| Data | `lib/data/` | API provider, repos, models, i18n |
| Services | `lib/services/` | Stripe payment |
| Views | `lib/views/` | Screens + feature widgets |
| Utils | `lib/utils/values/` | Colors, theme, fonts, images, env |
| Assets | `assets/` | Fonts, images, SVGs, `.env` |

---

## 3. Boot / cold start technical flow

```
1. WidgetsFlutterBinding.ensureInitialized()
2. dotenv.load(fileName: '.env')
3. DependencyInjection.init()
   - SharedPreferences (permanent)
   - LanguageController, ThemeController (permanent)
   - MapController (permanent)
   - ApiProvider, AuthRepo, AuthController (lazy + fenix)
   - CurrencyConverterController, SuggestionsController (lazy + fenix)
4. StripePaymentService.instance.init()  // publishable key from env
5. runApp(MyApp)
6. ScreenUtilInit + Obx(GetMaterialApp)
   - theme / darkTheme / themeMode from ThemeController
   - locale from LanguageController
   - home: SplashScreen
7. Splash delays → Get.off(HomePages)
8. NavBar IndexedStack keeps 5 tabs alive
```

### 3.1 Environment variables (`.env`)

| Key | Used for |
|-----|----------|
| `GOOGLE_MAPS_API_KEY` | Google Maps (native config also needed) |
| `YANDEX_MAPS_API_KEY` | Yandex external / readiness check |
| `STRIPE_PUBLISHABLE_KEY` | Stripe SDK init + card entry |
| `STRIPE_PAYMENT_INTENT_URL` | Optional backend PaymentIntent endpoint |

**Code access:** `lib/utils/values/env.dart`

---

## 4. Client user journey map

### 4.1 First open

```
Launch app
  → Splash (brand + loader, app theme applied)
  → Main shell (last/default tab = Explore)
  → Guest can use Explore / Map / Inbox / Pay / Profile
```

**Not in current flow:** login, OTP, onboarding carousel (auth/repo skeleton only).

### 4.2 Primary daily-use journey

```
Explore (trip home)
  ├─ Scan stats / schedule / payment progress
  ├─ AI Assistant → ask trip questions (local demo reply)
  ├─ Currency → convert USD ↔ SAR ↔ RUB
  ├─ Suggestions → tips + CTA snackbars
  ├─ Pay Balance → same Pay UI in sheet
  ├─ Notifications (header bell → empty screen)
  └─ Language (header control → EN / AR picker)

Map
  ├─ Switch Google / Yandex preference
  ├─ Filter categories: All · Mosques · Halal · ATM · Malls
  ├─ Select place → route preview + directions card
  │    ├─ Start navigation (camera tilt demo)
  │    ├─ Open in Maps (external app/url)
  │    └─ Close (clear polyline / sheet)
  └─ Header navigate → open Yandex path if configured

Inbox
  ├─ Tab: Support · Driver · Splizer
  ├─ Type message / quick replies (local only)
  └─ WhatsApp ZEENGO banner → wa.me deep link

Pay
  ├─ See due / paid / total
  ├─ Expand payment method
  ├─ Card → Stripe card sheet
  └─ Other methods → WhatsApp request / static details

Profile
  ├─ Trip / Payments / Travel / Support rows (many = coming soon toast)
  ├─ Settings → Language, Theme, About, Privacy
  └─ Logout row (UI only, no session teardown yet)
```

---

## 5. Module-by-module flow

### 5.1 Explore

**Screen:** `lib/views/screen/explore/explore_screen.dart`

| UI block | Widget | Demo data |
|----------|--------|-----------|
| Brand header | `ExploreHeader` | Mohamed, ZN0001, Love Package |
| Stats | `ExploreStatsRow` | 0 days · 2 guests · $100 due |
| Schedule | `ExploreScheduleCard` | Empty day state |
| Actions | `ExploreActionsGrid` | AI · Currency · Suggestions · Pay |
| Progress | `ExplorePaymentCard` | $450 / $550 (~82%) |
| Restaurants | `ExploreRestaurantsCard` | Horizontal cards |
| Weather | `ExploreWeatherCard` | Moscow · placeholder temp |

**Bottom sheets (all status-bar safe height via `belowStatusBar` where applied):**

| Trigger | Sheet | Controller / notes |
|---------|-------|--------------------|
| AI Assistant | `AiAssistantSheet` | Local messages + scripted assistant reply |
| Currency | `CurrencyCalculatorSheet` | `CurrencyConverterController` |
| Suggestions | `SuggestionsSheet` | `SuggestionsController` (4 static tips) |
| Pay Balance | `Payouts(embedded: true)` | Same pay module |

**Navigation out of Explore**

- Notification icon → `NotificationsScreen` (`Get.to`)
- Language → bottom sheet picker (prefs: `app_locale`)

---

### 5.2 Map

**Screen:** `lib/views/screen/map/map_screen.dart`  
**Controller:** `lib/controller/map_controller.dart`

#### User flow

```
Open Map tab
  → Full-bleed Google Map (Airbnb style JSON)
  → Top: provider switch + location strip
  → Bottom: Nearby places panel + category chips
Select category → list + markers refresh
Tap place/marker → polyline + MapDirectionsSheet
  → Start navigation | Open external maps | Close
```

#### Technical notes

| Topic | Spec |
|-------|------|
| Primary SDK | `google_maps_flutter` |
| Center | Moscow `55.7558, 37.6173` |
| Places source | Static `nearby_places_data.dart` |
| Yandex | Preference + external maps URL; **not** embedded Yandex map yet |
| Routes | Client-side curve preview (not Google Directions API) |
| Persistence | `map_provider` in SharedPreferences |

#### Place categories

`all` · `mosques` · `halal` · `atm` · `malls`

---

### 5.3 Inbox / Chat

**Screen:** `lib/views/screen/chat/chats_screen.dart`  
**Channels:** `chat_channel.dart` (`ChatChannels.demo`)

| Channel | Intent | Demo seed |
|---------|--------|-----------|
| Support | Zeengo support | Sample user message |
| Driver | Personal driver | Empty start + quick replies |
| Splizer | Trip organiser | Mixed thread |

#### User flow

```
Inbox title
  → Select Support / Driver / Splizer
  → Read / empty state
  → Quick reply chips OR type + send
  → Optional WhatsApp banner → external WhatsApp
```

#### Technical notes

- In-memory `List<List<ChatMessage>>` — lost on process kill  
- No socket client wired despite packages in pubspec  
- WhatsApp: `url_launcher` → `https://wa.me/+79160000000`  

---

### 5.4 Pay (Payouts)

**Screen:** `lib/views/payouts/payouts.dart`  
**Entry points:** Bottom nav **and** Explore “Pay Balance” sheet  

#### Balance (static demo)

| Field | Value |
|-------|-------|
| Due | $100 |
| Paid | $450 |
| Total | $550 |

#### Payment methods catalog

1. **Visa / Mastercard (Stripe)** — expandable · recommended  
2. **Apple Pay** — WhatsApp assist path  
3. **Al-Rajhi** — static bank details · WhatsApp  
4. **USDT TRC20** — address + QR actions · WhatsApp  
5. **USDT BEP20** — same pattern  
6. **Cash** — pay splizer · WhatsApp  

#### Stripe flow (card)

```
Select Card method → Pay action
  → CustomBottomSheet → StripeCardPaymentSheet
  → User enters card (Stripe CardField)
  → StripePaymentService.payWithCard(...)
       ├─ If STRIPE_PAYMENT_INTENT_URL set → full PI + confirm
       └─ Else → create PaymentMethod only (needs backend wiring)
  → Success / failure snackbar
```

---

### 5.5 Profile / Account

**Screen:** `lib/views/screen/account/account.dart`

| Section | Items | Behavior today |
|---------|-------|----------------|
| Profile | Guest, Show profile | Toast / no real profile API |
| Trip | Booking, Daily program, Request changes, Notifications | Mostly coming-soon toast |
| Payments | Outstanding, History, Currency calculator | Toast |
| Travel | Prayer, Russia guide, Maps, Nearby | Toast |
| Support | Chat, Emergency | Toast |
| Settings | Language, Theme, About, Privacy | Language + Theme real; others toast |
| Logout | Logout row | No-op UI |

#### Settings — real flows

**Language**

```
Settings → Language OR Explore language control
  → Bottom sheet: English / Arabic
  → LanguageController.setLocale
  → SharedPreferences (app_locale) + Get.updateLocale
```

**Theme**

```
Settings → Theme
  → System default | Light | Dark
  → ThemeController.setMode
  → SharedPreferences (app_theme_mode) + Get.changeThemeMode
```

---

## 6. Dependency injection registry

**File:** `lib/data/helper/get_di.dart`

| Dependency | Registration | Lifetime |
|------------|--------------|----------|
| `SharedPreferences` | `Get.put` | permanent |
| `LanguageController` | `Get.put` | permanent |
| `ThemeController` | `Get.put` | permanent |
| `MapController` | `Get.put` | permanent |
| `ApiProvider` | `Get.lazyPut` | fenix |
| `AuthRepo` | `Get.lazyPut` | fenix |
| `AuthController` | `Get.lazyPut` | fenix |
| `CurrencyConverterController` | `Get.lazyPut` | fenix |
| `SuggestionsController` | `Get.lazyPut` | fenix |

**Convention**

- **Permanent:** app-wide, boot-critical, prefs-backed  
- **Lazy + fenix:** recreate if disposed; feature controllers & network  

---

## 7. State management pattern

| Concern | Approach |
|---------|----------|
| App theme / locale | GetX `Rx` + `Obx` on `GetMaterialApp` |
| Map | `GetxController` + `GetBuilder` / `update()` |
| Currency · Suggestions | GetX controller + `Obx` |
| Chat threads | Local `StatefulWidget` state |
| Explore sheets | Stateless UI + controllers / local state |

---

## 8. Theming & design system

### 8.1 Theme

| Piece | File |
|-------|------|
| Theme data | `lib/utils/values/app_theme.dart` |
| Semantic colors | `lib/utils/values/app_palette.dart` |
| Brand colors | `lib/utils/values/my_color.dart` |
| Font | Roboto Normal · `MyFonts.roboto` · `assets/fonts/roboto_normal.ttf` |
| App text | `CustomTextWidget` |

### 8.2 Palette roles

| Token | Light (approx) | Dark (approx) |
|-------|----------------|---------------|
| scaffold | `#F7F7F7` | pure black |
| card | white | `#141414` |
| cardMuted | soft grey | `#1A1A1A` |
| border | `#DDDDDD` | `#2A2A2A` |
| textPrimary | `#262626` | light grey |
| textSecondary | `#717171` | muted grey |
| accent | `MyColors.darkPurple` `#6366F1` | same |

### 8.3 Mode persistence

`ThemeController` keys: `system` | `light` | `dark` → prefs `app_theme_mode`

### 8.4 Shared UI building blocks

| Widget | Purpose |
|--------|---------|
| `CustomBottomSheetWidget` | Modal sheets, optional `belowStatusBar` height |
| `CustomHeaderBarWidget` | Sheet close (AppCircleIconButton, right) |
| `AppCard` | Soft elevation cards |
| `AppSegmentTabs` | Inbox / reusable segment control |
| `AppSvgIcon` | Tinted SVG ± circular bg |
| `CustomTextWidget` | App-wide Roboto text |

**Aesthetic direction:** Airbnb-like soft elevation, brand purple accents, light/dark Cursor-inspired surfaces, rounded panels, light motion/stagger where polished (Explore / Map / Inbox).

---

## 9. Internationalization

| Item | Spec |
|------|------|
| Engine | GetX `Translations` |
| Locales | `en_US`, `ar_SA` |
| Keys | `lib/data/enus.dart` |
| Maps | `lib/data/languages.dart` |
| RTL | System material localizations when Arabic selected |
| Persist | `app_locale` = `en` | `ar` |

---

## 10. Networking & payments (current)

### 10.1 API layer

- `ApiProvider` (GetConnect-style provider under `lib/data/api_provider/`)
- `AuthRepo` / `AuthController` — wired in DI, **not** on launch path  
- Base URL still placeholder-level for real backends  

### 10.2 Stripe

| Item | Spec |
|------|------|
| Package | `flutter_stripe` |
| Service | `lib/services/stripe_payment_service.dart` |
| UI | `StripeCardPaymentSheet` |
| Android | Prefer `FlutterFragmentActivity` (project already adjusted for Stripe) |

### 10.3 External intents

| Action | Mechanism |
|--------|-----------|
| WhatsApp | `url_launcher` + `wa.me` |
| Google / Yandex Maps | Maps URLs via `url_launcher` |

---

## 11. Tech stack (pubspec summary)

| Area | Packages |
|------|----------|
| Framework | Flutter, Material, `flutter_localizations` |
| State / nav / i18n | `get` |
| Prefs / env | `shared_preferences`, `flutter_dotenv` |
| Layout | `flutter_screenutil` |
| Maps | `google_maps_flutter` |
| UI extras | `flutter_svg`, `shimmer`, `loading_animation_widget`, `cached_network_image` |
| Payments | `flutter_stripe` |
| Network (ready) | `http`, sockets packages (not used by chat UI yet) |
| Location (declared) | `geolocator`, `geocoding`, `permission_handler` |
| Other | `url_launcher`, `image_picker`, `flutter_local_notifications`, `connectivity_plus`, `flutter_slidable` |

---

## 12. Assets structure

```
assets/
  fonts/
    roboto_normal.ttf
  images/
    app_icon/
  svgs/
    nav_bar/          → bottom navigation
    explore/          → explore icons
    chat/             → inbox
    map/              → map categories / pin / navigate
    payout/           → payment method icons
    notification/
    profile/
    search_svgs/
    translate_flat.svg
    close_cancel.svg
  .env
```

Register path: `pubspec.yaml` → `flutter.assets`

Icon constants: `lib/utils/values/my_images.dart`

---

## 13. Sequence diagrams (core flows)

### 13.1 Cold start

```
User → App process
App → DI / Theme / Locale restore
App → Splash
App → NavBar (Explore)
User → interacts with demos / sheets
```

### 13.2 Pay with card

```
User → Pay tab or Explore Pay Balance
User → Expand Stripe method → Pay
App → Stripe sheet
User → Card details → Confirm
App → StripePaymentService
App → Snackbar success/fail
```

### 13.3 Map directions

```
User → Map → category → place
Controller → markers + polyline + activePlace
UI → Directions sheet
User → Start | External | Close
Close → clearDirections()
```

### 13.4 Language change

```
User → language control
App → bottom sheet EN/AR
LanguageController → prefs + Get.updateLocale
UI rebuilds translated strings
```

---

## 14. Feature maturity matrix

| Area | UI | Real backend | Notes |
|------|----|--------------|-------|
| Explore layout | ✅ | ❌ | Static package data |
| AI sheet | ✅ | ❌ | Scripted local reply |
| Currency | ✅ | ❌ | Fixed FX rates |
| Suggestions | ✅ | ❌ | Static tips + snackbars |
| Map browse | ✅ | Partial | Google map only + static POIs |
| Directions | ✅ | ❌ | Fake geometry / open external |
| Chat | ✅ | ❌ | Local memory |
| Stripe card UI | ✅ | Partial | Needs PI backend for full charge |
| Other pay rails | ✅ | ❌ | WhatsApp handoff |
| Language | ✅ | N/A | Local prefs |
| Theme | ✅ | N/A | Local prefs |
| Auth / logout | Shell only | ❌ | Not on main path |
| Notifications | Empty UI | ❌ | |
| Weather | Placeholder | ❌ | |

---

## 15. Recommended next engineering phases

1. **Auth gate** — splash → token check → login / home; wire `AuthController`  
2. **Trip API** — replace Explore statics (booking, schedule, payments, restaurants, weather)  
3. **Chat sockets** — Support / Driver / Splizer real-time (packages already allowed)  
4. **AI** — server-side assistant with booking context  
5. **Maps** — Places + Directions APIs; real device location; Yandex SDK/native if product requires  
6. **FX** — daily rates API for currency calculator  
7. **Stripe** — production PaymentIntent endpoint + webhooks  
8. **Deep links** — push → chat / pay / map place  
9. **Profile APIs** — booking docs, prayer, guide content  

---

## 16. Key file index

| Concern | Path |
|---------|------|
| Entry | `lib/main.dart` |
| DI | `lib/data/helper/get_di.dart` |
| Splash | `lib/views/screen/splash_screen.dart` |
| Shell / tabs | `lib/views/screen/explore/home_pages.dart`, `bottom_nav_bar.dart` |
| Explore | `lib/views/screen/explore/explore_screen.dart` |
| Map | `lib/views/screen/map/map_screen.dart` |
| Inbox | `lib/views/screen/chat/chats_screen.dart` |
| Pay | `lib/views/payouts/payouts.dart` |
| Profile | `lib/views/screen/account/account.dart` |
| Theme | `lib/utils/values/app_theme.dart`, `app_palette.dart` |
| i18n | `lib/data/enus.dart`, `languages.dart` |
| Stripe | `lib/services/stripe_payment_service.dart` |
| Env | `lib/utils/values/env.dart`, `.env` |

---

## 17. Glossary (client language)

| Term | Meaning in Zeengo |
|------|-------------------|
| Guest | Logged-in (or demo) traveler |
| Package | Trip product (e.g. Love Package) |
| Splizer | Trip coordinator / organizer contact |
| Driver | Assigned trip driver chat |
| Support | Zeengo ops / help desk chat |
| Pay Balance | Remaining amount due on package |
| Suggestions | Contextual “what to do now” tips |
| AI Assistant | In-app trip Q&A helper (sheet) |

---

*This document describes the **current client app** as implemented in the Zeengo Flutter repository: a production-shaped UI shell with several live integrations (Maps, Stripe card form, locale/theme) and demo-backed flows ready for API wiring.*
