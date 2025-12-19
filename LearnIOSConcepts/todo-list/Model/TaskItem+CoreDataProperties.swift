import CoreData
import Foundation

extension TaskItem: Identifiable {
    // Mandatory for @FetchRequest to work.
    @nonobjc class func fetchRequest() -> NSFetchRequest<TaskItem> {
        return NSFetchRequest<TaskItem>(entityName: "TaskItem")
    }

    @NSManaged var title: String
    @NSManaged var time: Date?
    @NSManaged var recurring: String
    @NSManaged var taskDescription: String
    @NSManaged var completed: Bool
}

extension TaskItem: Comparable {
    public static func < (lhs: TaskItem, rhs: TaskItem) -> Bool {
        rhs.time!.timeIntervalSince1970 < lhs.time!.timeIntervalSince1970
    }
}

extension TaskItem {
    var wrappedTime: Date {
        time ?? Date()
    }

    // Example of a business logic helper
    var isOverdue: Bool {
        guard let time = time else { return false }
        return time < Date() && !completed
    }
}
