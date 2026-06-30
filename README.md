# iOS 16 Navigation Showcase 📱✨

A polished, educational iOS 16 SwiftUI showcase project demonstrating native **Coordinator Pattern** navigation combined with modern SwiftUI APIs (`NavigationStack`, `NavigationPath`, and custom presentation sheets/covers).

Built around a lightweight social media demo flow, this application illustrates how to transition cleanly from a splash screen to authentication, manage tab layouts, push content onto a top-level navigation stack, display custom modally-presented surfaces, and route incoming deep links.

---

## 🗺️ Architectural Flow & Navigation Topology

Below is the state transitions and routing topology managed by the centralized coordinator:

```mermaid
flowchart TD
    subgraph Root Switcher (AppCoordinator)
        SplashView[Splash View] -- Delay --> LoginView[Login View]
        LoginView -- Authenticate --> MainTabView[Main Tab View]
    end

    subgraph Main Tab View (Root = .main)
        FeedTab[Feed Tab]
        ExploreTab[Explore Tab]
        ProfileTab[Profile Tab]
    end

    subgraph Top-level NavigationStack (Push Routes)
        PostDetailView[Post Detail View]
        CommentsView[Comments View]
        UserProfileView[User Profile View]
    end

    subgraph Custom Modal Surfaces (AppSurface)
        LoadingOverlay[Loading Overlay]
        ErrorSheet[Error Alert Sheet]
        ForceUpdateSheet[Force Update Sheet]
        SessionExpiredCover[Session Expired Full Screen]
    end

    FeedTab -- Tap Post --> PostDetailView
    ExploreTab -- Tap Post --> PostDetailView
    ProfileTab -- Tap Edit/Post --> PostDetailView
    
    PostDetailView -- Tap Comments --> CommentsView
    PostDetailView -- Tap Author --> UserProfileView
    UserProfileView -- Tap Post --> PostDetailView
    
    %% Deep links route directly
    DeepLink[Incoming Deep Link] -- Resolve URL --> LoadingOverlay
    LoadingOverlay -- Valid --> PostDetailView
    LoadingOverlay -- Invalid --> ErrorSheet
```

---

## 🚀 Key Capabilities Demonstrated

1. **State-Driven Root Switching**: The [AppCoordinator](file:///Users/raf/Development/Swift/Example/iOS16Navigation/iOS16Navigation/Application/Coordinator/AppCoordinator.swift) manages root level transitions (`.splash`, `.login`, `.main`) with custom, asymmetric SwiftUI animations.
2. **Top-Level NavigationStack**: Pushing and popping screens programmatically using SwiftUI's native `NavigationPath` wrapper, keeping individual views isolated from routing details.
3. **Decoupled Link Routing (Deep Linking)**: Resolving URLs (`applink://...` or `https://...`) using a chain of responsibility ([AppLinkHandler](file:///Users/raf/Development/Swift/Example/iOS16Navigation/iOS16Navigation/Application/AppLink/AppLinkHandler.swift)) and executing the transition from any state.
4. **Centralized Presentation Layers**: Dynamically presenting overlay states (loading overlay, error sheet, force updates, and session expiration covers) from anywhere in the application code without nesting localized states.

---

## 📂 Project Structure

```bash
iOS16Navigation/
├── Core/
│   └── Protocol/           # General protocols for navigation, surface, and coordinator
├── Application/
│   ├── Coordinator/       # Concrete implementation of AppCoordinator
│   └── AppLink/            # Chain of responsibility for parsing and resolving deep links
├── Modules/                # UI Modules (Feed, Explore, Comments, Profile, Auth, etc.)
└── Data/                   # Local static mock data (User, Post, Comment)
```

---

## 📖 Deep-Dive Documentation

We have structured the documentation to cover specific aspects of this navigation architecture. Read these guides to understand the mechanics:

*   **[Coordinator & Navigation Stack Architecture](file:///Users/raf/Development/Swift/Example/iOS16Navigation/docs/architecture.md)**: How root switching, standard pushes, and custom route types map to SwiftUI.
*   **[Asynchronous Deep Linking](file:///Users/raf/Development/Swift/Example/iOS16Navigation/docs/deep-linking.md)**: Registering and resolving deep links via the pipeline.
*   **[Modals, Sheets, and Presentation Surfaces](file:///Users/raf/Development/Swift/Example/iOS16Navigation/docs/surfaces.md)**: Managing overlays and sheets from a single coordinator state.

---

## 🛠️ Quick Start (Running the App)

1. Open the project in Xcode 14+ (requires iOS 16 SDK or newer):
   ```bash
   open iOS16Navigation.xcodeproj
   ```
2. Choose a simulator (e.g., iPhone 15 running iOS 16 or 17).
3. Build and Run: Press `⌘ + R`.
4. Test deep linking from the command line while the simulator is running:
   ```bash
   xcrun simctl openurl booted "https://www.example.com/post/p1"
   ```
