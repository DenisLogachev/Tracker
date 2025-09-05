import UIKit

final class TrackersViewController: UIViewController {
    
    private let viewModel: TrackersViewModel
    private let trackerService: TrackerService
    
    // MARK: - Init
    init (viewModel:TrackersViewModel, trackerService:TrackerService) {
        self.viewModel = viewModel
        self.trackerService = trackerService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.trackerService = TrackerService()
        self.viewModel = TrackersViewModel(trackerService: self.trackerService)
        super.init(coder:coder)
        assertionFailure("Dependencies not provided")
    }
    
    
    // MARK: - Properties
    private var categorizedTrackers: [TrackerCategoryViewModel] = []
    
    // MARK: - UI Components
    private lazy var datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        return picker
    }()
    
    private lazy var searchField: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Поиск"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var titleLabel: UILabel = {
        makeLabel(
            text: "Трекеры",
            font: UIFont.systemFont(ofSize: 34, weight: .bold),
            textColor: UIColor(named: "PrimaryText")
        )
    }()
    
    private lazy var placeholderImage: UIImageView = {
        makeImageView(named: "PlaceholderImage", size: CGSize(width: 80, height: 80))
    }()
    
    private lazy var placeholderLabel: UILabel = {
        makeLabel(
            text: "Что будем отслеживать?",
            font: UIFont.systemFont(ofSize: 12, weight: .medium),
            textColor: UIColor(named: "PrimaryText"),
            alignment: .center
        )
    }()
    
    private lazy var placeholderStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [placeholderImage, placeholderLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var trackersCollectionView: UICollectionView = {
        let layout = createCollectionViewLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.reuseIdentifier)
        collectionView.register(CategoryHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CategoryHeaderView.reuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupNavigationBar()
        configureUI()
        viewModel.load()
    }
    
    // MARK: - Setup
    private func bindViewModel() {
        viewModel.onCategorizedTrackersChanged = { [weak self] categories in
            self?.showCategorizedTrackers(categories)
        }
        viewModel.onPlaceholderVisibilityChanged = { [weak self] isEmpty in
            self?.updatePlaceholderVisibility(isEmpty: isEmpty)
        }
        viewModel.onDateChanged = { [weak self] date in
            self?.updateDate(to: date)
        }
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .plain,
            target: self,
            action: #selector(plusButtonTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        navigationController?.navigationBar.tintColor = .black
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        [titleLabel, searchField, placeholderStack, trackersCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            searchField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            
            placeholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderStack.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 220),
            
            trackersCollectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 16),
            trackersCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            trackersCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            trackersCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
        layout.headerReferenceSize = CGSize(width: 0, height: 32)
        return layout
    }
    
    // MARK: - Actions
    @objc private func plusButtonTapped() {
        let creationVC = CreateTrackerViewController()
        creationVC.onCreateTracker = { [weak self] tracker in
            self?.viewModel.addTracker(tracker)
        }
        creationVC.modalPresentationStyle = .pageSheet
        present(creationVC, animated: true)
    }
    
    @objc private func dateChanged(_ sender: UIDatePicker) {
        viewModel.changeDate(to: sender.date)
    }
    
    // MARK: - Private Methods
    private func handleTrackerAction(at indexPath: IndexPath) {
        let trackerViewModel = categorizedTrackers[indexPath.section].trackers[indexPath.item]
        viewModel.toggleTracker(withId: trackerViewModel.id)
    }
    
    // MARK: - Public Methods
    func updatePlaceholderVisibility(isEmpty: Bool) {
        placeholderStack.isHidden = !isEmpty
        trackersCollectionView.isHidden = isEmpty
    }
    
    func updateDate(to date: Date) {
        datePicker.date = date
    }
    
    func showCategorizedTrackers(_ categories: [TrackerCategoryViewModel]) {
        self.categorizedTrackers = categories
        DispatchQueue.main.async {
            self.trackersCollectionView.reloadData()
        }
    }
    
    // MARK: - Factory Methods
    private func makeLabel(text: String, font: UIFont, textColor: UIColor?, alignment: NSTextAlignment = .left) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = textColor
        label.font = font
        label.textAlignment = alignment
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }
    
    private func makeImageView(named: String, size: CGSize) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = UIImage(named: named)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: size.width),
            imageView.heightAnchor.constraint(equalToConstant: size.height)
        ])
        return imageView
    }
}

// MARK: - UICollectionViewDataSource
extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return categorizedTrackers.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categorizedTrackers[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.reuseIdentifier, for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        
        let tracker = categorizedTrackers[indexPath.section].trackers[indexPath.item]
        cell.configure(with: tracker)
        cell.onAction = { [weak self] in
            self?.handleTrackerAction(at: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CategoryHeaderView.reuseIdentifier,
            for: indexPath
        ) as? CategoryHeaderView else {
            return UICollectionReusableView()
        }
        
        headerView.title = categorizedTrackers[indexPath.section].title
        return headerView
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat = 16
        let availableWidth = collectionView.frame.width - (padding * 3)
        let cellWidth = availableWidth / 2
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50)
    }
}
