import UIKit

// MARK: - Color Constants
enum ColorConstants {
    
    // MARK: - App Colors
    enum App {
        static let primaryBlack = UIColor(named: "PrimaryBlack") ?? .black
        static let primaryWhite = UIColor(named: "PrimaryWhite") ?? .white
        static let background = UIColor(named: "BackgroundColor") ?? .tertiarySystemBackground
        static let destructiveAccent = UIColor(named: "DestructiveAccent") ?? .systemRed
        static let secondaryGray = UIColor(named: "SecondaryGray") ?? .systemGray
        static let accentColor = UIColor(named: "AccentColor") ?? .systemBlue
        static let screenBackground = UIColor(named: "ScreenBackground") ?? .systemBackground
    }
    
    // MARK: - Statistics Colors
    enum Statistics {
        static let gradientRed = UIColor(red: 253/255, green: 76/255, blue: 73/255, alpha: 1)
        static let gradientGreen = UIColor(red: 70/255, green: 230/255, blue: 157/255, alpha: 1)
        static let gradientBlue = UIColor(red: 0/255, green: 123/255, blue: 250/255, alpha: 1)
        static let gradient: [UIColor] = [
            gradientRed,
            gradientGreen,
            gradientBlue
        ]
    }
}
