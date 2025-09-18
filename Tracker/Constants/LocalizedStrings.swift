import Foundation

// MARK: - Localized Strings
enum LocalizedStrings {
    
    // MARK: - Main Screen
    enum MainScreen {
        static var title: String {
            NSLocalizedString("MainScreen_Title", tableName: "Strings", comment: "")
        }
        static var searchPlaceholder: String {
            NSLocalizedString("MainScreen_SearchPlaceholder", tableName: "Strings", comment: "")
        }
        static var filtersButton: String {
            NSLocalizedString("MainScreen_FiltersButton", tableName: "Strings", comment: "")
        }
        static var emptyStateTitle: String {
            NSLocalizedString("MainScreen_EmptyStateTitle", tableName: "Strings", comment: "")
        }
        static var searchNotFound: String {
            NSLocalizedString("MainScreen_SearchNotFound", tableName: "Strings", comment: "")
        }
        static var filterNotFound: String {
            NSLocalizedString("MainScreen_FilterNotFound", tableName: "Strings", comment: "")
        }
    }
    
    // MARK: - Create Tracker
    enum CreateTracker {
        static var screenTitle: String {
            NSLocalizedString("CreateTracker_ScreenTitle", tableName: "Strings", comment: "")
        }
        static var editScreenTitle: String {
            NSLocalizedString("CreateTracker_EditScreenTitle", tableName: "Strings", comment: "")
        }
        static var namePlaceholder: String {
            NSLocalizedString("CreateTracker_NamePlaceholder", tableName: "Strings", comment: "")
        }
        static var nameLimit: String {
            NSLocalizedString("CreateTracker_NameLimit", tableName: "Strings", comment: "")
        }
        static var cancel: String {
            NSLocalizedString("CreateTracker_Cancel", tableName: "Strings", comment: "")
        }
        static var create: String {
            NSLocalizedString("CreateTracker_Create", tableName: "Strings", comment: "")
        }
        static var save: String {
            NSLocalizedString("CreateTracker_Save", tableName: "Strings", comment: "")
        }
        static var createEveryDay: String {
            NSLocalizedString("CreateTracker_CreateEveryDay", tableName: "Strings", comment: "")
        }
        static var emojiSection: String {
            NSLocalizedString("CreateTracker_EmojiSection", tableName: "Strings", comment: "")
        }
        static var colorSection: String {
            NSLocalizedString("CreateTracker_ColorSection", tableName: "Strings", comment: "")
        }
    }
    
    // MARK: - Category Management
    enum CategoryManagement {
        static var categoryTitle: String {
            NSLocalizedString("CategoryManagement_CategoryTitle", tableName: "Strings", comment: "")
        }
        static var addCategory: String {
            NSLocalizedString("CategoryManagement_AddCategory", tableName: "Strings", comment: "")
        }
        static var editCategory: String {
            NSLocalizedString("CategoryManagement_EditCategory", tableName: "Strings", comment: "")
        }
        static var categoryNamePlaceholder: String {
            NSLocalizedString("CategoryManagement_CategoryNamePlaceholder", tableName: "Strings", comment: "")
        }
        static var categoryNameLimit: String {
            NSLocalizedString("CategoryManagement_CategoryNameLimit", tableName: "Strings", comment: "")
        }
        static var categoryOption: String {
            NSLocalizedString("CategoryManagement_CategoryOption", tableName: "Strings", comment: "")
        }
        static var scheduleOption: String {
            NSLocalizedString("CategoryManagement_ScheduleOption", tableName: "Strings", comment: "")
        }
        static var deleteCategoryTitle: String {
            NSLocalizedString("CategoryManagement_DeleteCategoryTitle", tableName: "Strings", comment: "")
        }
    }
    
