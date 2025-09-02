import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [Weekday]
    let category: TrackerCategory
    
    init(id: UUID = UUID(), name: String, color: UIColor, emoji: String, schedule: [Weekday], category: TrackerCategory) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
        self.category = category
    }
}



