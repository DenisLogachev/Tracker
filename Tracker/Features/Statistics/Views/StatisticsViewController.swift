import UIKit

final class StatisticsViewController: UIViewController {
    
    // MARK: - ViewModel
    private let viewModel: StatisticsViewModel
    
    // MARK: - Init
    init(viewModel: StatisticsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        let trackerService = TrackerService()
        let trackerRecordService = TrackerRecordStore()
        let statisticsService = StatisticsService(
            trackerService: trackerService,
            trackerRecordService: trackerRecordService
        )
        self.viewModel = StatisticsViewModel(statisticsService: statisticsService)
        super.init(coder: coder)
    }
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = UIConstants.Statistics.Texts.statisticsTitle
        label.font = UIFont.systemFont(
            ofSize: UIConstants.Statistics.Layout.titleFontSize,
            weight: .bold
        )
        label.textColor = UIConstants.Colors.primaryBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var placeholderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: UIConstants.Images.statisticPlaceholder)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIConstants.Colors.secondaryGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = UIConstants.Statistics.Texts.statisticsPlaceholder
        label.font = UIFont.systemFont(
            ofSize: UIConstants.Statistics.Layout.subtitleFontSize,
            weight: .medium
        )
        label.textColor = UIConstants.Colors.primaryBlack
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var placeholderStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [placeholderImage, placeholderLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = UIConstants.Statistics.Layout.titleBottomSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var statisticsTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = true
        tableView.register(
            StatisticsCell.self,
            forCellReuseIdentifier: StatisticsCell.reuseIdentifier
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    // MARK: - Private Properties
    private var statisticsItems: [StatisticsItem] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.loadStatistics()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AnalyticsService.shared.reportScreenOpen(
            AnalyticsService.Screen.statistics.rawValue
        )
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        AnalyticsService.shared.reportScreenClose(
            AnalyticsService.Screen.statistics.rawValue
        )
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = UIConstants.Colors.screenBackground
        
        view.addSubview(titleLabel)
        view.addSubview(placeholderStack)
        view.addSubview(statisticsTableView)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: UIConstants.Statistics.Layout.cardPadding
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: UIConstants.Statistics.Layout.cardPadding
            ),
            titleLabel.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -UIConstants.Statistics.Layout.cardPadding
            ),
            
            placeholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            statisticsTableView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: UIConstants.Statistics.Layout.sectionTopSpacing
            ),
            statisticsTableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: UIConstants.Statistics.Layout.cardPadding
            ),
            statisticsTableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -UIConstants.Statistics.Layout.cardPadding
            ),
            statisticsTableView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -UIConstants.Statistics.Layout.cardPadding
            )
        ])
    }
    
    private func bindViewModel() {
        viewModel.onStatisticsChanged = { [weak self] items in
            self?.statisticsItems = items
            DispatchQueue.main.async {
                self?.statisticsTableView.reloadData()
            }
        }
        
        viewModel.onPlaceholderVisibilityChanged = { [weak self] isEmpty in
            DispatchQueue.main.async {
                self?.placeholderStack.isHidden = !isEmpty
                self?.statisticsTableView.isHidden = isEmpty
            }
        }
    }
    
}

// MARK: - UITableViewDataSource
extension StatisticsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return statisticsItems.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: StatisticsCell.reuseIdentifier,
            for: indexPath
        ) as? StatisticsCell else {
            return UITableViewCell()
        }
        
        let item = statisticsItems[indexPath.row]
        cell.configure(with: item)
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension StatisticsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UIConstants.Statistics.Layout.cardHeight +
        UIConstants.Statistics.Layout.cardBottomSpacing
    }
    
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UIConstants.Statistics.Layout.cardHeight +
        UIConstants.Statistics.Layout.cardBottomSpacing
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {
        return UIView()
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 0
    }
    
    func tableView(
        _ tableView: UITableView,
        viewForFooterInSection section: Int
    ) -> UIView? {
        return UIView()
    }
    
    func tableView(
        _ tableView: UITableView,
        heightForFooterInSection section: Int
    ) -> CGFloat {
        return 0
    }
}
