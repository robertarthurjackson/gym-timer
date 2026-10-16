import SwiftUI

struct CustomTimeView: View {
    @AppStorage("custom.seconds") private var seconds = 60
    @StateObject private var timer = Countdown()
    private let presets = [30, 60, 90, 120, 180, 300]

    var body: some View {
        VStack(spacing: 24) {
            RingTimer(progress: timer.total > 0 ? timer.progress : 1,
                      label: formatTime(timer.total > 0 ? timer.remaining : TimeInterval(seconds)),
                      caption: timer.isRunning ? "Go" : "Ready",
                      color: .accentGym)

            if timer.total == 0 {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3)) {
                    ForEach(presets, id: \.self) { p in
                        Button(formatTime(TimeInterval(p))) { seconds = p }
                            .buttonStyle(.bordered)
                            .tint(p == seconds ? .accentGym : .gray)
                    }
                }
                DurationStepper(title: "Time", seconds: $seconds, step: 5)
                BigButton(title: "Start") { start() }
            } else {
                HStack {
                    BigButton(title: timer.isRunning ? "Pause" : "Resume",
                              color: .white.opacity(0.85)) {
                        timer.isRunning ? timer.pause() : timer.resume()
                    }
                    BigButton(title: timer.remaining > 0 ? "Reset" : "Again") {
                        timer.remaining > 0 ? reset() : start()
                    }
                }
                if timer.remaining == 0 {
                    Button("Done", role: .destructive) { reset() }
                }
            }
        }
        .padding()
        .navigationTitle("Custom Time")
        .onAppear {
            #if DEBUG
            if UserDefaults.standard.bool(forKey: "autostart") { start() }
            #endif
        }
        .onDisappear { reset() }
    }

    private func start() {
        Alerts.keepScreenOn(true)
        timer.start(TimeInterval(seconds))
    }

    private func reset() {
        timer.stop()
        Alerts.keepScreenOn(false)
    }
}
