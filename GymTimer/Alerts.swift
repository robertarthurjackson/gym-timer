import AVFoundation
import AudioToolbox
import UIKit
import UserNotifications

enum Alerts {
    static func configureAudio() {
        // Mix with the user's music instead of pausing it.
        try? AVAudioSession.sharedInstance().setCategory(.ambient, options: [.mixWithOthers])
        try? AVAudioSession.sharedInstance().setActive(true)
    }

    static func tick() {
        AudioServicesPlaySystemSound(1057)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }

    static func finish() {
        AudioServicesPlaySystemSound(1005)
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }

    static func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }

    // iOS only shows these when the app is not in the foreground, so they cover locked/backgrounded use.
    static func scheduleBackgroundAlert(in seconds: TimeInterval, id: String) {
        let content = UNMutableNotificationContent()
        content.title = "Time's up"
        content.body = "Get back to it!"
        content.sound = .default
        content.interruptionLevel = .timeSensitive
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(1, seconds), repeats: false)
        UNUserNotificationCenter.current().add(UNNotificationRequest(identifier: id, content: content, trigger: trigger))
    }

    static func cancelBackgroundAlert(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }

    static func keepScreenOn(_ on: Bool) {
        UIApplication.shared.isIdleTimerDisabled = on
    }
}
