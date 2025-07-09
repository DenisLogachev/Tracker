import UIKit

struct TrackerSettings {
    var name:  String = ""
    var category: String = ""
    var schedule: [Weekday] = []
    var emoji: String?
    var color: UIColor?
    
    var isComplete: Bool {
        !name.isEmpty &&
        !category.isEmpty &&
        !schedule.isEmpty &&
        emoji != nil &&
        color != nil
    }
    
    func buildTracker() -> Tracker? {
        guard isComplete,
              let emoji = emoji,
              let color = color
        else {
            return nil
        }
        
        return Tracker(
            id: UUID(),
            name: name,
            color: color,
            emoji: emoji,
            schedule: schedule,
            category: category
        )
    }
}

extension TrackerSettings {
    mutating func setRandomColorAndEmoji() {
        self.color = TrackerConstants.availableColors.randomElement() ?? .systemGreen
        self.emoji = TrackerConstants.availableEmojis.randomElement() ?? "😪"
    }
}
