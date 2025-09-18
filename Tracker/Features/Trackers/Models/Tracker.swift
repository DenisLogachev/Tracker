import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Weekday]
    let category: TrackerCategory
    let isPinned: Bool
    
    init(id: UUID = UUID(), name: String, color: UIColor, emoji: String, schedule: [Weekday], category: TrackerCategory, isPinned: Bool = false) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.category = category
        self.isPinned = isPinned
    }
}



