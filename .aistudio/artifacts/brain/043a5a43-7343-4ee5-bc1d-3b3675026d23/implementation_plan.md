# System: Sci-Fi Hunter Life Gamification App

A high-performance gamified life-leveling application inspired by the "Hunter System" HUD aesthetic. System transforms daily fitness, study, work, hobbies, and financial discipline into real-life RPG progression with animated XP bars, Hunter Ranks (E to S-Rank), daily quests, deadline penalty timers, and an adaptive multi-provider AI coach.

### User Review & Critical Decisions

> [!IMPORTANT]
> **Key Architecture Decisions Confirmed**:
> - **Platform & Technology:** Native Android with Jetpack Compose is being built in this cloud environment for instant in-browser preview and direct APK export for mobile testing. The Clean Architecture data contracts and Firestore security rules will remain directly portable to Flutter if you later expand to iOS/macOS.
> - **Visual Aesthetic:** Sci-Fi Hunter HUD with holographic cyan/purple glow, glowing Hunter Rank emblems (E to S-Rank), animated XP bars, and stat attribute grids (STR, AGI, INT, VIT, SEN, FOR), supporting both Dark and Light themes.
> - **Backend & Persistence:** Firebase Auth (Google Sign-In via Android Credential Manager) and Firebase Firestore for real-time cloud sync, multi-device backup, and offline caching.
> - **AI Strategy:** Gemini 2.5 Flash as the primary high-speed, low-token engine, with an in-app fallback router supporting secondary API keys (OpenAI / Groq) if rate limits or network errors occur.

---

### 1. Overview & Core Concept

- **What It Does:** System monitors daily habits, workouts, study sessions, hobbies, and personal finances as real-world RPG "Quests" and "Dungeons". Users gain Experience Points (XP), increase their Hunter Rank (E → D → C → B → A → S → Monarch), level up their core attributes, maintain daily streaks, and face deadline countdown timers with accountability penalties.
- **Target Audience / Persona:** Self-improvement enthusiasts, gamers, students, and professionals who want to replace boring to-do lists with a gamified productivity engine that delivers visceral visual dopamine and real-life accountability.
- **Key Value:** Transforms mundane daily routines into an engaging progression system with high-precision AI guidance, zero-latency local-first responsiveness, and secure cloud synchronization.

---

### 2. User Experience & Visual Design

#### Key User Flows
1. **System Awakening (Onboarding Flow):**
   - Clean, focused intake collecting essential calibration data: Nickname, Age, Gender, Height, Weight, Primary Life Focus (Fitness, Career, Academics, Creative), Daily Goals, and Financial budget targets.
   - Initial Hunter Rank assessment generating the user's initial Hunter Status Card (E-Rank Hunter) and customized Daily Quest Log.
2. **Hunter Status Dashboard (Main HUD):**
   - Holographic header showing Level, Current Rank Badge (E through S), Title (e.g. "Novice Awaked", "Shadow Sovereign"), and smooth animated XP progress bar.
   - Hexagonal/Grid Stat Matrix:
     - **STR (Strength):** Fitness, gym, lifting, cardio, steps.
     - **AGI (Agility):** Routine consistency, morning habits, daily hygiene.
     - **INT (Intelligence):** Deep work, reading, study sessions, coding.
     - **VIT (Vitality):** Sleep duration, hydration, clean nutrition.
     - **SEN (Perception/Sense):** Meditation, focus time, mindfulness.
     - **FOR (Fortune):** Savings goals, budget discipline, expense tracking.
3. **Daily Quest Board & Deadline Accountability:**
   - Active Quests categorized into Daily Quests (e.g. "100 Pushups", "2 Hours Deep Study"), Weekly Challenges, and Urgent Boss Raids (Deadlines).
   - Real-time countdown deadline timers with visual danger states (Cyan → Amber → Crimson pulse).
   - "Dungeon Focus Mode" (Pomodoro-style hunter timer with visual aura to lock in focus).
4. **AI Quest Architect & Optimizer:**
   - On-demand AI evaluation of progress and intelligent daily quest generation tailored to the user's goals.
   - Ultra-compact prompt engineering using structured JSON schemas to minimize token usage while delivering instant feedback.
5. **System Settings & AI Provider Switcher:**
   - Toggle between Hunter Void (Dark) and Research Lab (Light) themes.
   - AI Provider Selector: Gemini 2.5 Flash (Default) with optional backup fields for OpenAI or Groq API keys with automated health check and fallback status.
   - Google Account profile & Cloud Sync status indicator.

