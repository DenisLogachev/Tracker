import Foundation

final class CategoryListViewModel {
    // MARK: - Bindings
    var onCategoriesChanged: (() -> Void)?
    var onSelectionChanged: ((TrackerCategory?) -> Void)?
    
    // MARK: - Constants
    private let reservedCategoryTitle = TrackerConstants.Strings.importantCategoryTitle
    
    // MARK: - Private
    private let store: TrackerCategoryStore
    private(set) var categories: [TrackerCategory] = [] {
        didSet { onCategoriesChanged?() }
    }
    private(set) var selectedCategoryId: UUID? {
        didSet {
            let selected = categories.first { $0.id == selectedCategoryId }
            onSelectionChanged?(selected)
        }
    }
    
    // MARK: - Init
    init(store: TrackerCategoryStore = TrackerCategoryStore()) {
        self.store = store
        self.store.onChange = { [weak self] in
            self?.reload()
        }
        store.ensureDefaultCategoriesIfNeeded()
        reload()
    }
    
    // MARK: - Public API
    func numberOfRows() -> Int { categories.count }
    
    func titleForRow(at index: Int) -> String {
        guard index < categories.count else { return "" }
        return categories[index].title
    }
    
    func isSelected(at index: Int) -> Bool {
        guard index < categories.count else { return false }
        return categories[index].id == selectedCategoryId
    }
    
    func selectRow(at index: Int) {
        guard index < categories.count else { return }
        selectedCategoryId = categories[index].id
    }
    
    func preselect(category: TrackerCategory?) {
        selectedCategoryId = category?.id
    }
    
    // MARK: - Data
    func reload() {
        categories = store.fetchAll()
    }
    
    // MARK: - Mutations
    func renameCategory(id: UUID, to newTitle: String) {
        guard let category = categories.first(where: { $0.id == id }) else { return }
        let trimmed = newTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard category.title != reservedCategoryTitle else { return }
        guard !trimmed.isEmpty else { return }
        guard trimmed != reservedCategoryTitle else { return }
        
        store.updateTitle(for: id, to: trimmed)
    }
    
    func deleteCategory(id: UUID) {
        guard let category = categories.first(where: { $0.id == id }) else { return }
        
        guard category.title != reservedCategoryTitle else { return }
        
        store.delete(category)
        
        if selectedCategoryId == id { selectedCategoryId = nil }
    }
}


