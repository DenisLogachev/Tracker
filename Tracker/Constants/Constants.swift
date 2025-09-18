import UIKit

enum UIConstants {
    
    // MARK: - Layout
    enum Layout {
        static let sidePadding: CGFloat = LayoutConstants.General.sidePadding
        static let fieldHeight: CGFloat = LayoutConstants.General.fieldHeight
        static let optionHeight: CGFloat = LayoutConstants.General.optionHeight
        static let cellCornerRadius: CGFloat = LayoutConstants.General.cellCornerRadius
        static let headerHeight: CGFloat = LayoutConstants.General.headerHeight
        static let actionButtonSize: CGFloat = LayoutConstants.General.actionButtonSize
        static let emojiSize: CGFloat = LayoutConstants.General.emojiSize
        static let buttonHeight: CGFloat = LayoutConstants.General.buttonHeight
        static let collectionItemSize: CGFloat = LayoutConstants.Collection.itemSize
        static let collectionSpacing: CGFloat = LayoutConstants.Collection.spacing
        static let collectionRows: Int = LayoutConstants.Collection.rows
        static var collectionHeight: CGFloat { LayoutConstants.Collection.height }
        static let searchDebounceDelay: TimeInterval = AppConstants.Animation.searchDebounceDelay
        static let transitionDuration: TimeInterval = AppConstants.Animation.transitionDuration
    }
    
    // MARK: - Colors
    enum Colors {
        static let primaryBlack = ColorConstants.App.primaryBlack
        static let primaryWhite = ColorConstants.App.primaryWhite
        static let background = ColorConstants.App.background
        static let destructiveAccent = ColorConstants.App.destructiveAccent
        static let secondaryGray = ColorConstants.App.secondaryGray
        static let accentColor = ColorConstants.App.accentColor
        static let screenBackground = ColorConstants.App.screenBackground
    }
    
    // MARK: - Images
    enum Images {
        static let placeholder = ImageConstants.App.placeholder
        static let searchPlaceholder = ImageConstants.App.searchPlaceholder
        static let pinIcon = ImageConstants.App.pinIcon
        static let plusIcon = ImageConstants.App.plusIcon
        static let statisticPlaceholder = ImageConstants.App.statisticPlaceholder
    }
    
    // MARK: - Text Limits
    enum TextLimits {
        static let nameMaxLength: Int = AppConstants.TextLimits.nameMaxLength
    }
    
    // MARK: - Defaults
    enum Defaults {
        static let color: UIColor = AppConstants.Defaults.color
        static let emoji: String = AppConstants.Defaults.emoji
    }
    
    // MARK: - Context Menu
    enum ContextMenu {
        static var pin: String { AppConstants.ContextMenu.pin }
        static var unpin: String { AppConstants.ContextMenu.unpin }
        static var edit: String { AppConstants.ContextMenu.edit }
        static var delete: String { AppConstants.ContextMenu.delete }
    }
    
    // MARK: - Delete Alert
    enum DeleteAlert {
        static var title: String { AppConstants.DeleteAlert.title }
        static var delete: String { AppConstants.DeleteAlert.delete }
        static var cancel: String { AppConstants.DeleteAlert.cancel }
    }
    
    // MARK: - Localized Strings
    enum MainScreen {
        static var title: String { LocalizedStrings.MainScreen.title }
        static var searchPlaceholder: String { LocalizedStrings.MainScreen.searchPlaceholder }
        static var filtersButton: String { LocalizedStrings.MainScreen.filtersButton }
        static var emptyStateTitle: String { LocalizedStrings.MainScreen.emptyStateTitle }
        static var searchNotFound: String { LocalizedStrings.MainScreen.searchNotFound }
        static var filterNotFound: String { LocalizedStrings.MainScreen.filterNotFound }
    }
    
    enum CreateTracker {
        static var screenTitle: String { LocalizedStrings.CreateTracker.screenTitle }
        static var editScreenTitle: String { LocalizedStrings.CreateTracker.editScreenTitle }
        static var namePlaceholder: String { LocalizedStrings.CreateTracker.namePlaceholder }
        static var nameLimit: String { LocalizedStrings.CreateTracker.nameLimit }
        static var cancel: String { LocalizedStrings.CreateTracker.cancel }
        static var create: String { LocalizedStrings.CreateTracker.create }
        static var save: String { LocalizedStrings.CreateTracker.save }
        static var createEveryDay: String { LocalizedStrings.CreateTracker.createEveryDay }
        static var emojiSection: String { LocalizedStrings.CreateTracker.emojiSection }
        static var colorSection: String { LocalizedStrings.CreateTracker.colorSection }
    }
    
