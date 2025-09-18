import UIKit

// MARK: - App Constants
enum AppConstants {
    
    // MARK: - Text Limits
    enum TextLimits {
        static let nameMaxLength: Int = 38
    }
    
    // MARK: - Defaults
    enum Defaults {
        static let color: UIColor = .systemGreen
        static let emoji: String = "😪"
    }
    
    // MARK: - Animation
    enum Animation {
        static let transitionDuration: TimeInterval = 0.3
        static let searchDebounceDelay: TimeInterval = 0.1
    }
    
    // MARK: - Context Menu
    enum ContextMenu {
        static var pin: String {
            NSLocalizedString("ContextMenu_Pin", tableName: "Strings", comment: "")
        }
        static var unpin: String {
            NSLocalizedString("ContextMenu_Unpin", tableName: "Strings", comment: "")
        }
        static var edit: String {
            NSLocalizedString("ContextMenu_Edit", tableName: "Strings", comment: "")
        }
        static var delete: String {
            NSLocalizedString("ContextMenu_Delete", tableName: "Strings", comment: "")
        }
    }
    
    // MARK: - Delete Alert
    enum DeleteAlert {
        static var title: String {
            NSLocalizedString("DeleteAlert_Title", tableName: "Strings", comment: "")
        }
        static var delete: String {
            NSLocalizedString("DeleteAlert_Delete", tableName: "Strings", comment: "")
        }
        static var cancel: String {
            NSLocalizedString("DeleteAlert_Cancel", tableName: "Strings", comment: "")
        }
    }
}
