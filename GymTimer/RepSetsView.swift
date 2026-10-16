import SwiftUI

struct RepSetsView: View {
    @AppStorage("rep.sets") private var sets = 4
    @AppStorage("rep.rest") private var rest = 90
    @StateObject private var timer = Countdown()
    @State private var active = false
    @State private var done = 0

    var body: some View {
        Group {
            if active { session } else { setup }
        }
        .navigationTitle("Rep Sets")
        .onAppear {
            #if DEBUG
            if UserDefaults.standard.bool(forKey: "autostart") { active = true; done = 1; timer.start(TimeInterval(rest)) }
            #endif
        }
        .onDisappear { timer.stop(); Alerts.keepScreenOn(false) }
    }

    private var setup: some View {
        Form {
            Stepper("Sets: \(sets)", value: $sets, in: 1...20)
            DurationStepper(title: "Rest", seconds: $rest)
            Section {
                Button("Start") {
                    done = 0
                    active = true
                    Alerts.keepScreenOn(true)
                }
                .font(.headline)
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
            } else if timer.isRunning || timer.remaining > 0 {
                RingTimer(progress: timer.progress, label: formatTime(timer.remaining),
                          caption: "Rest", color: .restGym)
                HStack {
                    BigButton(title: "+15s", color: .white.opacity(0.85)) {
                        timer.start(timer.remaining + 15)
                    }
                    BigButton(title: "Skip", color: .restGym) { timer.stop() }
                }
            } else {
                Spacer()
                Text("Lift!").font(.system(size: 64, weight: .heavy, design: .rounded))
                Spacer()
                BigButton(title: "Set Done") { setDone() }
            }
            Button("End session", role: .destructive) { finish() }
        }
        .padding()
    }

    private func setDone() {
        done += 1
        if done < sets {
            timer.start(TimeInterval(rest))
        } else {
            Alerts.finish()
        }
    }

    private func finish() {
        timer.stop()
        active = false
        Alerts.keepScreenOn(false)
    }
}
