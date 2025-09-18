import Foundation

enum TrackerFilter: String, CaseIterable {
    case all = "all"
    case today = "today"
    case completed = "completed"
    case uncompleted = "uncompleted"
    
    var title: String {
        switch self {
        case .all:
            return "Все трекеры"
        case .today:
            return "Трекеры на сегодня"
        case .completed:
            return "Завершенные"
        case .uncompleted:
            return "Незавершенные"
        }
    }
    
    var shouldShowCheckmark: Bool {
        switch self {
        case .all, .today:
            return false
        case .completed, .uncompleted:
            return true
        }
    }
}
