import Listen_Anonymously_Shared
import SwiftUI

class InstructionsViewModel: ObservableObject {
    @Published var supportedApps: [SupportedApps] = []
    @Published var selectedApp: SupportedApps?

    var needsPicker: Bool {
        supportedApps.count > 1
    }

    init() {
        self.supportedApps = SupportedApps.allCases.filter({ DeeplinkHelper.hasApp($0) })
        self.selectedApp = supportedApps.first
    }
}

struct InstructionsView: View {
    @StateObject var viewModel = InstructionsViewModel()

    var body: some View {
        ZStack {
            LinearGradient.lavenderToPastelBlue.ignoresSafeArea()

            VStack {
                HStack {
                    Label("How to use?", systemImage: "list.number")
                        .font(.system(size: 44, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .bold()
                }
                .padding([.top, .bottom])

                if viewModel.needsPicker {
                    VStack {
                        Picker("Supported App", selection: $viewModel.selectedApp) {
                            ForEach(viewModel.supportedApps) { app in
                                Text(app.rawValue).tag(app)
                            }
                        }
                    }
                    .pickerStyle(.segmented)
                }

                switch viewModel.selectedApp {
                case .none, .whatsApp:
                    WhatsAppInstructionsStepsView()
                        .padding()
                case .telegram:
                    TelegramInstructionsStepsView()
                        .padding()
                @unknown default:
                    fatalError("Support \(String(describing: viewModel.selectedApp))")
                }
            }
            .padding()
            .frame(maxWidth: 600)
        }
    }

}

#Preview {
    InstructionsView()
}

#Preview {
    InstructionsView()
        .preferredColorScheme(.dark)
}
