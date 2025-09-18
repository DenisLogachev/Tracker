import UIKit

final class ScheduleViewController: UIViewController {
    
    private let viewModel = ScheduleViewModel()
    
    private let daysOfWeek = UIConstants.Schedule.weekdays
    
    var selectedWeekdays: Set<Weekday> = []
    var onWeekdaysSelected: ((Set<Weekday>) -> Void)?
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = UIConstants.Schedule.title
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
        table.register(ScheduleCell.self, forCellReuseIdentifier: "ScheduleCell")
        table.separatorStyle = .none
        table.isScrollEnabled = false
        table.backgroundColor = .clear
        table.layer.cornerRadius = 16
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private lazy var doneButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = UIConstants.CreateTracker.save
        config.baseBackgroundColor = UIConstants.Colors.primaryBlack
        config.baseForegroundColor = UIConstants.Colors.primaryWhite
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.Colors.screenBackground
        setupUI()
        bindViewModel()
        viewModel.setInitial(selectedWeekdays)
    }
    private func bindViewModel() {
        viewModel.onWeekdaysChanged = { [weak self] _ in
            self?.tableView.reloadData()
        }
        viewModel.onDone = { [weak self] selected in
            self?.onWeekdaysSelected?(selected)
            self?.dismiss(animated: true)
        }
    }
    
    // MARK: - Setup
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
            tableView.heightAnchor.constraint(equalToConstant: 7 * 75),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // MARK: - Actions
    @objc private func doneTapped() {
        viewModel.done()
    }
}

// MARK: - UITableView Delegate/DataSource
extension ScheduleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        daysOfWeek.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath) as? ScheduleCell,
            let weekday = Weekday(rawValue: indexPath.row + 1)
        else {
            assertionFailure("Failed to dequeue ScheduleCell or invalid Weekday")
            return UITableViewCell()
        }
        
        let day = daysOfWeek[indexPath.row]
        let showSeparator = indexPath.row < daysOfWeek.count - 1
        let isOn = viewModel.selectedWeekdays.contains(weekday)
        
        cell.configure(with: day, isOn: isOn, showSeparator: showSeparator)
        
        cell.onSwitchChanged = { [weak self] isOn in
            self?.viewModel.toggle(weekday, isOn: isOn)
        }
        
        return cell
    }
}
