import UIKit

final class CategoryListViewController: UIViewController {
    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Категория"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIConstants.Colors.primaryBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.reuseIdentifier)
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.backgroundColor = .clear
        table.layer.cornerRadius = 16
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var doneButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Добавить категорию"
        config.baseBackgroundColor = UIConstants.Colors.primaryBlack
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 19, leading: 32, bottom: 19, trailing: 32)
        let button = UIButton(configuration: config)
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(doneTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - State
    private let viewModel: CategoryListViewModel
    var onCategorySelected: ((TrackerCategory) -> Void)?
    
    // MARK: - Init
    init(viewModel: CategoryListViewModel = CategoryListViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = CategoryListViewModel()
        super.init(coder:coder)
        assertionFailure("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        
        bindViewModel()
        viewModel.reload()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 6 * 75),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    @objc private func doneTapped() {
        guard let selectedId = viewModel.selectedCategoryId,
              let category = viewModel.categories.first(where: { $0.id == selectedId }) else {
            dismiss(animated: true)
            return
        }
        onCategorySelected?(category)
        dismiss(animated: true)
    }
    
    // MARK: - Bindings
    private func bindViewModel() {
        viewModel.onCategoriesChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func preselect(category: TrackerCategory?) {
        viewModel.preselect(category: category)
    }
    
    private func presentRename(for category: TrackerCategory) {
        let vm = CategoryEditViewModel(categoryId: category.id, name: category.title)
        let vc = CategoryEditViewController(viewModel: vm)
        vc.onSave = { [weak self] id, newName in
            self?.viewModel.renameCategory(id: id, to: newName)
        }
        present(vc, animated: true)
    }
    
    private func confirmDelete(category: TrackerCategory) {
        let sheet = UIAlertController(title: "Эта категория точно не нужна?", message: nil, preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: "Удалить", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteCategory(id: category.id)
        }
        let cancel = UIAlertAction(title: "Отменить", style: .cancel)
        sheet.addAction(delete)
        sheet.addAction(cancel)
        if let popover = sheet.popoverPresentationController {
            popover.sourceView = self.view
            popover.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.maxY - 1, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        present(sheet, animated: true)
    }
}

// MARK: - Context Menu
extension CategoryListViewController {
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let category = viewModel.categories[indexPath.row]
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            guard let self = self else { return nil }
            let edit = UIAction(title: "Редактировать") { _ in
                self.presentRename(for: category)
            }
            let delete = UIAction(title: "Удалить", attributes: .destructive) { _ in
                self.confirmDelete(category: category)
            }
            if category.title == TrackerConstants.Strings.importantCategoryTitle {
                edit.attributes.insert(.disabled)
                delete.attributes.insert(.disabled)
            }
            return UIMenu(title: "", children: [edit, delete])
        }
    }
}

extension CategoryListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as? CategoryCell else {
            return UITableViewCell()
        }
        let showSeparator = indexPath.row < viewModel.numberOfRows() - 1
        cell.configure(title: viewModel.titleForRow(at: indexPath.row), isSelected: viewModel.isSelected(at: indexPath.row), showSeparator: showSeparator)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectRow(at: indexPath.row)
        tableView.reloadData()
        if let selectedIndex = indexPath.row as Int?, selectedIndex < viewModel.numberOfRows() {
            let title = viewModel.titleForRow(at: selectedIndex)
            let id = viewModel.categories[selectedIndex].id
            let category = TrackerCategory(id: id, title: title, trackers: [])
            onCategorySelected?(category)
            dismiss(animated: true)
        }
    }
}


