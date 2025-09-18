import UIKit

// MARK: - Layout Constants
enum LayoutConstants {
    
    // MARK: - General Layout
    enum General {
        static let sidePadding: CGFloat = 16
        static let fieldHeight: CGFloat = 75
        static let optionHeight: CGFloat = 75
        static let cellCornerRadius: CGFloat = 16
        static let headerHeight: CGFloat = 28
        static let actionButtonSize: CGFloat = 34
        static let emojiSize: CGFloat = 24
        static let buttonHeight: CGFloat = 50
    }
    
    // MARK: - Collection View
    enum Collection {
        static let itemSize: CGFloat = 52
        static let spacing: CGFloat = 5
        static let rows: Int = 3
        static var height: CGFloat {
            General.headerHeight
            + CGFloat(rows) * itemSize
            + CGFloat(rows - 1) * spacing
        }
    }
    
    
    // MARK: - Statistics Layout
    enum Statistics {
        static let cardHeight: CGFloat = 90
        static let cardCornerRadius: CGFloat = 16
        static let cardBottomSpacing: CGFloat = 12
        static let cardPadding: CGFloat = 16
        static let titleBottomSpacing: CGFloat = 8
        static let sectionTopSpacing: CGFloat = 24
        
        // Fonts
        static let titleFontSize: CGFloat = 34
        static let subtitleFontSize: CGFloat = 12
        
        // Gradient
        static let gradientBorderWidth: CGFloat = 1
        static let gradientInnerCornerRadius: CGFloat = 15
    }
}
