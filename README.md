#  Listen anonymously

[![All tests](https://github.com/lfcj/listen-anonymously/actions/workflows/code-coverage.yml/badge.svg)](https://github.com/lfcj/listen-anonymously/actions/workflows/code-coverage.yml)
[![Coverage](https://codecov.io/gh/lfcj/listen-anonymously/branch/main/graph/badge.svg)](https://codecov.io/gh/lfcj/listen-anonymously)

This is an app that allows listening anonymously to voice recordings in Whatsapp, Telegram or iMessage.
The app does not notice that the recording was listened to and does not show the checkmarks.

## Quick snapshot

Here is what the app does and how it looks:

[![Listen anonymously](https://markdown-videos-api.jorgenkh.no/url?url=https%3A%2F%2Fwww.youtube.com%2Fwatch%3Fv%3D9Dk3CZHV0aM)](https://www.youtube.com/watch?v=9Dk3CZHV0aM)

## Screenshots

Screenshots are captured for all supported localizations using the `Listen-anonymously-Snapshot-Tests` unit test target and framed with `frameit`. The framing configuration     lives in `fastlane/Framefile.json`, and each locale has its own `keyword.strings` and `title.strings` in `fastlane/screenshots/<locale>/`.

| Front Door | Instructions | Now Playing |
|:-:|:-:|:-:|
| ![Front Door](fastlane/screenshots/en-US/03_screenshot_framed.png) | ![Instructions](fastlane/screenshots/en-US/02_screenshot_framed.png) | ![Now Playing](fastlane/screenshots/en-US/01_screenshot_framed.png) |

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

[![Coverage](https://codecov.io/gh/lfcj/listen-anonymously/branch/main/graph/badge.svg)](
https://codecov.io/gh/lfcj/listen-anonymously
)

- App has >90% test coverage ✅
- SwiftUI views are heavily tested using [`ViewInspector`](https://github.com/nalexn/ViewInspector). The goal was to have all the logic in view models, modify them, and inspect the view to make sure it displays the modified data accordingly.

## Project Setup with Tuist

This project uses **Tuist** for project generation, removing the need to commit `.pbxproj` files and making project configuration more maintainable.

### Quick Start

#### Using Bash

```bash
chmod +x scripts/setup-tuist.sh
./scripts/setup-tuist.sh
```

#### Using Fish Shell + mise (Recommended)

```fish
chmod +x scripts/setup-tuist.fish
./scripts/setup-tuist.fish
```

Then open the workspace:

```bash
open "Listen anonymously.xcworkspace"
```

For detailed setup instructions:
- **General setup**: See [TUIST_SETUP.md](TUIST_SETUP.md)
- **Fish shell + mise**: See [FISH_SHELL_GUIDE.md](FISH_SHELL_GUIDE.md)

### Build Configuration via xcconfig

- Hiding sensitive data such as the `DEVELOPMENT_TEAM` is done using `.xcconfig` files that are local. Manual sign-in was also implemented by using provisioning files.
- Deployment target is also managed in `xcconfig` file in order to avoid having to manually modify the Build Settings of all targets.
- `Secrets.xcconfig` is a local file that is git-ignored. It includes the development team information. In the CI, the workflow reads a Github Action Secret with the same data and creates the `xcconfig` file with it.
- Project structure is defined in `Project.swift` using Tuist's declarative API.

## CI
Github Actions is used to make sure all tests pass and the code coverage remains high.
[code-coverage.yml](https://github.com/lfcj/listen-anonymously/blob/main/.github/workflows/code-coverage.yml) forces usage of Xcode-26, runs tests and uploads code coverage results to CODECOV.

🚧 Trigger upload to ASC

### Capture and frame screenshots for all localizations

```
bundle exec fastlane ios screenshots
```

This runs the `Listen-anonymously-Snapshot-Tests` target, which programmatically renders each view using `SnapshotConfiguration` for all 37 App Store Connect locales: ar-SA, cs, da, de-DE, el, en-AU, en-GB, en-US, es-ES, es-MX, fi, fr-CA, fr-FR, he, hi, hr, hu, id, it, ja, ko, ms, nl-NL, no, pl, pt-BR, pt-PT, ro, ru, sk, sv, th, tr, uk, vi, zh-Hans, zh-Hant.

Screenshots are saved to `fastlane/screenshots/<locale>/` locally and then framed with device bezels via `frameit`.

### Upload screenshots to App Store Connect

```
bundle exec fastlane ios upload_screenshots
```

This uploads the framed screenshots from `./fastlane/screenshots/` to ASC without touching the binary or metadata.

## `fastlane`

### Running fastfile locally

This repo is using `rbenv` to avoid installing dependencies globally, so first run `bundle install`.

To run all tests, do:

```
bundle exec fastlane ios all_tests
```

or execute
```
bundle exec fastlane lanes
```

to see all available lanes.

### Build for App Store

```
bundle exec fastlane ios build
```

This generates the Tuist project and builds the app with `app-store` export method. The `.ipa` is saved to `./fastlane/build_output/`.

### Build and upload to App Store Connect

```
bundle exec fastlane ios release
```

This builds the app and uploads it to ASC (skipping screenshots, including metadata).

### Build and release with screenshots

To create a full release with freshly captured screenshots:

```
bundle exec fastlane ios screenshots
bundle exec fastlane ios release
bundle exec fastlane ios upload_screenshots
```

### Upload metadata only

```
bundle exec fastlane ios upload_metadata
```

## Design system
🚧 Goal is to have a framework with design specs in JSON that gets mapped into Swift code. Names are semantic. The goal is to be able to export it to a package and be able to import it to every new private app. This allows homogeneity and consistent branding.

## Q&A

Reach out to hello@mqslimited.co for any questions or ideas.
