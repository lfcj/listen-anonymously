#  Listen anonymously

This is an app that allows selecting any file in apps that allow sharing them, such as Whatsapp, Telegram or iMessage, and plays it.
This makes that the app does not consider the file has been opened/listened to and does not show the checkmarks.

## Technology

- This app uses SwiftUI ✅
- It only uses UIKit in the extension because Xcode/Swift do not allow differently yet. ✅
- The logic is controlled by a `AudioPlayingManager`. This file is an `ObservableObject` that controls:
    1. Finding the audio url inside of the `extensionContext`
    2. Creating an `AVAudioPlayer` using the url once the user taps the play button.
    3. Publishes information on error messages, or status to play (`canPlay` or `isPlaying`, `isLoading`).
    4. Allows starting to play, pausing or forwarding/rewinding playing position.

- App has 100% test coverage 🚧
    
## Q&A

### 1. Why is `AudioPlayingManager` an `EnvironmentObject` and not a `StateObject`.

`EnvironmentObject` is ideal to pass models that need to reach very deep in the view hierarchy. That allows avoiding each view to pass it along.

