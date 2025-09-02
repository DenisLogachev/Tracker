import CoreData
import UIKit

final class TrackerStore: NSObject {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCoreData>?
    
    var onChange: (() -> Void)?
    
    init(context: NSManagedObjectContext = Persistence.shared.context) {
        self.context = context
        super.init()
        
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        frc.delegate = self
        self.fetchedResultsController = frc
        
        do { try frc.performFetch() } catch {  print("Ошибка fetch в TrackerStore: \(error)") }
    }
    
    func fetchAll() -> [Tracker] {
        fetchedResultsController?.fetchedObjects?.compactMap { $0.toTracker() } ?? []
    }
    
    func add(_ tracker: Tracker) {
        let object = TrackerCoreData(context: context)
        object.id = tracker.id
        object.name = tracker.name
        object.emoji = tracker.emoji
        object.color = tracker.color.hexString
        if !tracker.schedule.isEmpty {
            object.schedule = try? JSONEncoder().encode(tracker.schedule.map { $0.rawValue })
        } else {
            object.schedule = nil
        }
        if let categoryObject = fetchCategory(by: tracker.category.id) {
            object.category = categoryObject
        }
        save()
    }
    
    func delete(_ tracker: Tracker) {
        if let result = fetchTracker(by: tracker.id) {
            context.delete(result)
            save()
        }
    }
    
    private func fetchTracker(by id: UUID) -> TrackerCoreData? {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    private func fetchCategory(by id: UUID) -> TrackerCategoryCoreData? {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    private func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Ошибка save в TrackerStore: \(error)")
        }
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        onChange?()
    }
}

extension TrackerCoreData {
    func toTracker() -> Tracker? {
        guard let id = id,
              let name = name,
              let emoji = emoji,
              let colorHex = color,
              let color = UIColor(hex: colorHex),
              let category = category?.toCategory() else { return nil }
        
        var scheduleArray: [Weekday] = []
        if let data = schedule,
           let rawValues = try? JSONDecoder().decode([Int].self, from: data) {
            scheduleArray = rawValues.compactMap { Weekday(rawValue: $0) }
        }
        
        return Tracker(
            id: id,
            name: name,
            color: color,
            emoji: emoji,
            schedule: scheduleArray,
            category: category
        )
    }
}

extension UIColor {
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }
        
        let r, g, b: CGFloat
        if hexSanitized.count == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
            self.init(red: r, green: g, blue: b, alpha: 1.0)
        } else {
            return nil
        }
    }
    
    var hexString: String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        return String(
            format: "#%02lX%02lX%02lX",
            lroundf(Float(r * 255)),
            lroundf(Float(g * 255)),
            lroundf(Float(b * 255))
        )
    }
}

