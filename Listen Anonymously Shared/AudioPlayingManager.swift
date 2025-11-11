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
    @Published var audioTitle: String? = nil
    @Published var errorMessage: String?
    @Published var duration: Double = 0

    var isPlayerNotUsable: Bool {
        isLoadingAudio || errorMessage != nil || !canPlay
    }

    private let extensionContext: NSExtensionContext?
    private var audioURL: URL?
    private var audioPlayer: AVAudioPlayer?

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
        audioPlayer?.play()
        isPlaying = audioPlayer != nil
    }

    func pause() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func setPlayerPosition(_ currentTime: Double) {
        audioPlayer?.currentTime = currentTime
    }

    open func findAudio(isSecondAttempt: Bool = false) async {
        isLoadingAudio = true
        errorMessage = nil
        guard let inputItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            isLoadingAudio = false
            errorMessage = "No audio file could be find. Please check you selected only one file." // TODO: Localize
            return
        }

        var findingAudioErrorMessage: String?
        for item in inputItems {
            do {
                try Task.checkCancellation()
                let audioFileInformation = try await FindingAudioHelpers.loadAudioURL(in: item, isSecondAttempt: isSecondAttempt)
                await MainActor.run {
                    isLoadingAudio = false
                    audioURL = audioFileInformation.url
                    audioTitle = audioFileInformation.title
                    canPlay = true
                }
                await setAudioDuration(url: audioFileInformation.url)
                return
            } catch let error {
                isLoadingAudio = false
                findingAudioErrorMessage = (error as? FindingAudioError)?.localizedDescription
            }
        }
        if let findingAudioErrorMessage = findingAudioErrorMessage {
            errorMessage = findingAudioErrorMessage
        }
    }

    private func setAudioPlayer(url: URL, audioSession: AudioSessionProtocol) {
        do {
            try audioSession.setActive(false, options: [])
            try audioSession.setCategory(.playback, mode: .default, options: [])
            try audioSession.setActive(true, options: [])
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error {
            errorMessage = "Could create audio player. \((error as NSError).debugDescription)"
        }
    }

    private func setAudioDuration(url: URL) async {
        do {
            let _duration = try await AVAsset(url: url).load(.duration).seconds
            await MainActor.run {
                duration = _duration
            }
        } catch let error {
            await MainActor.run {
                errorMessage = "Could not get duration. \((error as NSError).debugDescription)"
            }
        }
    }

}
