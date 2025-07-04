import UIKit

struct TrackerCellViewModel {
    let id: UUID
    let emoji: String
    let title: String
    let color: UIColor
    let completedDays: Int
    let isCompleted: Bool
    let isFuture: Bool
}
