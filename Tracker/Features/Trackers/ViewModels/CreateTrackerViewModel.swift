import Foundation
import UIKit

final class CreateTrackerViewModel {
    // MARK: - Bindings
    var onNameLimitExceededChanged: ((Bool) -> Void)?
    var onSaveEnabledChanged: ((Bool) -> Void)?
    var onCategorySubtitleChanged: ((String) -> Void)?
    var onScheduleSubtitleChanged: ((String) -> Void)?
    var onEmojiSelectionChanged: ((IndexPath?) -> Void)?
    var onColorSelectionChanged: ((IndexPath?) -> Void)?
    var onTrackerCreated: ((Tracker) -> Void)?
    
    // MARK: - State
    private(set) var settings: TrackerSettings = TrackerSettings().withRandomColorAndEmoji()
    private(set) var selectedEmojiIndex: IndexPath?
    private(set) var selectedColorIndex: IndexPath?
    
    // MARK: - Lifecycle
    func viewDidLoad() {
        let store = TrackerCategoryStore(useFRC: false)
        settings = settings.withCategory(store.ensureDefaultCategory())
        publishAll()
    }
    
    // MARK: - Public API
    func updateName(_ text: String) {
        settings = settings.withName(text)
        publishChanges()
    }
    
    func selectEmoji(at indexPath: IndexPath) {
        selectedEmojiIndex = indexPath
        settings = settings.withEmoji(TrackerConstants.availableEmojis[indexPath.row])
        publishChanges()
        onEmojiSelectionChanged?(selectedEmojiIndex)
    }
    
    func selectColor(at indexPath: IndexPath) {
        selectedColorIndex = indexPath
        settings = settings.withColor(TrackerConstants.availableColors[indexPath.row])
        publishChanges()
        onColorSelectionChanged?(selectedColorIndex)
    }
    
    func applySelectedWeekdays(_ weekdays: Set<Weekday>) {
        let sorted = weekdays.sorted { $0.rawValue < $1.rawValue }
        settings = settings.withSchedule(sorted)
        onScheduleSubtitleChanged?(scheduleSubtitle)
        onSaveEnabledChanged?(isSaveEnabled)
    }
    
    func applySelectedCategory(_ category: TrackerCategory) {
        settings = settings.withCategory(category)
        onCategorySubtitleChanged?(categorySubtitle)
        onSaveEnabledChanged?(isSaveEnabled)
    }
    
    func createTrackerIfValid() {
        guard isSaveEnabled, let tracker = buildTracker() else { return }
        onTrackerCreated?(tracker)
    }
    
    // MARK: - Getters
    var categorySubtitle: String {
        if let category = settings.category, !category.title.isEmpty { return category.title }
        return OptionType.category.defaultSubtitle
    }
    
    var scheduleSubtitle: String {
        if settings.schedule.isEmpty { return OptionType.schedule.defaultSubtitle }
        if settings.schedule.count == Weekday.allCases.count { return Texts.createEveryDay }
        return settings.schedule.map { $0.localizedShortName }.joined(separator: ", ")
    }
    
    var isSaveEnabled: Bool {
        !settings.name.isEmpty && !settings.schedule.isEmpty && settings.category != nil
    }
    
    // MARK: - Helpers
    private func publishAll() {
        onCategorySubtitleChanged?(categorySubtitle)
        onScheduleSubtitleChanged?(scheduleSubtitle)
        onEmojiSelectionChanged?(selectedEmojiIndex)
        onColorSelectionChanged?(selectedColorIndex)
        onNameLimitExceededChanged?(settings.name.count > Layout.nameMaxLength)
        onSaveEnabledChanged?(isSaveEnabled)
    }
    
    private func publishChanges() {
        onNameLimitExceededChanged?(settings.name.count > Layout.nameMaxLength)
        onSaveEnabledChanged?(isSaveEnabled)
    }
    
    private func buildTracker() -> Tracker? {
        guard !settings.name.isEmpty, !settings.schedule.isEmpty, let category = settings.category else { return nil }
        return Tracker(
            id: UUID(),
            name: settings.name,
            color: settings.color ?? Defaults.color,
            emoji: settings.emoji ?? Defaults.emoji,
            schedule: settings.schedule,
            category: category
        )
    }
}
// MARK: - Constants
private enum Layout {
    static let nameMaxLength: Int = 38
}

private enum Texts {
    static let createEveryDay = "Каждый день"
}

private enum Defaults {
    static let color: UIColor = .systemGreen
    static let emoji: String = "😪"
}
