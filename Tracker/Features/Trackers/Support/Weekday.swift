import Foundation

enum Weekday: Int, CaseIterable {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday

    var localizedShortName: String {
        switch self {
        case .monday: return "Пн"
        case .tuesday: return "Вт"
        case .wednesday: return "Ср"
        case .thursday: return "Чт"
        case .friday: return "Пт"
        case .saturday: return "Сб"
        case .sunday: return "Вс"
        }
    }
}

extension Weekday {
    init(date: Date) {
        let weekdayNumber = Calendar.current.component(.weekday, from: date)
        let corrected = (weekdayNumber == 1) ? 7 : weekdayNumber - 1
        self = Weekday(rawValue: corrected) ?? .monday
    }
}

