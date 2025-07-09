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
        .systemBlue,
        .systemGreen,
        .systemOrange,
        .systemPurple,
        .systemPink,
        .systemTeal,
        .systemYellow,
        .systemIndigo
    ]
    
    static let availableEmojis: [String] = [
        "😪", "😄", "🏃‍♂️", "📚", "🎵", "🍎", "🧘‍♀️", "🚴‍♂️", "☕️", "💤", "📝"
    ]
}
