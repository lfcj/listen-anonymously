import Listen_Anonymously_Shared
import SwiftUI

struct ThankYouView: View {
    let tipCounts: [DonationType: Int]
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LinearGradient
                .lavenderToPastelBlue
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Text("You're amazing")
                    .font(.title.weight(.bold))
                    .foregroundStyle(.white)
                    .padding(.top, 32)

                ScrollView {
                    VStack(spacing: 14) {
                        if let count = tipCounts[.coffee] {
                            TipCard(
                                icon: "cup.and.saucer.fill",
                                count: count,
                                message: coffeeMessage(count)
                            )
                        }
                        if let count = tipCounts[.goodVibes] {
                            TipCard(
                                icon: "heart.fill",
                                count: count,
                                message: goodVibesMessage(count)
                            )
                        }
                        if let count = tipCounts[.superKindTip] {
                            TipCard(
                                icon: "sparkles",
                                count: count,
                                message: superKindMessage(count)
                            )
                        }
                    }
                    .padding(.horizontal, 18)
                }

                Button {
                    dismiss()
                } label: {
                    Text(My.localizedString("DONE"))
                }
                .buttonStyle(GradientButtonStyle())
                .padding(.horizontal, 44)
                .padding(.bottom, 32)
            }
        }
        .presentationDetents([.medium, .large])
    }

    private func coffeeMessage(_ count: Int) -> String {
        count == 1
            ? "Thanks for your past coffee. It surely tasted well"
            : "Coding day and night thanks to your \(count) coffees."
    }

    private func goodVibesMessage(_ count: Int) -> String {
        count == 1
            ? "Your good vibes kept us going"
            : "Your \(count) good vibes are pure fuel."
    }

    private func superKindMessage(_ count: Int) -> String {
        count == 1
            ? "Ghost mode hero! You're absolutely legendary"
            : "Ghost mode hero x\(count)! You're beyond legendary."
    }
}

// MARK: - Tip Card

private struct TipCard: View {
    let icon: String
    let count: Int
    let message: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.15))
                    .frame(width: 48, height: 48)
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("x\(count)")
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.9))
            }

            Spacer()
        }
        .modifier(TranslucentCardStyle())
        .foregroundStyle(.white)
    }
}

// MARK: - Previews

#Preview("One coffee") {
    ThankYouView(tipCounts: [.coffee: 1])
}

#Preview("Mixed donations") {
    ThankYouView(tipCounts: [.coffee: 3, .superKindTip: 1])
}

#Preview("All types") {
    ThankYouView(tipCounts: [.coffee: 2, .goodVibes: 4, .superKindTip: 1])
}
