import UIKit

final class CreateTrackerViewController: UIViewController {
    
    // MARK: - ViewModel
    private let viewModel: CreateTrackerViewModel
    
    // MARK: - Init
    init (viewModel:CreateTrackerViewModel = CreateTrackerViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = CreateTrackerViewModel()
        super.init(coder:coder)
        assertionFailure("ViewModel was not provided")
    }
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.screenTitle
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = UIConstants.Colors.primaryBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Texts.namePlaceholder
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.backgroundColor = UIConstants.Colors.background
        textField.layer.cornerRadius = UIConstants.Layout.cellCornerRadius
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: UIConstants.Layout.fieldHeight))
        textField.leftViewMode = .always
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        return textField
    }()
    
    private lazy var charLimitLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.nameLimit
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIConstants.Colors.destructiveAccent
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var optionsTableView: UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.isScrollEnabled = false
        table.layer.cornerRadius = UIConstants.Layout.cellCornerRadius
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.register(TrackerOptionCell.self, forCellReuseIdentifier: TrackerOptionCell.reuseIdentifier)
        return table
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = UIConstants.Layout.collectionSpacing
        layout.minimumLineSpacing = UIConstants.Layout.collectionSpacing
        layout.itemSize = CGSize(width: UIConstants.Layout.collectionItemSize, height: UIConstants.Layout.collectionItemSize)
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: UIConstants.Layout.headerHeight)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(EmojiCell.self, forCellWithReuseIdentifier: EmojiCell.reuseIdentifier)
        collection.register(CategoryHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: CategoryHeaderView.reuseIdentifier)
        collection.isScrollEnabled = false
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var colorCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = UIConstants.Layout.collectionSpacing
        layout.minimumLineSpacing = UIConstants.Layout.collectionSpacing
        layout.itemSize = CGSize(width: UIConstants.Layout.collectionItemSize, height: UIConstants.Layout.collectionItemSize)
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: UIConstants.Layout.headerHeight)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(ColorCell.self, forCellWithReuseIdentifier: ColorCell.reuseIdentifier)
        collection.register(CategoryHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: CategoryHeaderView.reuseIdentifier)
        collection.isScrollEnabled = false
        collection.delegate = self
        collection.dataSource = self
        collection.backgroundColor = .clear
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    private lazy var cancelButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = Texts.cancel
        config.baseForegroundColor = UIConstants.Colors.destructiveAccent
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 19, leading: 32, bottom: 19, trailing: 32)
        
        let button = UIButton(configuration: config)
        button.layer.borderColor = UIConstants.Colors.destructiveAccent.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = UIConstants.Layout.cellCornerRadius
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(configuration: .filledDisabled(title: Texts.create))
        button.layer.cornerRadius = UIConstants.Layout.cellCornerRadius
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = false
        button.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [cancelButton, saveButton])
        stack.axis = .horizontal
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // MARK: - Output
    var onCreateTracker: ((Tracker) -> Void)?
    var onUpdateTracker: ((Tracker) -> Void)?
    
    // MARK: - Private State
    private var needsCollectionUpdate = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.Colors.screenBackground
        setupUI()
        setupKeyboardDismissGesture()
        bindViewModel()
        viewModel.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if needsCollectionUpdate {
            emojiCollectionView.reloadData()
            colorCollectionView.reloadData()
            needsCollectionUpdate = false
        }
    }
    
    deinit {
        print("CreateTrackerViewController deallocated")
    }
    
    private func bindViewModel() {
        viewModel.onNameLimitExceededChanged = { [weak self] exceeded in
            self?.charLimitLabel.isHidden = !exceeded
        }
        viewModel.onSaveEnabledChanged = { [weak self] enabled in
            self?.saveButton.configuration = enabled ? .filledPrimary(title: Texts.create) : .filledDisabled(title: Texts.create)
            self?.saveButton.isUserInteractionEnabled = enabled
        }
        viewModel.onCategorySubtitleChanged = { [weak self] _ in
            self?.optionsTableView.reloadData()
        }
        viewModel.onScheduleSubtitleChanged = { [weak self] _ in
            self?.optionsTableView.reloadData()
        }
        viewModel.onEmojiSelectionChanged = { [weak self] _ in
            self?.emojiCollectionView.reloadData()
        }
        viewModel.onColorSelectionChanged = { [weak self] _ in
            self?.colorCollectionView.reloadData()
        }
        viewModel.onTrackerCreated = { [weak self] tracker in
            if self?.onUpdateTracker != nil {
                self?.onUpdateTracker?(tracker)
            } else {
                self?.onCreateTracker?(tracker)
            }
            self?.dismiss(animated: true)
        }
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(scrollView)
        view.addSubview(buttonStack)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(nameTextField)
        contentView.addSubview(charLimitLabel)
        contentView.addSubview(optionsTableView)
        contentView.addSubview(emojiCollectionView)
        contentView.addSubview(colorCollectionView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor, constant: -16),
            
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 28),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.sidePadding),
            nameTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.sidePadding),
            nameTextField.heightAnchor.constraint(equalToConstant: Layout.fieldHeight),
            
            charLimitLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            charLimitLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 44),
            charLimitLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -45),
            charLimitLabel.heightAnchor.constraint(equalToConstant: 22),
            
            optionsTableView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            optionsTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.sidePadding),
            optionsTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.sidePadding),
            optionsTableView.heightAnchor.constraint(equalToConstant: CGFloat(OptionType.allCases.count) * Layout.optionHeight),
            
            emojiCollectionView.topAnchor.constraint(equalTo: optionsTableView.bottomAnchor, constant: 16),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: Layout.collectionHeight),
            
            colorCollectionView.topAnchor.constraint(equalTo: emojiCollectionView.bottomAnchor, constant: 16),
            colorCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18),
            colorCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -18),
            colorCollectionView.heightAnchor.constraint(equalToConstant: Layout.collectionHeight),
            colorCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            cancelButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight),
            saveButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight)
        ])
    }
    
    // MARK: - Actions
    @objc private func cancelTapped() {
        dismiss(animated: true)
    }
    
    @objc private func nameChanged(_ sender: UITextField) {
        let text = sender.text ?? ""
        viewModel.updateName(text)
    }
    
    @objc private func saveTapped() {
        viewModel.createTrackerIfValid()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func presentSchedule() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.selectedWeekdays = Set(viewModel.settings.schedule)
        scheduleVC.onWeekdaysSelected = { [weak self] selected in
            self?.viewModel.applySelectedWeekdays(selected)
        }
        present(scheduleVC, animated: true)
    }
    
    private func presentCategory() {
        let vm = CategoryListViewModel()
        let vc = CategoryListViewController(viewModel: vm)
        vc.preselect(category: viewModel.settings.category)
        vc.onCategorySelected = { [weak self] category in
            self?.viewModel.applySelectedCategory(category)
        }
        present(vc, animated: true)
    }
    
    private func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Public Methods
    func configureForEditing(tracker: Tracker) {
        titleLabel.text = "Редактирование привычки"
        nameTextField.text = tracker.name
        
        viewModel.configureForEditing(tracker: tracker)
        
        viewModel.applySelectedWeekdays(Set(tracker.schedule))
        
        viewModel.applySelectedCategory(tracker.category)
        
        needsCollectionUpdate = true
        
        saveButton.setTitle("Сохранить", for: .normal)
    }
}

