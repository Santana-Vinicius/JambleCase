# JambleCase

A **seller profile screen** built as a take-home interview challenge for Jamble. The app renders a marketplace seller's profile with live shows, reviews, and saved items — powered entirely by local mock data with multiple switchable scenarios.

---

## Requirements

| Tool | Version |
|------|---------|
| **Xcode** | 26.0+ |
| **iOS Deployment Target** | 26.0 |
| **Swift** | 5.0 (with Swift 6 concurrency settings enabled) |

No external dependencies — the project uses only Apple system frameworks (SwiftUI, Combine, Foundation).

## Setup

1. Clone the repository.
2. Open `JambleCase.xcodeproj` in Xcode.
3. Select a simulator or device and press **Cmd + R** to build and run.
4. To run the test suite, press **Cmd + U**.

That's it — no package resolution, no API keys, no backend.

---

## Switching Mock Scenarios

The app ships with three mock data scenarios that exercise different UI states. To switch between them:

1. Navigate to the **Profile** tab (last tab in the bottom bar).
2. Tap the **gear icon** (top-right corner of the profile header).
3. A confirmation dialog appears showing the current scenario and all available options.
4. Select a scenario — the entire profile reloads with the new data.

| Scenario | Description |
|----------|-------------|
| **Top Seller** | Full profile with multiple lives, reviews, and bookmarks |
| **New Seller** | Minimal profile — fewer lives, reviews, and bookmarks |
| **Empty Lives** | Profile with no live shows, triggering the empty state UI |

---

## Pull-to-Refresh

The profile screen supports **pull-to-refresh** via SwiftUI's `.refreshable` modifier. The refresh is **context-aware** — it only reloads the data for the currently selected tab:

| Active Tab | What refreshes |
|------------|----------------|
| **Lives** | Re-fetches the list of live shows |
| **Reviews** | Re-fetches the reviews |
| **Saved** | Re-fetches the bookmarked items |

Pull down anywhere on the scrollable content to trigger it. The standard iOS spinner appears at the top and dismisses automatically once the async reload completes.

Tabs can also be navigated by **swiping horizontally** on the tab content area — swipe left to advance, swipe right to go back.

---

## Demo

| Scenario | Reference |
|----------|-------|
| **Top Seller** | <img width="300" alt="Top Seller" src="https://github.com/user-attachments/assets/e5ad90b8-c611-49e3-af71-6f3b93936087" /> |
| **New Seller** | <img width="300" alt="New Seller" src="https://github.com/user-attachments/assets/4e46053e-4cad-4504-8fdb-21a2563ab8d6" /> |
| **Empty Lives** | <img width="300" alt="Empty Lives" src="https://github.com/user-attachments/assets/5c39a6d9-60d0-4ff8-bbda-1114de437c2e" /> |
| **Pull-to-Refresh** | <img width="300" alt="Pull to Refresh" src="https://github.com/user-attachments/assets/9c67b901-1bb5-4295-bc67-4a392d248038" /> |
| **Scenario Switching** | <img width="300" alt="Scenario Switching" src="https://github.com/user-attachments/assets/985bedb5-afa5-4b81-8393-830c80271802" /> |
| **Tab Swiping** | <img width="300" alt="Tab Swiping" src="https://github.com/user-attachments/assets/a570b062-3c85-4dc0-8271-2e6cede3a0ae" /> |

---

## Architecture

The project follows **MVVM** with a **Clean Architecture**-inspired layered structure. Each layer communicates through protocols, making every component independently testable.

```
┌─────────────────────────────────────────────────────────┐
│                        View Layer                       │
│  SwiftUI Views (ProfileView, LivesContentView, etc.)    │
│  Observes ViewModels via @ObservedObject / @StateObject  │
└──────────────────────────┬──────────────────────────────┘
                           │ binds to
┌──────────────────────────▼──────────────────────────────┐
│                     ViewModel Layer                      │
│  ProfileViewModel, LivesContentViewModel, etc.           │
│  @Published state · async/await · Combine                │
└──────────────────────────┬──────────────────────────────┘
                           │ calls
┌──────────────────────────▼──────────────────────────────┐
│                   Domain / Service Layer                  │
│  ProfileServiceProtocol → ProfileService                 │
│  Business logic, DTO mapping, error translation          │
└──────────────────────────┬──────────────────────────────┘
                           │ calls
┌──────────────────────────▼──────────────────────────────┐
│                       Data Layer                         │
│  ProfileRepositoryProtocol → ProfileRepository           │
│  ProfileDataSourceProtocol → MockProfileDataSource       │
│  JSON loading, simulated delay, error injection          │
└─────────────────────────────────────────────────────────┘
```