#### Visual Identity & Theme
- **Dark Theme (Hunter Void HUD):**
  - Background: Deep Obsidian `#090C10` and Space Slate `#0D1117`.
  - Hologram Accents: Electric Cyan `#00F0FF`, Neon Azure `#0099FF`, and Void Violet `#8A2BE2`.
  - Warning/Alert: Hunter Crimson `#FF0055` and Hazard Amber `#FFB703`.
  - Surface: Semi-transparent frosted cards with 1dp neon borders and subtle glow highlights.
- **Light Theme (Research Lab HUD):**
  - Background: Clean Pristine Slate `#F5F7FA` and Frost White `#FFFFFF`.
  - Accents: Deep High-Contrast Cyber Blue `#0066CC` and Indigo Slate `#3B4252`.
  - Clear, readable typography maintaining sharp contrast and accessible touch targets (minimum 48dp).
- **Typography:** Bold futuristic monospace/geometric numbers for levels, stats, and timers; clean sans-serif for quest descriptions and notes.
- **Motion & Micro-Interactions:** Spring-physics XP fill bars, rank promotion banner modal with haptic vibration, and quest completion checkmark burst particles.

---

### 3. Key Product Decisions & Trade-Offs

#### 1. Tech Stack: Native Android (Kotlin + Jetpack Compose) vs Flutter
- **Chosen Approach:** Build the production-grade application natively in Kotlin with Jetpack Compose in this AI Studio environment.
- **Why:**
  - The AI Studio workspace is optimized for native Android builds with immediate streaming emulator feedback and direct one-click APK generation.
  - Native Jetpack Compose provides unmatched 60/120 FPS hardware acceleration for animated XP meters, canvas particle effects, low-level AlarmManager notifications for deadline accountability, and zero-bridge overhead.
  - The project will be architected with strict Clean Architecture (separate Data, Domain, and UI layers), making subsequent translation of data models and Firestore schemas to Flutter straightforward if expanding to iOS later.
- **Alternative Considered:** Flutter is not supported in this container environment and would prevent instant browser testing and live APK builds.

#### 2. Persistence & Auth: Firebase Firestore + Google Sign-In
- **Chosen Approach:** Firebase Firestore backed by Google Sign-In via Jetpack Credential Manager.
- **Why:**
  - Guarantees seamless multi-device cloud synchronization, zero user data loss upon reinstall, and enterprise-grade zero-trust security rules (`request.auth.uid == userId`).
  - Firestore's built-in offline cache ensures instant app startup and full offline functionality even without active cellular or Wi-Fi connectivity.
  - Google Sign-In via Credential Manager is native, secure, and requires zero password management.

#### 3. Multi-Provider AI Fallback Router
- **Chosen Approach:** Client-side Adaptive AI Dispatcher with Gemini 2.5 Flash as the primary provider, routing to Groq or OpenAI upon rate limit (HTTP 429) or connection failure.
- **Why:**
  - Gemini 2.5 Flash delivers state-of-the-art reasoning with sub-second response times and token costs that are a fraction of older legacy models.
  - Fallback routing prevents interruptions during LinkedIn demos or daily usage if a provider experiences temporary outages or quota exhaustion.
  - Schema compression: Prompts use dense key-value inputs (`{str: 14, agi: 12, missed_quests: 1}`) rather than verbose prose, reducing token cost by over 70%.

---

### 4. Technical Architecture & Data Strategy

#### System Architecture Diagram

