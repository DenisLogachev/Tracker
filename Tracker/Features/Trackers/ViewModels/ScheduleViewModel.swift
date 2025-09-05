import Foundation

final class ScheduleViewModel {
    // MARK: - Bindings
    var onWeekdaysChanged: ((Set<Weekday>) -> Void)?
    var onDone: ((Set<Weekday>) -> Void)?
    
    // MARK: - State
    private(set) var selectedWeekdays: Set<Weekday> = [] {
        didSet { onWeekdaysChanged?(selectedWeekdays) }
    }
    
    // MARK: - Public API
    func setInitial(_ weekdays: Set<Weekday>) {
        selectedWeekdays = weekdays
    }
    
    func toggle(_ weekday: Weekday, isOn: Bool) {
        if isOn { selectedWeekdays.insert(weekday) } else { selectedWeekdays.remove(weekday) }
    }
    
    func done() {
        onDone?(selectedWeekdays)
    }
}


