# Project Architecture & Folder Structure

We are using **Clean Architecture** to ensure the codebase remains scalable, testable, and modular. The project is divided into features (Module-by-Module approach).

## Clean Architecture Layers (Per Feature)
Each feature will strictly follow these three layers:

1. **Domain Layer (Core Business Logic) - Independent of everything else.**
   - `entities/`: Pure Dart objects representing the business models.
   - `repositories/`: Abstract classes (interfaces) defining how data is manipulated/fetched.
   - `usecases/`: The actual business logic (e.g., `CalculateAttendancePercentage`, `MarkClassAttended`).

2. **Data Layer (Outside world communication)**
   - `models/`: Subclasses of Entities that handle JSON serialization/deserialization (API responses).
   - `datasources/`: Remote (REST API via `dio` or `http`) and Local (Hive/SharedPreferences) data operations.
   - `repositories/`: Actual implementations of the domain repositories.

3. **Presentation Layer (UI and State Management)**
   - `bloc/` or `cubit/` or `providers/`: State management for the feature.
   - `pages/` or `screens/`: UI pages.
   - `widgets/`: Reusable UI components specific to this feature.

## Overall Folder Structure

```text
lib/
├── core/                       # Shared code across the app
│   ├── constants/              # API keys, hardcoded strings, enums
│   ├── error/                  # Failures, Exceptions
│   ├── network/                # Supabase client setup, network info
│   ├── theme/                  # Colors, Typography, AppTheme
│   ├── utils/                  # Helper functions, extensions
│   └── usecases/               # Base usecase interface
├── features/                   # Module-by-Module Features
│   ├── auth/                   # Authentication module
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   ├── profile/                # Year, Branch, Batch selection
│   ├── courses/                # Fetching and displaying courses
│   ├── attendance/             # Marking & calculating attendance
│   └── dashboard/              # Stats and recommendations
├── main.dart                   # Entry point
└── injection_container.dart    # Dependency Injection (GetIt/Riverpod)
```

## Backend Technology Stack
- **Framework**: Spring Boot (Java/Kotlin)
- **Database**: PostgreSQL or MySQL
- **Security**: Spring Security with JWT (JSON Web Tokens)
- **ORM**: Spring Data JPA / Hibernate
- **API Design**: RESTful APIs
