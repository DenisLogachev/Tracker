import UIKit

enum TrackerConstants {
    enum Colors {
        static let primaryBlack = UIColor(named: "PrimaryBlack") ?? .black
        static let background = UIColor(named: "BackgroundColor") ?? .white
        static let destructiveAccent = UIColor(named: "DestructiveAccent") ?? .red
        static let secondaryGray = UIColor(named: "SecondaryGray") ?? .lightGray
    }
    
    static let availableColors: [UIColor] = [
        .systemRed,
        .systemOrange,
        .systemYellow,
        .systemGreen,
        .systemMint,
        .systemTeal,
        .systemCyan,
        .systemBlue,
        .systemIndigo,
        .systemPurple,
        .systemPink,
        .systemBrown,
        .systemRed.withAlphaComponent(0.5),
        .systemOrange.withAlphaComponent(0.5),
        .systemYellow.withAlphaComponent(0.5),
        .systemGreen.withAlphaComponent(0.5),
        .systemMint.withAlphaComponent(0.5),
        .systemTeal.withAlphaComponent(0.5),
    ]
    
    static let availableEmojis: [String] = [
        "🙂","😻","🌺","🐶","❤️","😱","😇","😡","🥶","🤔","🙌","🍔","🥦","🏓","🥇","🎸","🏝️","😪"
    ]
}
