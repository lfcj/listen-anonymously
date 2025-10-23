#  Listen anonymously

This is an app that allows selecting any file in apps that allow sharing them, such as Whatsapp, Telegram or iMessage, and plays it.
This makes that the app does not consider the file has been opened/listened to and does not show the checkmarks.

## Technology

- This app uses SwiftUI ✅
- It uses UIKit in the extension entry `ActionViewController` because Xcode/Swift do not allow differently yet. 
- It uses UIKit in the snapshots in order to recreate a `UIWindow` when needed. This is because certain UIs such as `Picker` need a window context to render well. ✅
- App is heavily modularized to enhance reusability. The framework `Listen anonymously Shared` could easily be extracted into a package. 
- Strong SOLID development. Examples:
    -   **Single Responsibility Principle:** The main app `Listen anonymously` and the extension `Listen anonymously Ext` have a single responsibility: show front door and instructions, and allow playing the audio, respectively. All re-usable logic is extracted to framework `Listen Anonymously Shared`. A way to further support SRP would be to divide this framework into one for UI and one for non-UI logic.  
    -   **Open/Close Principle:** Especially helpful for tests, most reusable models inside of the framework are kept `open` such that injecting new behavior when testing or producing snapshots is feasible.
    -   **Liskov Substitution Principle:** Replacing is done thanks to protocols such as `DeeplinkVerifying`, and injecting different implementations is actively used via constructors, e.g.: `AudioPlayingView` allows injecting a view model for its audio controller, this allowed recording a snapshot that appeared to have played the audio for 12 seconds.
    -   **Interface Segregation Principle:** WIP as right now it needs more segregation.
    -   **Dependency Inversion Priciples:** The `AudioPlayingManager` hides the low-level implementations of the `AVAudioPlayer`. If it would use a different instantiation logic, or if the player would be a different one in the future, the users of this manager would not notice it.


### Test coverage
- App has >90% test coverage ✅
- SwiftUI views are heavily tested using [`ViewInspector`](https://github.com/nalexn/ViewInspector)). The goal was to have all the logic in view models, modify them, and inspect the view to make sure it displays the modified data accordingly.

## Build based on xcconfig

- Hiding sensitive data such as the `DEVELOPMENT_TEAM` was done using `.xcconfig` files that are local. Manual sign-in was also implemented by using provisioning files.
- Deployment target is also managed in `xcconfig` file in order to avoid having to manually modify the Build Settings of all targets.

## CI
🚧 Goal is to trigger tests builds in GitHub Actions on every push and add status badges to see health of tests + code coverage %.

## ASC Screenshots + automatic framing 
🚧 Goal is to be able to create screenshots for all localizations via command line, as well as frame them with iPhone/iPad bezels.
    
## `fastlane`
🚧 Goal is to be able to submit an app for review via command line.

## Design system
🚧 Goal is to have a framework with design specs in JSON that gets mapped into Swift code. Names are semantic. The goal is to be able to export it to a package and be able to import it to every new private app. This allows homogeneity and consistent branding.

## Q&A

### 1. Why is `AppState` an `EnvironmentObject` and not a `StateObject`.

`AppState` is ideal to pass models that need to reach very deep in the view hierarchy. That allows avoiding each view to pass it along and would make sure that any view can change the `selectedTab`.
