import UIKit

struct TrackerSettings {
    var name:  String = ""
    var category: TrackerCategory?
    var schedule: [Weekday] = []
    var emoji: String?
    var color: UIColor?
    
    var isComplete: Bool {
        !name.isEmpty &&
        category != nil &&
        !schedule.isEmpty &&
        emoji != nil &&
        color != nil
    }
    
    func buildTracker() -> Tracker? {
        guard isComplete,
              let emoji,
              let color,
              let category
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
