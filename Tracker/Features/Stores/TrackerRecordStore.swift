import CoreData

final class TrackerRecordStore: NSObject {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerRecordCoreData>?
    
    var onChange: (() -> Void)?
    
    init(context: NSManagedObjectContext = Persistence.shared.context) {
        self.context = context
        super.init()
        
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        let frc = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        frc.delegate = self
        self.fetchedResultsController = frc
        
        do {
            try frc.performFetch()
        } catch {
            print("Ошибка fetch в TrackerRecordStore: \(error)")
        }
    }
    
    func fetchAll() -> [TrackerRecord] {
        fetchedResultsController?.fetchedObjects?.compactMap { $0.toRecord() } ?? []
    }
    
    func fetchRecords(for tracker: Tracker) -> [TrackerRecord] {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "trackerId == %@", tracker.id as CVarArg)
        do {
            let results = try context.fetch(request)
            return results.compactMap { $0.toRecord() }
        } catch {
            print("Ошибка fetchRecords: \(error)")
            return []
        }
    }
    
    func addRecord(for tracker: Tracker, on date: Date) {
        let record = TrackerRecord(trackerId: tracker.id, date: date)
        let object = TrackerRecordCoreData(context: context)
        object.trackerId = record.trackerId
        object.date = record.date
        
        if let trackerObject = fetchTracker(by: tracker.id) {
            object.tracker = trackerObject
        }
        
        save()
    }
    
    func deleteRecord(for tracker: Tracker, on date: Date) {
        let request: NSFetchRequest<TrackerRecordCoreData> = TrackerRecordCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "trackerId == %@ AND date == %@",
            tracker.id as CVarArg,
            date as NSDate
        )
        if let result = try? context.fetch(request).first {
            context.delete(result)
            save()
        }
    }
    
    private func fetchTracker(by id: UUID) -> TrackerCoreData? {
        let request: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try? context.fetch(request).first
    }
    
    private func save() {
        do { try context.save() }
        catch { print("Ошибка save в TrackerRecordStore: \(error)") }
    }
}

extension TrackerRecordStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        onChange?()
    }
}

extension TrackerRecordCoreData {
    func toRecord() -> TrackerRecord? {
        guard let date = date, let trackerId = trackerId else { return nil }
        return TrackerRecord(trackerId: trackerId, date: date)
    }
}
