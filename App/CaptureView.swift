import SwiftUI
import EventKit
import WidgetKit

/// Opened by the widget's + button. Saves a reminder, which the widget
/// shows under DON'T FORGET.
struct CaptureView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var text = ""
    @State private var message = ""
    @FocusState private var focused: Bool
    private let p = DashboardTheme.studio.palette

    private var trimmed: String { text.trimmingCharacters(in: .whitespacesAndNewlines) }

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            Rectangle().fill(p.signal).frame(width: 44, height: 5)
            Text("DON'T FORGET")
                .font(.custom("InterTight-Medium", size: 12))
                .tracking(1)
                .foregroundColor(p.text)
            TextField("", text: $text, prompt: Text("Call Mom re: Kia key").foregroundColor(p.muted))
                .font(.custom("InterTight-Medium", size: 24))
                .foregroundColor(p.text)
                .tint(p.signal)
                .focused($focused)
                .submitLabel(.done)
                .onSubmit { Task { await save() } }
            HRule(color: p.rule, weight: 1)
            if !message.isEmpty {
                Text(message)
                    .font(.custom("InterTight-Regular", size: 14))
                    .foregroundColor(p.signal)
            }
            HStack {
                Button("Cancel") { dismiss() }
                    .font(.custom("InterTight-Medium", size: 16))
                    .foregroundColor(p.muted)
                Spacer()
                Button {
                    Task { await save() }
                } label: {
                    Text("Save to Reminders")
                        .font(.custom("InterTight-SemiBold", size: 16))
                        .foregroundColor(p.onSignal)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 11)
                        .background(Rectangle().fill(trimmed.isEmpty ? p.rule : p.signal))
                }
                .disabled(trimmed.isEmpty)
            }
            Spacer()
        }
        .padding(24)
        .background(CuttingMatBackground(palette: p).ignoresSafeArea())
        .preferredColorScheme(.dark)
        .onAppear { focused = true }
    }

    private func save() async {
        guard !trimmed.isEmpty else { return }
        let store = EKEventStore()
        if EKEventStore.authorizationStatus(for: .reminder) != .fullAccess {
            _ = try? await store.requestFullAccessToReminders()
        }
        guard EKEventStore.authorizationStatus(for: .reminder) == .fullAccess,
              let list = store.defaultCalendarForNewReminders() else {
            message = "Allow Reminders to save this. Settings → Privacy & Security → Reminders."
            return
        }
        let reminder = EKReminder(eventStore: store)
        reminder.title = trimmed
        reminder.calendar = list
        do {
            try store.save(reminder, commit: true)
            WidgetCenter.shared.reloadAllTimelines()
            dismiss()
        } catch {
            message = "Couldn't save: \(error.localizedDescription)"
        }
    }
}
