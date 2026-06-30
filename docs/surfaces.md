# Modals, Sheets, and Presentation Surfaces

This document describes how **iOS16Navigation** manages modal presentations, overlay views, and auxiliary dialog sheets.

---

## 🎭 The Need for a Dedicated Surface Layer

In SwiftUI, presenting a sheet or full-screen cover typically requires declaring localized state variables (e.g. `@State private var isShowingSheet = false`) inside the view hierarchy. This works for isolated UI elements, but breaks down when:
1.  **Global Events occur**: Authentication expiration, network errors, or deep-linking loading overlays must be triggered from background tasks or remote notifications.
2.  **State Pollution**: Keeping sheet variables on every screen causes visual bloat and duplication.

To solve this, the project segregates the **Navigation Stack** (standard pushes) from the **Surface Layer** (temporary modals and overlays) using a dedicated surface manager.

---

## 🛠️ Infrastructure: `SurfaceProtocol` & `AppSurface`

Located in [Core/Protocol/SurfaceProtocol.swift](file:///Users/raf/Development/Swift/Example/iOS16Navigation/iOS16Navigation/Core/Protocol/SurfaceProtocol.swift), the `AppSurface` class maintains the active routes for four presentation modes:

```swift
@MainActor
public protocol SurfaceProtocol: AnyObject {
    associatedtype SurfaceRoute: Hashable

    var sheet: SurfaceRoute? { get set }
    var fullScreen: SurfaceRoute? { get set }
    var bottomSheet: SurfaceRoute? { get set }
    var floating: SurfaceRoute? { get set }
    ...
}
```

By separating these properties, the app can display multiple layers concurrently (e.g., showing a floating loading overlay *above* an active sheet).

---

## 🎛️ Presentation Styles & Concrete Routes

The application defines concrete presentation options via the `AppSurfaceRoute` enum inside [AppCoordinator](file:///Users/raf/Development/Swift/Example/iOS16Navigation/iOS16Navigation/Application/Coordinator/AppCoordinator.swift):

```swift
enum AppSurfaceRoute: Hashable {
    case loading
    case error
    case forceUpdate
    case sessionExpired
}
```

These routes are rendered as follows:

| Mode | Route Option | View Triggered | Description |
| :--- | :--- | :--- | :--- |
| **Floating** | `.loading` | [LoadingOverlayView](file:///Users/raf/Development/Swift/Example/iOS16Navigation/iOS16Navigation/Modules/Other/LoadingOverlayView.swift) | Block user interaction during asynchronous operations (e.g. deep link resolution). |
| **Sheet** | `.error` | [ErrorView](file:///Users/raf/Development/Swift/Example/iOS16Navigation/iOS16Navigation/Modules/Other/ErrorView.swift) | Display error info if a deep link fails. |
| **Sheet** | `.forceUpdate` | [ForceUpdateView](file:///Users/raf/Development/Swift/Example/iOS16Navigation/iOS16Navigation/Modules/Other/ForceUpdateView.swift) | Urges the user to update the app. |
| **Full Screen** | `.sessionExpired` | [SessionExpiredView](file:///Users/raf/Development/Swift/Example/iOS16Navigation/iOS16Navigation/Modules/Other/SessionExpiredView.swift) | Full-screen takeover reset that logs out the user on demand. |

---

## ⚙️ SwiftUI Integration & Bindings

In [ContentView.swift](file:///Users/raf/Development/Swift/Example/iOS16Navigation/iOS16Navigation/Application/ContentView.swift), the presentation properties are bound to SwiftUI view modifiers via custom `Binding<Bool>` closures:

```swift
rootView
    .sheet(isPresented: sheetBinding) {
        if let route = surface.sheet {
            sheetView(for: route)
        }
    }
    .fullScreenCover(isPresented: fullScreenBinding) {
        if let route = surface.fullScreen {
            fullScreenView(for: route)
        }
    }
    .overlay {
        if let route = surface.floating {
            floatingView(for: route)
        }
    }
```

### Dynamic Bindings (Write-back Support)
To support native gesture dismissal (like dragging a sheet down), the bindings update the coordinator's state when SwiftUI dismisses them:

```swift
private var sheetBinding: Binding<Bool> {
    Binding(
        get: { surface.sheet != nil },
        set: { isPresented in 
            if !isPresented { 
                surface.dismissSheet() 
            } 
        }
    )
}
```

---

## 🚀 Triggering Surfaces

Views invoke coordinator methods to show surfaces, removing presentation state from the view layer:

```swift
// In ProfileView.swift
@EnvironmentObject private var coordinator: AppCoordinator

Button("Simulate Session Expiry") {
    coordinator.presentSessionExpired()
}
```

The coordinator updates the state:

```swift
// In AppCoordinator.swift
func presentSessionExpired() {
    surface.presentFullScreen(.sessionExpired)
}
```
This updates `surface.fullScreen` to `.sessionExpired`, which instantly triggers the fullscreen cover overlay in `ContentView`.