// MARK: - UIButton.Configuration Extensions
private extension UIButton.Configuration {
    static func filledPrimary(title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = UIConstants.Colors.primaryBlack
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 19, leading: 32, bottom: 19, trailing: 32)
        return config
    }
    
    static func filledDisabled(title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = UIConstants.Colors.secondaryGray
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 19, leading: 32, bottom: 19, trailing: 32)
        return config
    }
}

// MARK: - UITextFieldDelegate
extension CreateTrackerViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        charLimitLabel.isHidden = updatedText.count <= UIConstants.TextLimits.nameMaxLength
        return updatedText.count <= UIConstants.TextLimits.nameMaxLength
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - UITableViewDelegate & DataSource
extension CreateTrackerViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OptionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Layout.optionHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TrackerOptionCell.reuseIdentifier, for: indexPath) as? TrackerOptionCell else {
            return UITableViewCell()
        }
        let option = OptionType.allCases[indexPath.row]
        let subtitle: String? = {
            switch option {
            case .category:
                return viewModel.categorySubtitle
            case .schedule:
                return viewModel.scheduleSubtitle
            }
        }()
        cell.configure(with: option.title, subtitle: subtitle, showSeparator: option.showsSeparator)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = OptionType.allCases[indexPath.row]
        switch option {
        case .category:
            presentCategory()
        case .schedule:
            presentSchedule()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension CreateTrackerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView == emojiCollectionView ? TrackerConstants.availableEmojis.count : TrackerConstants.availableColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == emojiCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiCell.reuseIdentifier, for: indexPath) as? EmojiCell else { return UICollectionViewCell() }
            let emoji = TrackerConstants.availableEmojis[indexPath.row]
            cell.configure(with: emoji, isSelected: viewModel.selectedEmojiIndex == indexPath)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath) as? ColorCell else { return UICollectionViewCell() }
            let color = TrackerConstants.availableColors[indexPath.row]
            cell.configure(with: color, isSelected: viewModel.selectedColorIndex == indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            viewModel.selectEmoji(at: indexPath)
        } else {
            viewModel.selectColor(at: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: CategoryHeaderView.reuseIdentifier,
            for: indexPath
        ) as! CategoryHeaderView
        
        header.title = collectionView == emojiCollectionView ? "Emoji" : "Цвет"
        return header
    }
}


private extension CreateTrackerViewController {
    enum Layout {
        static let sidePadding = UIConstants.Layout.sidePadding
        static let fieldHeight = UIConstants.Layout.fieldHeight
        static let optionHeight = UIConstants.Layout.optionHeight
        static let buttonHeight = UIConstants.Layout.buttonHeight
        static let collectionHeight = UIConstants.Layout.collectionHeight
    }
    
    enum Texts {
        static let screenTitle = "Новая привычка"
        static let namePlaceholder = "Введите название трекера"
        static let nameLimit = "Ограничение \(UIConstants.TextLimits.nameMaxLength) символов"
        static let cancel = "Отменить"
        static let create = "Создать"
        static let createEveryDay = "Каждый день"
    }
}
