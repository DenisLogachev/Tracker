import UIKit

protocol FilterViewControllerDelegate: AnyObject {
    func didSelectFilter(_ filter: TrackerFilter)
}

final class FilterViewController: UIViewController {
    
    weak var delegate: FilterViewControllerDelegate?
    private var selectedFilter: TrackerFilter
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Фильтры"
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
        table.register(FilterCell.self, forCellReuseIdentifier: FilterCell.reuseIdentifier)
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.backgroundColor = .clear
        table.layer.cornerRadius = 16
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    // MARK: - Init
    init(selectedFilter: TrackerFilter) {
        self.selectedFilter = selectedFilter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.selectedFilter = .all
        super.init(coder: coder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.Colors.screenBackground
        setupUI()
    }
    
    deinit {
        delegate = nil
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 4 * 50)
        ])
    }
}

// MARK: - UITableViewDataSource
extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TrackerFilter.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FilterCell.reuseIdentifier, for: indexPath) as? FilterCell else {
            return UITableViewCell()
        }
        
        let filter = TrackerFilter.allCases[indexPath.row]
        let isSelected = filter == selectedFilter
        let shouldShowCheckmark = isSelected && filter.shouldShowCheckmark
        let isLast = indexPath.row == TrackerFilter.allCases.count - 1
        
        cell.configure(with: filter.title, isSelected: shouldShowCheckmark, isLast: isLast)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedFilter = TrackerFilter.allCases[indexPath.row]
        delegate?.didSelectFilter(selectedFilter)
        dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