```
┌────────────────────────────────────────────────────────────────────────┐
│                        Jetpack Compose UI (HUD)                        │
├──────────────────┬──────────────────┬─────────────────┬────────────────┤
│  Hunter Status   │   Quest Board    │  Dungeon Timer  │  AI Architect  │
│  (XP/Ranks/Stats)│ (Daily/Deadlines)│ (Focus/Pomodoro)│  (System Coach)│
└────────┬─────────┴────────┬─────────┴────────┬────────┴────────┬───────┘
         │                  │                  │                 │
┌────────▼──────────────────▼──────────────────▼─────────────────▼────────┐
│                        SystemViewModel / StateFlow                      │
├─────────────────────────────────────────────────────────────────────────┤
│ - Current Hunter Profile (Rank, Level, XP, Attributes)                  │
│ - Active Quests & Deadline Timers                                       │
│ - Theme Mode (Hunter Void Dark vs Research Lab Light)                   │
│ - AI Provider Configuration (Active Provider, Fallback Status)          │
└────────┬─────────────────────────────────────┬──────────────────────────┘
         │                                     │
┌────────▼───────────────┐           ┌─────────▼──────────────────────────┐
│  Firebase Data Layer   │           │      Adaptive AI Dispatcher        │
├────────────────────────┤           ├────────────────────────────────────┤
│ - CredentialManager    │           │ [Primary] Gemini 2.5 Flash REST    │
│ - Firestore Cloud Sync │           │   │ (HTTP 429 / Error Fallback)    │
│ - Users / Quests / Logs│           │ [Backup]  Groq / OpenAI API Client │
└────────┬───────────────┘           └────────────────────────────────────┘
         │
┌────────▼───────────────┐
│ Cloud Firestore (Auth) │
└────────────────────────┘
```

#### Firestore Data Model Schema
- `/users/{userId}`:
  - `nickname`: String
  - `hunterRank`: String ("E", "D", "C", "B", "A", "S")
  - `level`: Number
  - `currentXp`: Number
  - `requiredXp`: Number
  - `streakDays`: Number
  - `attributes`: Map (`strength`, `agility`, `intelligence`, `vitality`, `perception`, `fortune`)
  - `onboardingCompleted`: Boolean
  - `createdAt`: Timestamp
  - `updatedAt`: Timestamp
- `/users/{userId}/quests/{questId}`:
  - `title`: String
  - `category`: String ("FITNESS", "STUDY", "WORK", "HOBBY", "FINANCE")
  - `attributeTarget`: String ("STR", "INT", "AGI", etc.)
  - `xpReward`: Number
  - `deadline`: Timestamp?
  - `isCompleted`: Boolean
  - `completedAt`: Timestamp?
  - `isUrgent`: Boolean
- `/users/{userId}/dungeon_sessions/{sessionId}`:
  - `title`: String
  - `durationMinutes`: Number
  - `completedAt`: Timestamp

#### Multi-Provider AI Fallback Pipeline
1. **Request Formulation:** System compresses user stats, target goals, and recent activity into a structured JSON prompt.
2. **Attempt Primary (Gemini 2.5 Flash):** Sends request via Retrofit with 30s timeout.
3. **Automated Fallback Trigger:** If response is rate-limited (HTTP 429), unavailable (HTTP 503), or times out, the router automatically checks if the user configured a secondary key (OpenAI or Groq) and dispatches the request with identical payload specifications.
4. **Result Ingestion:** Parses the structured JSON quest recommendation or progress appraisal and commits verified XP adjustments directly to the user's Firestore document.

---

### Implementation Phases

1. **Phase 1: Project Setup & Firebase Provisioning**
   - Execute `set_up_firebase` tool handshake with `userConfirmedTermsAcceptedInUI: false` then `true` for Firestore.
   - Configure `firebase-blueprint.json` and strict zero-trust `firestore.rules`.
   - Setup Google Sign-In with Android Credential Manager.
2. **Phase 2: Hunter HUD Design System & Theming**
   - Implement Cyber Void Dark and Research Lab Light color palettes, typography, and glowing card containers.
   - Build custom animated XP progress bars, Rank badge icons (E to S-Rank), and attribute radar/matrix tiles.
3. **Phase 3: Core Domain Models & Firestore Data Repository**
   - Build `UserRepository` and `QuestRepository` with real-time Flow snapshots.
   - Implement Level Up calculation algorithm with exponential XP curve and attribute point allocation.
4. **Phase 4: Quest System & Focus Dungeon Countdown Timers**
   - Create interactive quest checklist with completion animations and XP rewards.
   - Build active deadline countdown timers with visual urgency warnings.
   - Build Pomodoro / Dungeon Focus timer for study and work sessions.
5. **Phase 5: Adaptive Multi-Provider AI Coach & Settings**
   - Implement Retrofit client for Gemini 2.5 Flash with structured JSON output.
   - Implement secondary provider fallback handler (OpenAI/Groq compatible REST endpoints).
   - Create Settings UI with theme switcher, API key management, and cloud backup status.
6. **Phase 6: Verification & Compilation**
   - Run `compile_applet` to verify clean compilation, dependency resolution, and runtime readiness.