    enum CategoryManagement {
        static var categoryTitle: String { LocalizedStrings.CategoryManagement.categoryTitle }
        static var addCategory: String { LocalizedStrings.CategoryManagement.addCategory }
        static var editCategory: String { LocalizedStrings.CategoryManagement.editCategory }
        static var categoryNamePlaceholder: String { LocalizedStrings.CategoryManagement.categoryNamePlaceholder }
        static var categoryNameLimit: String { LocalizedStrings.CategoryManagement.categoryNameLimit }
        static var categoryOption: String { LocalizedStrings.CategoryManagement.categoryOption }
        static var scheduleOption: String { LocalizedStrings.CategoryManagement.scheduleOption }
        static var deleteCategoryTitle: String { LocalizedStrings.CategoryManagement.deleteCategoryTitle }
    }
    
    enum Schedule {
        static var title: String { LocalizedStrings.Schedule.title }
        static var weekdays: [String] { LocalizedStrings.Schedule.weekdays }
        static var shortWeekdays: [String] { LocalizedStrings.Schedule.shortWeekdays }
    }
    
    enum Filters {
        static var title: String { LocalizedStrings.Filters.title }
        static var allTrackers: String { LocalizedStrings.Filters.allTrackers }
        static var todayTrackers: String { LocalizedStrings.Filters.todayTrackers }
        static var completed: String { LocalizedStrings.Filters.completed }
        static var uncompleted: String { LocalizedStrings.Filters.uncompleted }
    }
    
    enum TabBar {
        static var trackers: String { LocalizedStrings.TabBar.trackers }
        static var statistics: String { LocalizedStrings.TabBar.statistics }
    }
    
    enum Onboarding {
        static var firstPageTitle: String { LocalizedStrings.Onboarding.firstPageTitle }
        static var secondPageTitle: String { LocalizedStrings.Onboarding.secondPageTitle }
        static var actionButton: String { LocalizedStrings.Onboarding.actionButton }
    }
    
    enum TrackerCell {
        static var daysSuffix: [String] { LocalizedStrings.TrackerCell.daysSuffix }
    }
    
    enum Statistics {
        enum Layout {
            static let cardHeight: CGFloat = LayoutConstants.Statistics.cardHeight
            static let cardCornerRadius: CGFloat = LayoutConstants.Statistics.cardCornerRadius
            static let cardBottomSpacing: CGFloat = LayoutConstants.Statistics.cardBottomSpacing
            static let cardPadding: CGFloat = LayoutConstants.Statistics.cardPadding
            static let titleBottomSpacing: CGFloat = LayoutConstants.Statistics.titleBottomSpacing
            static let sectionTopSpacing: CGFloat = LayoutConstants.Statistics.sectionTopSpacing
            static let titleFontSize: CGFloat = LayoutConstants.Statistics.titleFontSize
            static let subtitleFontSize: CGFloat = LayoutConstants.Statistics.subtitleFontSize
            static let gradientBorderWidth: CGFloat = LayoutConstants.Statistics.gradientBorderWidth
            static let gradientInnerCornerRadius: CGFloat = LayoutConstants.Statistics.gradientInnerCornerRadius
        }
        
        enum Colors {
            static let gradientRed = ColorConstants.Statistics.gradientRed
            static let gradientGreen = ColorConstants.Statistics.gradientGreen
            static let gradientBlue = ColorConstants.Statistics.gradientBlue
            static let gradient: [UIColor] = ColorConstants.Statistics.gradient
        }
        
        enum Calculation {
            static let averageValueDays: Int = 30
            static let otherMetricsDays: Int = 365
            static let cacheExpirationInterval: TimeInterval = 300
        }
        
        enum Formatting {
            static let averageValueDecimalPlaces: Int = 1
            static let zeroThreshold: Double = 1.0
        }
        
        enum Texts {
            static var statisticsTitle: String { LocalizedStrings.Statistics.title }
            static var statisticsPlaceholder: String { LocalizedStrings.Statistics.placeholder }
            static var statisticsBestPeriod: String { LocalizedStrings.Statistics.bestPeriod }
            static var statisticsPerfectDays: String { LocalizedStrings.Statistics.perfectDays }
            static var statisticsCompletedTrackers: String { LocalizedStrings.Statistics.completedTrackers }
            static var statisticsAverageValue: String { LocalizedStrings.Statistics.averageValue }
        }
    }
    
    // MARK: - Default Categories
    enum DefaultCategories {
        static var important: String { LocalizedStrings.DefaultCategories.important }
        static var pinned: String { LocalizedStrings.DefaultCategories.pinned }
    }
}
