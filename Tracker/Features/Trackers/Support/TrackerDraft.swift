import UIKit

struct TrackerSettings {
    let name:  String
    let category: TrackerCategory?
    let schedule: [Weekday]
    let emoji: String?
    let color: UIColor?
    
    init(
        name:  String = "",
        category: TrackerCategory? = nil,
        schedule: [Weekday] = [],
        emoji: String? = nil,
        color: UIColor? = nil
    )
    {
        self.name = name
        self.category = category
        self.schedule = schedule
        self.emoji = emoji
        self.color = color
    }
    
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
    func withName(_ name: String) -> TrackerSettings {
        TrackerSettings(name: name,
                        category: category,
                        schedule: schedule,
                        emoji: emoji,
                        color: color)
    }
    
    func withCategory(_ category: TrackerCategory) -> TrackerSettings {
        TrackerSettings(name: name,
                        category: category,
                        schedule: schedule,
                        emoji: emoji,
                        color: color)
    }
    
    func withSchedule(_ schedule: [Weekday]) -> TrackerSettings {
        TrackerSettings(name: name,
                        category: category,
                        schedule: schedule,
                        emoji: emoji,
                        color: color)
    }
    
    func withEmoji(_ emoji: String) -> TrackerSettings {
        TrackerSettings(name: name,
                        category: category,
                        schedule: schedule,
                        emoji: emoji,
                        color: color)
    }
    
    func withColor(_ color: UIColor) -> TrackerSettings {
        TrackerSettings(name: name,
                        category: category,
                        schedule: schedule,
                        emoji: emoji,
                        color: color)
    }
    
    func withRandomColorAndEmoji() -> TrackerSettings {
        TrackerSettings(
            name: name,
            category: category,
            schedule: schedule,
            emoji: TrackerConstants.availableEmojis.randomElement() ?? "😪",
            color: TrackerConstants.availableColors.randomElement() ?? .systemGreen
        )
    }
}
