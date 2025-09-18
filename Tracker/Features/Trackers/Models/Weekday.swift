import Foundation

enum Weekday: Int, CaseIterable {
    case monday = 1, tuesday, wednesday, thursday, friday, saturday, sunday

    var localizedShortName: String {
        return UIConstants.Schedule.shortWeekdays[self.rawValue - 1]
    }
}

extension Weekday {
    init(date: Date) {
        let weekdayNumber = Calendar.current.component(.weekday, from: date)
        let corrected = (weekdayNumber == 1) ? 7 : weekdayNumber - 1
        self = Weekday(rawValue: corrected) ?? .monday
    }
}

