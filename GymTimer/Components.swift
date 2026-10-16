import SwiftUI

extension Color {
    static let accentGym = Color(red: 0.25, green: 0.85, blue: 0.55)
    static let restGym = Color(red: 0.35, green: 0.6, blue: 1.0)
}

struct RingTimer: View {
    let progress: Double
    let label: String
    let caption: String
    let color: Color

    var body: some View {
        ZStack {
            Circle().stroke(Color.white.opacity(0.1), lineWidth: 18)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 18, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.1), value: progress)
            VStack(spacing: 4) {
                Text(label)
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .monospacedDigit()
                Text(caption.uppercased())
                    .font(.headline)
                    .foregroundStyle(color)
            }
        }
        .padding(24)
    }
}

struct BigButton: View {
    let title: String
    var color: Color = .accentGym
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title2.bold())
                .frame(maxWidth: .infinity, minHeight: 72)
                .background(color, in: RoundedRectangle(cornerRadius: 20))
                .foregroundStyle(.black)
        }
    }
}

struct DurationStepper: View {
    let title: String
    @Binding var seconds: Int
    var step = 15
    var range: ClosedRange<Int> = 5...3600

    var body: some View {
        Stepper(value: $seconds, in: range, step: step) {
            HStack {
                Text(title)
                Spacer()
                Text(formatTime(TimeInterval(seconds))).monospacedDigit().bold()
            }
        }
    }
}

struct SetDots: View {
    let done: Int
    let total: Int

    var body: some View {
        VStack(spacing: 8) {
            Text("Set \(min(done + 1, total)) of \(total)")
                .font(.title.bold())
            HStack(spacing: 8) {
                ForEach(0..<total, id: \.self) { i in
                    Circle()
                        .fill(i < done ? Color.accentGym : Color.white.opacity(0.2))
                        .frame(width: 14, height: 14)
                }
            }
        }
    }
}
