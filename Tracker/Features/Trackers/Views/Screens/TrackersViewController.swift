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
        searchBar.delegate = self
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
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Фильтры", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIConstants.Colors.filterButton
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        viewModel.onPlaceholderStateChanged = { [weak self] state in
            self?.updatePlaceholderState(state)
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
        [titleLabel, searchField, placeholderStack, trackersCollectionView, filterButton].forEach {
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
            trackersCollectionView.bottomAnchor.constraint(equalTo: filterButton.topAnchor, constant: -16),
            
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func createCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0) // Only bottom space for overscroll
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
    
    @objc private func filterButtonTapped() {
        let filterVC = FilterViewController(selectedFilter: viewModel.currentFilterState)
        filterVC.delegate = self
        filterVC.modalPresentationStyle = .pageSheet
        present(filterVC, animated: true)
    }
    
    
    // MARK: - Private Methods
    private func handleTrackerAction(at indexPath: IndexPath) {
        let trackerViewModel = categorizedTrackers[indexPath.section].trackers[indexPath.item]
        viewModel.toggleTracker(withId: trackerViewModel.id)
    }
    
    
    
    private func editTracker(_ tracker: Tracker) {
        let editVC = CreateTrackerViewController()
        editVC.configureForEditing(tracker: tracker)
        editVC.onUpdateTracker = { [weak self] updatedTracker in
            self?.viewModel.updateTracker(updatedTracker)
        }
        editVC.modalPresentationStyle = .pageSheet
        present(editVC, animated: true)
    }
    
    private func deleteTracker(_ tracker: Tracker) {
        let alert = UIAlertController(
            title: UIConstants.DeleteAlert.title,
            message: nil,
            preferredStyle: .actionSheet
        )
        
        let deleteAction = UIAlertAction(title: UIConstants.DeleteAlert.delete, style: .destructive) { [weak self] _ in
            self?.viewModel.deleteTracker(tracker)
        }
        
        let cancelAction = UIAlertAction(title: UIConstants.DeleteAlert.cancel, style: .cancel)
        
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        if let popover = alert.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        
        present(alert, animated: true)
    }
    
    // MARK: - Public Methods
    func updatePlaceholderVisibility(isEmpty: Bool) {
        placeholderStack.isHidden = !isEmpty
        trackersCollectionView.isHidden = isEmpty
    }
    
    func updatePlaceholderState(_ state: PlaceholderState) {
        switch state {
        case .noTrackersForDate:
            placeholderImage.image = UIImage(named: "PlaceholderImage")
            placeholderLabel.text = "Что будем отслеживать?"
        case .searchNotFound:
            placeholderImage.image = UIImage(named: "error")
            placeholderLabel.text = "Ничего не найдено"
        case .filterNotFound:
            placeholderImage.image = UIImage(named: "error")
            placeholderLabel.text = "Ничего не найдено"
        case .hidden:
            break
        }
    }
    
    func updateDate(to date: Date) {
        datePicker.date = date
    }
    
    func showCategorizedTrackers(_ categories: [TrackerCategoryViewModel]) {
        self.categorizedTrackers = categories
        DispatchQueue.main.async {
            self.trackersCollectionView.reloadData()
            self.updateFilterButtonVisibility()
            self.updateFilterButtonAppearance()
        }
    }
    
    private func updateFilterButtonVisibility() {
        // Show filter button only if there are trackers for the selected date
        let hasTrackersForDate = viewModel.allTrackersList.contains { tracker in
            let weekday = Weekday(date: viewModel.selectedDate)
            return tracker.schedule.contains(weekday)
        }
        filterButton.isHidden = !hasTrackersForDate
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
        
        let contextMenuInteraction = UIContextMenuInteraction(delegate: self)
        cell.addInteraction(contextMenuInteraction)
        
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
        return CGSize(width: collectionView.frame.width, height: 32)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
}

// MARK: - UISearchBarDelegate
extension TrackersViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.applySearch(searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.clearSearch()
    }
}

// MARK: - UIContextMenuInteractionDelegate
extension TrackersViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        guard let cell = interaction.view as? TrackerCell,
              let indexPath = trackersCollectionView.indexPath(for: cell),
              indexPath.section < categorizedTrackers.count,
              indexPath.item < categorizedTrackers[indexPath.section].trackers.count else {
            return nil
        }
        
        let trackerViewModel = categorizedTrackers[indexPath.section].trackers[indexPath.item]
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            return self?.createContextMenu(for: trackerViewModel.id, at: indexPath)
        }
    }
    
    private func createContextMenu(for trackerId: UUID, at indexPath: IndexPath) -> UIMenu {
        guard let tracker = viewModel.allTrackersList.first(where: { $0.id == trackerId }) else {
            return UIMenu(children: [])
        }
        
        let pinAction = UIAction(
            title: tracker.isPinned ? UIConstants.ContextMenu.unpin : UIConstants.ContextMenu.pin
        ) { [weak self] _ in
            self?.viewModel.togglePin(for: trackerId)
        }
        
        let editAction = UIAction(
            title: UIConstants.ContextMenu.edit
        ) { [weak self] _ in
            self?.editTracker(tracker)
        }
        
        let deleteAction = UIAction(
            title: UIConstants.ContextMenu.delete,
            attributes: .destructive
        ) { [weak self] _ in
            self?.deleteTracker(tracker)
        }
        
        return UIMenu(children: [pinAction, editAction, deleteAction])
    }
}

// MARK: - FilterViewControllerDelegate
extension TrackersViewController: FilterViewControllerDelegate {
    func didSelectFilter(_ filter: TrackerFilter) {
        viewModel.applyFilter(filter)
        updateFilterButtonAppearance()
    }
    
    private func updateFilterButtonAppearance() {
        let isFilterActive = viewModel.isFilterActive
        filterButton.setTitleColor(isFilterActive ? .systemRed : .white, for: .normal)
        filterButton.backgroundColor = UIConstants.Colors.filterButton
    }
}

