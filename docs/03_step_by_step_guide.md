# Step-by-Step Implementation Guide (Flutter + Spring Boot)

Since you are building both the Frontend (Flutter) and Backend (Spring Boot), we will follow a parallel development approach. Whenever you finish a step, let me know!

## Phase 1: Foundation & Setup
- [ ] **Step 1 (Backend):** Initialize the Spring Boot project via Spring Initializr (Web, JPA, Security, PostgreSQL/MySQL Driver, Lombok). Set up the `application.yml` for DB connection.
- [ ] **Step 2 (Frontend):** Add core dependencies in `pubspec.yaml` (e.g., `dio` or `http`, state management like `flutter_bloc` or `flutter_riverpod`, `get_it`, `shared_preferences`, `go_router`).
- [ ] **Step 3 (Frontend):** Setup the `core/` folder (define custom themes, basic error handling classes `Failure`/`Exception`, network client config like BaseUrl & Interceptors).

## Phase 2: Authentication Module
- [ ] **Step 4 (Backend):** Implement `User` Entity, Repository, and Spring Security configuration.
- [ ] **Step 5 (Backend):** Create JWT Utility classes and `/api/auth/register`, `/api/auth/login` endpoints.
- [ ] **Step 6 (Frontend):** Create `UserEntity` and `UserModel`.
- [ ] **Step 7 (Frontend):** Create Auth Domain (`AuthRepository` interface, `SignIn`, `SignUp`, `SignOut` usecases).
- [ ] **Step 8 (Frontend):** Create Auth Data (`AuthRemoteDataSource` calling Backend REST API via `dio`, saving JWT locally).
- [ ] **Step 9 (Frontend):** Create Auth Presentation (Login Screen, Signup Screen, State Management block forwarding requests).

## Phase 3: Profile & Setup Module
- [ ] **Step 10 (Backend):** Create Entities for `Branch`, `Batch`, and profile associations. Expose endpoints to sync user's degree details `/api/profile`.
- [ ] **Step 11 (Frontend):** Build the UI for a new user to select their Year, Branch, and Batch.
- [ ] **Step 12 (Frontend):** Send this profile data via REST API to Spring Boot and attach it to the current User.

## Phase 4: Courses Module
- [ ] **Step 13 (Backend):** Define a `Course` Entity. Create endpoints to fetch courses specific to a given Year + Branch. Sample Endpoint: `GET /api/courses/my-courses`.
- [ ] **Step 14 (Frontend):** Implement Domain & Data layers to call `GET /api/courses/my-courses` passing the JWT token.
- [ ] **Step 15 (Frontend):** Display courses in a list/grid on the Home Screen.

## Phase 5: Attendance Module (The Core)
- [ ] **Step 16 (Backend):** Create `AttendanceLog` Entity (UserID, CourseID, Status [Present, Bunk, Cancelled], Date). Expose `/api/attendance/mark` and `/api/attendance/history`.
- [ ] **Step 17 (Frontend):** Build the UI to mark attendance (swipes, buttons).
- [ ] **Step 18 (Frontend):** Send `POST` requests to record the attendance to the Spring Boot API. Update local caching/state.

## Phase 6: Dashboard & Recommendations
- [ ] **Step 19 (Backend):** Create analytic endpoints (`/api/stats/dashboard`) that return total classes, percentages, and crunch out predictions (e.g., maximum bunks allowed).
- [ ] **Step 20 (Frontend):** Call the stats endpoint and display an overall attendance percentage pie chart/progress bar.
- [ ] **Step 21 (Frontend):** Build the visually appealing Dashboard UI with predictions ("Safe to bunk next 2 classes") using the backend response.

---
**How to proceed:**
Read through these updated steps. When you are ready, type: *"Let's start Step 1"* and I will guide you with either the Flutter setup or the Spring Boot bootstrapping!
