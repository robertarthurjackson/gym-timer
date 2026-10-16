import SwiftUI

struct HomeView: View {
    // Debug-only: launch with `-screen rep|timed|custom` to open a mode directly (for screenshots).
    @State private var path: [String] = {
        #if DEBUG
        if let s = UserDefaults.standard.string(forKey: "screen") { return [s] }
        #endif
        return []
    }()

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                Spacer()
                Image(systemName: "dumbbell.fill")
                    .font(.system(size: 56))
                    .foregroundStyle(Color.accentGym)
                Text("Gym Timer")
                    .font(.system(size: 44, weight: .heavy, design: .rounded))
                Text("Choose your session")
                    .foregroundStyle(.secondary)
                Spacer()
                modeLink("Rep Sets", "Tap after each set, auto rest", "repeat", "rep")
                modeLink("Timed Sets", "Work and rest on autopilot", "timer", "timed")
                modeLink("Custom Time", "One countdown, any length", "hourglass", "custom")
                Spacer()
            }
            .padding()
            .navigationDestination(for: String.self) { s in
                switch s {
                case "timed": TimedSetsView()
                case "custom": CustomTimeView()
                default: RepSetsView()
                }
            }
            .onAppear {
                Alerts.configureAudio()
                Alerts.requestNotificationPermission()
            }
        }
        .tint(.accentGym)
    }

    private func modeLink(_ title: String, _ subtitle: String, _ icon: String, _ dest: String) -> some View {
        NavigationLink(value: dest) {
            HStack(spacing: 16) {
                Image(systemName: icon).font(.title).frame(width: 40)
                VStack(alignment: .leading) {
                    Text(title).font(.title2.bold())
                    Text(subtitle).font(.subheadline).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "chevron.right").foregroundStyle(.secondary)
            }
            .padding(20)
            .foregroundStyle(.white)
            .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 20))
        }
    }
}