    // MARK: - Schedule
    enum Schedule {
        static var title: String {
            NSLocalizedString("Schedule_Title", tableName: "Strings", comment: "")
        }
        static var weekdays: [String] {
            [
                NSLocalizedString("Schedule_Monday", tableName: "Strings", comment: ""),
                NSLocalizedString("Schedule_Tuesday", tableName: "Strings", comment: ""),
                NSLocalizedString("Schedule_Wednesday", tableName: "Strings", comment: ""),
                NSLocalizedString("Schedule_Thursday", tableName: "Strings", comment: ""),
                NSLocalizedString("Schedule_Friday", tableName: "Strings", comment: ""),
                NSLocalizedString("Schedule_Saturday", tableName: "Strings", comment: ""),
                NSLocalizedString("Schedule_Sunday", tableName: "Strings", comment: "")
            ]
        }
        static var shortWeekdays: [String] {
            [
                NSLocalizedString("Schedule_ShortMonday", tableName: "Strings", comment: ""),
                NSLocalizedString("Schedule_ShortTuesday", tableName: "Strings", comment: ""),
                NSLocalizedString("Schedule_ShortWednesday", tableName: "Strings", comment: ""),
                NSLocalizedString("Schedule_ShortThursday", tableName: "Strings", comment: ""),
                NSLocalizedString("Schedule_ShortFriday", tableName: "Strings", comment: ""),
                NSLocalizedString("Schedule_ShortSaturday", tableName: "Strings", comment: ""),
                NSLocalizedString("Schedule_ShortSunday", tableName: "Strings", comment: "")
            ]
        }
    }
    
    // MARK: - Filters
    enum Filters {
        static var title: String {
            NSLocalizedString("Filters_Title", tableName: "Strings", comment: "")
        }
        static var allTrackers: String {
            NSLocalizedString("Filters_AllTrackers", tableName: "Strings", comment: "")
        }
        static var todayTrackers: String {
            NSLocalizedString("Filters_TodayTrackers", tableName: "Strings", comment: "")
        }
        static var completed: String {
            NSLocalizedString("Filters_Completed", tableName: "Strings", comment: "")
        }
        static var uncompleted: String {
            NSLocalizedString("Filters_Uncompleted", tableName: "Strings", comment: "")
        }
    }
    
    // MARK: - Tab Bar
    enum TabBar {
        static var trackers: String {
            NSLocalizedString("TabBar_Trackers", tableName: "Strings", comment: "")
        }
        static var statistics: String {
            NSLocalizedString("TabBar_Statistics", tableName: "Strings", comment: "")
        }
    }
    
    // MARK: - Onboarding
    enum Onboarding {
        static var firstPageTitle: String {
            NSLocalizedString("Onboarding_FirstPageTitle", tableName: "Strings", comment: "")
        }
        static var secondPageTitle: String {
            NSLocalizedString("Onboarding_SecondPageTitle", tableName: "Strings", comment: "")
        }
        static var actionButton: String {
            NSLocalizedString("Onboarding_ActionButton", tableName: "Strings", comment: "")
        }
    }
    
    // MARK: - Tracker Cell
    enum TrackerCell {
        static var daysSuffix: [String] {
            [
                NSLocalizedString("TrackerCell_Day", tableName: "Strings", comment: ""),
                NSLocalizedString("TrackerCell_Days2_4", tableName: "Strings", comment: ""),
                NSLocalizedString("TrackerCell_Days5_Plus", tableName: "Strings", comment: "")
            ]
        }
    }
    
    // MARK: - Statistics
    enum Statistics {
        static var title: String {
            NSLocalizedString("Statistics_Title", tableName: "Strings", comment: "")
        }
        static var placeholder: String {
            NSLocalizedString("Statistics_Placeholder", tableName: "Strings", comment: "")
        }
        static var bestPeriod: String {
            NSLocalizedString("Statistics_BestPeriod", tableName: "Strings", comment: "")
        }
        static var perfectDays: String {
            NSLocalizedString("Statistics_PerfectDays", tableName: "Strings", comment: "")
        }
        static var completedTrackers: String {
            NSLocalizedString("Statistics_CompletedTrackers", tableName: "Strings", comment: "")
        }
        static var averageValue: String {
            NSLocalizedString("Statistics_AverageValue", tableName: "Strings", comment: "")
        }
    }
    
    // MARK: - Default Categories
    enum DefaultCategories {
        static var important: String {
            NSLocalizedString("DefaultCategories_Important", tableName: "Strings", comment: "")
        }
        static var pinned: String {
            NSLocalizedString("DefaultCategories_Pinned", tableName: "Strings", comment: "")
        }
    }
}
