import CoreData

final class TrackerCategoryStore: NSObject {
    private let context: NSManagedObjectContext
    private var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData>?
    
    var onChange: (() -> Void)?
    
    init(context: NSManagedObjectContext = Persistence.shared.context, useFRC: Bool = true) {
        self.context = context
        super.init()
        guard useFRC else { return }
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
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
            print("Ошибка fetch в TrackerCategoryStore: \(error)")
        }
    }
    
    func fetchAll() -> [TrackerCategory] {
        fetchedResultsController?.fetchedObjects?.compactMap { $0.toCategory() } ?? []
    }
    
    func ensureDefaultCategory() -> TrackerCategory {
        if let existing = fetchCategory(byTitle: "Важное")?.toCategory() {
            return existing
        }
        let category = TrackerCategory(id: UUID(), title: "Важное", trackers: [])
        add(category)
        return fetchCategory(by: category.id)?.toCategory() ?? category
    }
    
    func add(_ category: TrackerCategory) {
        if fetchCategory(by: category.id) != nil {
            return
        }
        let object = TrackerCategoryCoreData(context: context)
        object.id = category.id
        object.title = category.title
        save()
    }
    
    func delete(_ category: TrackerCategory) {
        if let result = fetchCategory(by: category.id)   {
            context.delete(result)
            save()
        }
    }
    
    private func fetchCategory(by id: UUID) -> TrackerCategoryCoreData? {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    private func fetchCategory(byTitle title: String) -> TrackerCategoryCoreData? {
        let request: NSFetchRequest<TrackerCategoryCoreData> = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(format: "title == %@", title)
        request.fetchLimit = 1
        return try? context.fetch(request).first
    }
    
    private func save() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Ошибка save в TrackerCategoryStore: \(error)")
        }
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        onChange?()
    }
}

extension TrackerCategoryCoreData {
    func toCategory() -> TrackerCategory? {
        guard let id = id, let title = title else { return nil }
        return TrackerCategory(id: id, title: title, trackers: [])
    }
}

