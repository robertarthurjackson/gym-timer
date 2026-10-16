import Foundation
import Combine

@MainActor
final class Countdown: ObservableObject {
    @Published private(set) var remaining: TimeInterval = 0
    @Published private(set) var total: TimeInterval = 0
    @Published private(set) var isRunning = false

    var onFinish: (() -> Void)?
    private var endDate: Date?
    private var timer: AnyCancellable?
    private let notificationID = UUID().uuidString

    var progress: Double { total > 0 ? max(0, remaining / total) : 0 }

    func start(_ seconds: TimeInterval) {
        total = seconds
        remaining = seconds
        resume()
    }

    func resume() {
        guard remaining > 0 else { return }
        endDate = Date().addingTimeInterval(remaining)
        isRunning = true
        Alerts.scheduleBackgroundAlert(in: remaining, id: notificationID)
        timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
            .sink { [weak self] _ in self?.update() }
    }

    func pause() {
        timer = nil
        isRunning = false
        Alerts.cancelBackgroundAlert(id: notificationID)
    }

    func stop() {
        pause()
        remaining = 0
        total = 0
    }

    private func update() {
        guard let endDate else { return }
        let previous = Int(remaining.rounded(.up))
        remaining = max(0, endDate.timeIntervalSinceNow)
        let now = Int(remaining.rounded(.up))
        if now != previous, (1...3).contains(now) { Alerts.tick() }
        if remaining <= 0 {
            pause()
            Alerts.finish()
            onFinish?()
        }
    }
}

func formatTime(_ t: TimeInterval) -> String {
    let s = Int(t.rounded(.up))
    return String(format: "%d:%02d", s / 60, s % 60)
}
