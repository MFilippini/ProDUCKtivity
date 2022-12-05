
import Foundation
import EventKit

extension EKReminder {
    func update(using reminder: Reminder, in store: EKEventStore) {
        title = reminder.title
        notes = reminder.notes
        isCompleted = reminder.isCompleted
        calendar = store.defaultCalendarForNewReminders()
    }
}

extension Array where Element == Reminder {
    func indexOfReminder(with id: String) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }
}
