import SwiftUI

struct TimedSetsView: View {
    @AppStorage("timed.sets") private var sets = 5
    @AppStorage("timed.work") private var work = 45
    @AppStorage("timed.rest") private var rest = 30
    @StateObject private var timer = Countdown()
    @State private var active = false
    @State private var done = 0
    @State private var resting = false

    var body: some View {
        Group {
            if active { session } else { setup }
        }
        .navigationTitle("Timed Sets")
        .onAppear {
            #if DEBUG
            if UserDefaults.standard.bool(forKey: "autostart") { start() }
            #endif
        }
        .onDisappear { timer.stop(); Alerts.keepScreenOn(false) }
    }

    private var setup: some View {
        Form {
            Stepper("Sets: \(sets)", value: $sets, in: 1...30)
            DurationStepper(title: "Work", seconds: $work, step: 5)
            DurationStepper(title: "Rest", seconds: $rest, step: 5)
            Section {
                Button("Start") { start() }.font(.headline)
            }
        }
    }

    private var session: some View {
        VStack(spacing: 24) {
            SetDots(done: done, total: sets)
            if done >= sets {
                Spacer()
                Text("Workout complete").font(.largeTitle.bold()).foregroundStyle(Color.accentGym)
                Spacer()
                BigButton(title: "Finish") { finish() }
            } else {
                RingTimer(progress: timer.progress, label: formatTime(timer.remaining),
                          caption: resting ? "Rest" : "Work",
                          color: resting ? .restGym : .accentGym)
                HStack {
                    BigButton(title: timer.isRunning ? "Pause" : "Resume",
                              color: .white.opacity(0.85)) {
                        timer.isRunning ? timer.pause() : timer.resume()
                    }
                    BigButton(title: "Skip", color: resting ? .restGym : .accentGym) { advance() }
                }
            }
            Button("End session", role: .destructive) { finish() }
        }
        .padding()
    }

    private func start() {
        done = 0
        resting = false
        active = true
        Alerts.keepScreenOn(true)
        timer.onFinish = { advance() }
        timer.start(TimeInterval(work))
    }

    private func advance() {
        if resting {
            resting = false
            timer.start(TimeInterval(work))
        } else {
            done += 1
            if done >= sets {
                timer.stop()
            } else {
                resting = true
                timer.start(TimeInterval(rest))
            }
        }
    }

    private func finish() {
        timer.stop()
        active = false
        Alerts.keepScreenOn(false)
    }
}