### Dependency Injection

`AppDependencies` acts as a simple composition root — it wires concrete implementations behind protocols and provides a `makeProfileViewModel()` factory. No DI framework is used; the graph is small enough that manual wiring stays readable.

### Project Structure

```
JambleCase/
├── JambleCaseApp.swift              # App entry point
├── ContentView.swift                # Root view
├── MainTabView.swift                # Bottom tab bar (Live, Rewards, Activity, Profile)
├── AppDependencies.swift            # Composition root / DI container
│
├── Data/
│   ├── DataSources/
│   │   ├── Mock/                    # Mock data source, config, scenario manager, JSON loader
│   │   └── Protocols/               # ProfileDataSourceProtocol
│   ├── Models/Responses/            # Codable response types (ProfileResponse, etc.)
│   └── Repositories/               # ProfileRepository + protocol
│
├── Domain/
│   ├── Models/Errors/               # DataSourceError, DataLayerError
│   ├── Services/                    # ProfileService + protocol
│   └── Utilities/                   # DateFormatter extensions
│
├── Profile/
│   ├── Model/                       # UI DTOs (ProfileDTO, LiveItemDTO, ReviewItemDTO, etc.)
│   ├── View/                        # SwiftUI views (ProfileView, TabBarView, cards, skeletons)
│   └── ViewModel/                   # ViewModels (ProfileViewModel, LivesContentViewModel, etc.)
│
└── Resources/
    └── MockData/                    # JSON files per scenario
```

---

## Tradeoffs and Design Decisions

### Mock-only data layer

The entire data layer runs on local JSON files instead of a real API. This was intentional — the challenge scope is the UI and architecture, not networking. The `ProfileDataSourceProtocol` abstraction means swapping in a real API client later requires zero changes above the data layer.

### MockDataSourceConfig for testability

The mock data source accepts a `MockDataSourceConfig` that controls simulated delay, error rate, and error types. This makes it straightforward to test loading states, skeleton screens, and error handling without flaky timing hacks — just set `shouldSimulateDelay: false` and `errorRate: 0.0` in tests.

### Combine for tab selection, async/await for data

Tab selection uses a `PassthroughSubject` with `.removeDuplicates()` to debounce redundant taps. Data fetching uses `async/await` for clarity. Mixing the two is a conscious choice: Combine pipelines shine for UI event streams, while structured concurrency is more readable for request/response flows.

### DTOs at every boundary

Response models (`ProfileResponse`, etc.) map into domain DTOs (`ProfileDTO`, etc.) at the service layer. This adds a mapping step, but it decouples the UI from the backend contract — if the API shape changes, only the mapping code needs updating.

### Protocol-driven design

Every layer boundary is defined by a protocol (`ProfileDataSourceProtocol`, `ProfileRepositoryProtocol`, `ProfileServiceProtocol`). This adds a small amount of boilerplate but pays off in tests — each layer can be tested in isolation with lightweight mocks.

### No external dependencies

The project intentionally avoids third-party libraries. SwiftUI, Combine, and Swift concurrency cover all requirements. This keeps the build fast and avoids version-pinning friction during review.

### Swift Testing over XCTest

Tests use Swift Testing (`@Test`, `#expect`) instead of XCTest. It's the modern standard, reads more naturally, and provides better failure diagnostics.

### Skeleton screens over spinners

Loading states render skeleton views with a shimmer animation rather than a generic spinner. This gives a smoother perceived performance and makes the UI feel faster, at the cost of maintaining skeleton layout parity with real content.

---

## Tests

The test suite covers every layer from data source to ViewModel:

| Layer | Tests |
|-------|-------|
| **DataSource** | JSON loading per scenario, scenario manager switching |
| **Repository** | Delegation to data source, error propagation |
| **Service** | DTO mapping, business logic (sorting, formatting) |
| **ViewModel** | Loading/error/success states, refresh behavior |

Run all tests with **Cmd + U** in Xcode or via the command line:

```bash
xcodebuild test -project JambleCase.xcodeproj -scheme JambleCase -destination 'platform=iOS Simulator,name=iPhone 16'
```
