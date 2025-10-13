import AVFoundation
import Combine

public final class AudioPlayingManager: ObservableObject {

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
//
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

    func play() {
        if audioPlayer == nil, let audioURL = self.audioURL {
            setAudioPlayer(url: audioURL)
        }
        audioPlayer?.play()
        isPlaying = true
    }

    func pause() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func setPlayerPosition(_ currentTime: Double) {
        audioPlayer?.currentTime = currentTime
    }

    func findAudio() async {
        isLoadingAudio = true
        guard let inputItems = extensionContext?.inputItems as? [NSExtensionItem] else {
            isLoadingAudio = false
            errorMessage = "No audio file could be find. Please check you selected only one file."
            return
        }

        var findingAudioErrorMessage: String?
        for item in inputItems {
            do {
                let audioFileInformation = try await FindingAudioHelpers.loadAudioURL(in: item, isSecondAttempt: false)
                await MainActor.run {
                    isLoadingAudio = false
                    audioURL = audioFileInformation.url
                    audioTitle = audioFileInformation.title
                    canPlay = true
                }
                await setAudioDuration(url: audioFileInformation.url)
                return
            } catch let error {
                findingAudioErrorMessage = (error as? FindingAudioError)?.localizedDescription
                print(error)
            }
        }
        if let findingAudioErrorMessage = findingAudioErrorMessage {
            isLoadingAudio = false
            errorMessage = findingAudioErrorMessage
        }
    }

    private func setAudioPlayer(url: URL) {
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch let error {
            errorMessage = "Could not deactivate instance. \((error as NSError).debugDescription)"
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
        } catch let error {
            errorMessage = "Could not set category \((error as NSError).debugDescription)"
        }
        do {
            try AVAudioSession.sharedInstance().setActive(true)
        } catch let error {
            errorMessage = "Could not setActive. \((error as NSError).debugDescription)"
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error {
            errorMessage = "Could not create player with URL. \((error as NSError).debugDescription)"
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
