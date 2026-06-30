# iOS16Navigation Social Showcase Design

## Goal

Complete the example app as a polished iOS 16 SwiftUI navigation showcase built around a small social app demo. The finished sample should clearly demonstrate:

- root switching between splash, login, and main app
- tab-based navigation
- push navigation with `NavigationStack`
- sheets, full-screen covers, and floating overlays
- deep-link routing into meaningful destinations
- a cohesive, demo-friendly UI instead of placeholder screens

## Scope

The sample will remain intentionally small and use only in-memory data. It is not intended to model production networking, persistence, or authentication. The focus is a readable example project that shows how the existing coordinator and navigation abstractions can power a realistic app flow.

## Product Direction

The app will simulate a small social network with balanced emphasis on navigation and modal surfaces.

Visual direction:

- polished showcase sample
- Apple-native SwiftUI styling
- lightweight custom presentation through cards, sections, and clearer hierarchy

## User Experience

### Root Flow

The app starts on a branded splash screen, transitions into a simple login screen, and then enters the main tab experience.

The coordinator remains responsible for root changes:

- `splash`
- `login`
- `main`

### Main App Tabs

The main tab bar will contain:

- `Feed`: featured and recent posts
- `Explore`: discovery content and deep-link examples
- `Profile`: signed-in user overview and shortcuts

These tabs are the primary browsing surfaces. Push destinations still occur through the existing top-level `NavigationStack` in the main root.

### Push Destinations

The showcase will use social semantics instead of the current product/review naming. The route model should be renamed accordingly for clarity.

Primary pushed screens:

- `postDetail(id:)`
- `comments(postID:)`
- `profile(username:)`

Behavior expectations:

- tapping a post from `Feed` or `Explore` pushes post detail
- tapping comments from post detail pushes comments
- tapping an author avatar or profile affordance pushes that user profile

### Surface Demonstrations

The app must visibly demonstrate all current surface mechanisms:

- floating overlay: loading while a deep link resolves
- sheet: error handling for invalid or unsupported links
- sheet: force update example triggered from a debug/demo control
- full-screen cover: session expired flow triggered from a debug/demo control

Bottom sheet support can remain present in infrastructure, but no dedicated bottom-sheet showcase is required unless implementation reveals a natural small demo for it.

## Content Model

The project will add a small in-memory sample data layer.

Entities:

- `User`
- `Post`
- `Comment`

Data characteristics:

- a handful of users with usernames, names, and short bios
- a small list of posts with author, title, body/snippet, like count, comment count, and lightweight tags/metadata
- comments grouped by post

The data source should be static, local, and easy to read. No async networking abstraction is required.

## Screen Responsibilities

### SplashView

- show simple branded intro state
- automatically advance to login after a short delay
- avoid heavy logic in the view; any root transition should stay coordinator-driven

### LoginView

- show a simple demo login presentation
- primary CTA enters the main app
- secondary copy can make it explicit that this is an example flow

### MainTabView

- own tab selection only
- render the three main tabs
- expose demo controls naturally within screens instead of centralizing everything in a single debug panel

### Feed Screen

- show featured content plus a recent posts list
- provide clear entry into post detail
- optionally include one or two visible shortcuts to profiles or comments

### Explore Screen

- show discovery content using the same sample data
- include explicit deep-link demo actions so users can trigger valid and invalid routes from within the app

### Profile Screen (signed-in tab)

- show the current demo user
- show recent posts or profile actions
- include demo controls for session expiration and force update presentation

### Post Detail Screen

- show full post content
- show author summary
- include actions for comments and author profile
- optionally show related posts using the existing `Related` module if it fits cleanly

### Comments Screen

- show comments for the selected post
- preserve the small-sample nature of the app rather than building a full reply composer

### User Profile Screen

- show another user profile, bio, and recent posts
- allow navigation into one of their posts if useful

### Error / Force Update / Session Expired / Loading Views

These views should become real demo surfaces with concise copy and clear actions:

- `ErrorView`: explain that the deep link could not be resolved and allow dismissal
- `ForceUpdateView`: present a static update prompt with dismiss or simulated app-store CTA
- `SessionExpiredView`: allow returning to login/root reset
- `LoadingOverlayView`: show an unobtrusive overlay centered on content

## Architecture

### Keep Existing Core Infrastructure

Retain:

- `AppCoordinator`
- `AppNavigation`
- `AppSurface`
- `CoordinatorProtocol`
- deep-link handler abstraction

This project already has the right structural pieces; the work is to complete and connect them.

### Coordinator Responsibilities

`AppCoordinator` remains the single orchestration point for:

- selecting the current root
- pushing and replacing navigation routes
- presenting and dismissing surfaces
- handling incoming URLs and applying destinations

It should also expose small intent methods for the UI to call, such as:

- entering the app from splash/login
- opening a post
- opening comments
- opening a profile
- presenting force update
- presenting session expired
- dismissing or resetting from terminal states

The exact method names can be chosen during implementation, but the intent surface should be explicit so views do not manipulate navigation state directly unless already appropriate.

### Route Renaming

The existing routes:

- `productDetail`
- `review`
- `profile`

should be updated to social-demo names for clarity. This is an example app, so readability is more important than preserving placeholder terminology.

### View Composition

Views should stay lightweight and primarily render data. Sample-data lookups can happen in a straightforward way for this example. There is no need to introduce full view-model layers unless a specific screen becomes difficult to read.

## Deep Linking

Deep-link support should demonstrate successful navigation and graceful failure.

Supported examples:

- post detail link
- comments link
- profile link

Possible example URL patterns:

- `https://www.example.com/post/<id>`
- `https://www.example.com/post/<id>/comments`
- `https://www.example.com/profile/<username>`

Deep-link behavior:

- valid post link routes to main root then pushes post detail
- valid comments link routes to main root then pushes post detail followed by comments when needed, or pushes comments directly if the route structure stays simpler
- valid profile link routes to main root then pushes profile
- invalid or unsupported link presents the error sheet
- link resolution briefly shows the loading overlay before navigation completes

The existing handler abstraction is sufficient; it should simply be extended with additional handlers or logic for the new routes.

## Error Handling

Error handling should stay simple and visible:

- unsupported links map to the error sheet
- invalid content identifiers can either route to the error sheet or show a safe fallback empty state on the target screen
- demo control flows should always end in a recoverable state

No complex logging or analytics layer is needed.

## Testing

Add focused unit coverage where it best protects the demo behavior:

- deep-link handler resolution for supported URLs
- deep-link handler failure for unsupported or malformed URLs
- coordinator application of resolved destinations to root and navigation stack

UI testing is optional and should remain minimal. If any UI test is added, it should verify only a central happy path rather than attempt exhaustive coverage.

## Non-Goals

Do not add:

- networking
- persistence
- real authentication
- backend integration
- a large design system
- per-tab independent navigation stacks

Those choices would make the example heavier without improving its core teaching value.

## Implementation Notes

The implementation should prefer the smallest correct changes:

- keep most logic in existing files unless extraction clearly improves readability
- use static sample data
- reuse existing module files where practical
- remove placeholder `Hello, World!` content in favor of meaningful demo UI

## Success Criteria

The project is complete when:

- the app launches into a coherent splash -> login -> main flow
- all major screens are real demo screens, not placeholders
- feed/explore/profile tabs feel intentional and navigable
- post detail, comments, and user profile flows work end to end
- deep links can open supported destinations and show failure states for bad links
- loading, error, force update, and session-expired presentations are all demonstrable from the running app
- the code remains small, readable, and clearly educational
