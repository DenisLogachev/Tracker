import Foundation

final class CategoryEditViewModel {
    // MARK: - Bindings
    var onNameChanged: ((String) -> Void)?
    var onValidityChanged: ((Bool) -> Void)?
    
    // MARK: - State
    let categoryId: UUID
    private(set) var name: String {
        didSet {
            onNameChanged?(name)
            onValidityChanged?(!name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }
    
    init(categoryId: UUID, name: String) {
        self.categoryId = categoryId
        self.name = name
    }
    
    func updateName(_ newValue: String) {
        name = newValue
    }
}


