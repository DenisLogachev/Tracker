import UIKit

// MARK: - UI Constants
enum UIConstants {
    
    // MARK: - Layout
    enum Layout {
        static let sidePadding: CGFloat = 16
        static let fieldHeight: CGFloat = 75
        static let optionHeight: CGFloat = 75
        static let buttonHeight: CGFloat = 60
        static let cellCornerRadius: CGFloat = 16
        static let headerHeight: CGFloat = 28
        static let actionButtonSize: CGFloat = 34
        static let emojiSize: CGFloat = 24
        
        // Collection View
        static let collectionItemSize: CGFloat = 52
        static let collectionSpacing: CGFloat = 5
        static let collectionRows: Int = 3
        static var collectionHeight: CGFloat {
            headerHeight
            + CGFloat(collectionRows) * collectionItemSize
            + CGFloat(collectionRows - 1) * collectionSpacing
        }
        
        // Search
        static let searchFieldHeight: CGFloat = 36
        static let searchDebounceDelay: TimeInterval = 0.1
        
        // Animation
        static let transitionDuration: TimeInterval = 0.3
    }
    
    // MARK: - Text Limits
    enum TextLimits {
        static let nameMaxLength: Int = 38
    }
    
    // MARK: - Colors
    enum Colors {
        static let primaryBlack = UIColor(named: "PrimaryBlack") ?? .black
        static let background = UIColor(named: "BackgroundColor") ?? .systemBackground
        static let destructiveAccent = UIColor(named: "DestructiveAccent") ?? .systemRed
        static let secondaryGray = UIColor(named: "SecondaryGray") ?? .systemGray
        static let filterButton = UIColor(named: "FilterButtonColor") ?? .systemBlue
    }
    
    // MARK: - Images
    enum Images {
        static let placeholder = "PlaceholderImage"
        static let searchPlaceholder = "error"
        static let pinIcon = "pin.fill"
        static let plusIcon = "plus"
    }
    
    // MARK: - Defaults
    enum Defaults {
        static let color: UIColor = .systemGreen
        static let emoji: String = "😪"
    }
    
    // MARK: - Context Menu
    enum ContextMenu {
        static let pin = "Закрепить"
        static let unpin = "Открепить"
        static let edit = "Редактировать"
        static let delete = "Удалить"
    }
    
    // MARK: - Delete Alert
    enum DeleteAlert {
        static let title = "Уверены что хотите удалить трекер?"
        static let delete = "Удалить"
        static let cancel = "Отменить"
    }
}

