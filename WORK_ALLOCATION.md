# Work Allocation & Contribution Guide

## 🎯 Goal
To allow multiple friends to contribute to the **Solo Leveling System** simultaneously without code conflicts.

## 🌿 Git Workflow
1.  **Never push to `main` directly.**
2.  Create a new branch for your feature:
    -   `git checkout -b feature/your-feature-name`
3.  Commit your changes:
    -   `git commit -m "feat: added new guild logic"`
4.  Push and create a Pull Request (PR).

## 🛠 Assigned Work Areas

### 1. Backend: Stability & Testing (Friend A)
**Focus**: Making the core system robust.
-   **Directory**: `backend/src/`
-   **Tasks**:
    -   [ ] **Unit Tests**: Add tests for `AuthService` and `UsersService`.
    -   [ ] **Rate Limiting**: Implement API throttling (prevent spam).
    -   [ ] **Logging**: Add a request logger.

### 2. Frontend: Quest Features (Friend B)
**Focus**: Connecting the Quest UI to the backend.
-   **Directory**: `system/lib/features/quests/`
-   **Tasks**:
    -   [ ] **Quest List**: Create a UI to verify/complete daily quests.
    -   [ ] **API Integration**: Connect to `GET /quests`.
    -   [ ] **CheckBox Logic**: Call `POST /quests/:id/complete`.

## 🔮 Future Features (Grab these if you're done!)

### 🏰 Guilds / Party System
-   **Backend**: `backend/src/guilds/` (See README inside)
-   **Frontend**: `system/lib/features/guilds/` (See README inside)

### 🏆 Leaderboards
-   **Backend**: `backend/src/leaderboard/` (See README inside)
-   **Frontend**: `system/lib/features/leaderboard/` (See README inside)
