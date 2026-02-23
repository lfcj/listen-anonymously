import AVFoundation
import Combine

public protocol AudioSessionProtocol {
    func setActive(
        _ active: Bool,
        options: AVAudioSession.SetActiveOptions
    ) throws
    func setCategory(
        _ category: AVAudioSession.Category,
        mode: AVAudioSession.Mode,
        options: AVAudioSession.CategoryOptions
    ) throws
}

extension AVAudioSession: AudioSessionProtocol {}

open class AudioPlayingManager: ObservableObject {

    @Published var canPlay: Bool = false
    @Published var isPlaying: Bool = false
    @Published var isLoadingAudio = false
    @Published var audioTitle: String?
    @Published var errorMessage: String?
    @Published var duration: Double = 0

    var currentTime: TimeInterval? {
        audioPlayer?.currentTime
    }

    var isPlayerNotUsable: Bool {
        isLoadingAudio || errorMessage != nil || !canPlay
    }

    private let extensionContext: NSExtensionContext?
    private var audioURL: URL?
    private var audioPlayer: AVAudioPlayer?

    // Use when user uses UI to set a different time and play has not been tapped, hence audioPlayer is nil.
    private var stashedCurrentTime: TimeInterval?

    public init(
        extensionContext: NSExtensionContext?,
        canPlay: Bool = false,
        isPlaying: Bool = false,
        isLoadingAudio: Bool = false,
        errorMessage: String? = nil,
        duration: Double = 0,
        url: URL? = nil
    ) {
        self.extensionContext = extensionContext
        self.canPlay = canPlay
        self.isPlaying = isPlaying
        self.isLoadingAudio = isLoadingAudio
        self.errorMessage = errorMessage
        self.duration = duration
        self.audioURL = url
    }

    open func play(audioSession: AudioSessionProtocol = AVAudioSession.sharedInstance()) {
        if audioPlayer == nil, let audioURL = self.audioURL {
            setAudioPlayer(url: audioURL, audioSession: audioSession)
        }
        if let stashedCurrentTime {
            self.stashedCurrentTime = nil
            audioPlayer?.currentTime = stashedCurrentTime
        }
        audioPlayer?.play()

        logAudioWasPlayed()

        isPlaying = audioPlayer != nil
    }

    func pause() {
        audioPlayer?.pause()
        isPlaying = false
    }

    func setPlayerPosition(_ currentTime: Double) {
        if audioPlayer == nil {
            stashedCurrentTime = currentTime
        }
        audioPlayer?.currentTime = currentTime
    }

    func setRate(_ rate: PlayingRate) {
        audioPlayer?.rate = rate.rawValue
    }

    @MainActor
    open func findAudio(isSecondAttempt: Bool = false) async {
        isLoadingAudio = true
        errorMessage = nil
        guard let inputItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            isLoadingAudio = false
            errorMessage = "No audio file could be find. Please check you selected only one file." // Localize-it
            log(event: #function, properties: ["message": errorMessage])
            return
        }

        typealias Result = (audio: AudioFileInformation?, error: String?)
        let result: Result = await withTaskGroup(of: Result.self) { group in
            for item in inputItems {
                group.addTask {
                    do {
                        let fileInformation = try await FindingAudioHelpers.loadAudioURL(in: item, isSecondAttempt: isSecondAttempt)
                        return (audio: fileInformation, error: nil)
                    } catch {
                        return (audio: nil, error: error.localizedDescription)
                    }

                    // swiftlint:disable todo
                    // TODO: Send error to PostHot
                    // swiftlint:enable todo
                }
            }

            var lastError: String?
            for await (audioInfo, localizedError) in group {
                if let audioInfo {
                    group.cancelAll()
                    return (audioInfo, nil)
                   }
                lastError = localizedError
            }

            return (nil, lastError)
        }

        isLoadingAudio = false
        if let fileInformation = result.audio {
            audioURL = fileInformation.url
            audioTitle = fileInformation.title
            canPlay = true
            await setAudioDuration(url: fileInformation.url)
            return
        } else {
            errorMessage = result.error ?? "Could not find audio file information"
            log(event: #function, properties: ["message": errorMessage])
        }
    }

    private func setAudioPlayer(url: URL, audioSession: AudioSessionProtocol) {
        do {
            try audioSession.setActive(false, options: [])
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true, options: [])
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.enableRate = true
            audioPlayer?.prepareToPlay()
        } catch let error {
            errorMessage = "Could create audio player. \((error as NSError).debugDescription)"
            log(event: #function, properties: ["message": errorMessage])
        }
    }

    @MainActor
    private func setAudioDuration(url: URL) async {
        do {
            let urlDuration = try await AVURLAsset(url: url).load(.duration).seconds
            duration = urlDuration
            log(event: #function, properties: ["duration": urlDuration])
        } catch let error {
            errorMessage = "Could not get duration. \((error as NSError).debugDescription)"
            log(event: #function, properties: ["message": errorMessage])
        }
    }

    private func logAudioWasPlayed() {
        log(event: #function)
    }

    private func log(event: String, properties: [String: any Equatable]? = nil) {
        Task.detached {
            @Inject var postHog: SuperPosthog
            postHog.capture(event, properties: properties)
        }
    }

}
