import UIKit

final class CreateTrackerViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = Texts.screenTitle
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .center
        label.textColor = TrackerConstants.Colors.primaryBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Texts.namePlaceholder
        textField.font = UIFont.systemFont(ofSize: 17)
        textField.backgroundColor = TrackerConstants.Colors.background
        textField.layer.cornerRadius = Layout.cellCornerRadius
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: Layout.fieldHeight))
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
        label.textColor = TrackerConstants.Colors.destructiveAccent
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
        table.layer.cornerRadius = Layout.cellCornerRadius
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.register(TrackerOptionCell.self, forCellReuseIdentifier: TrackerOptionCell.reuseIdentifier)
        return table
    }()
    
    private lazy var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = Layout.collectionSpacing
        layout.minimumLineSpacing = Layout.collectionSpacing
        layout.itemSize = CGSize(width: Layout.collectionItemSize, height: Layout.collectionItemSize)
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: Layout.headerHeight)
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
        layout.minimumInteritemSpacing = Layout.collectionSpacing
        layout.minimumLineSpacing = Layout.collectionSpacing
        layout.itemSize = CGSize(width: Layout.collectionItemSize, height: Layout.collectionItemSize)
        layout.headerReferenceSize = CGSize(width: view.bounds.width, height: Layout.headerHeight)
        
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
        config.baseForegroundColor = TrackerConstants.Colors.destructiveAccent
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 19, leading: 32, bottom: 19, trailing: 32)
        
        let button = UIButton(configuration: config)
        button.layer.borderColor = TrackerConstants.Colors.destructiveAccent.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = Layout.cellCornerRadius
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(configuration: .filledDisabled(title: Texts.create))
        button.layer.cornerRadius = Layout.cellCornerRadius
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
    
    // MARK: - State
    private var settings: TrackerSettings = {
        TrackerSettings().withRandomColorAndEmoji()
    }()
    
    var onCreateTracker: ((Tracker) -> Void)?
    
    private var selectedEmojiIndex: IndexPath?
    private var selectedColorIndex: IndexPath?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupKeyboardDismissGesture()
        let store = TrackerCategoryStore(useFRC: false)
        settings = settings.withCategory(store.ensureDefaultCategory())
        optionsTableView.reloadData()
        updateSaveButtonState()
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
        settings = settings.withName(text)
        charLimitLabel.isHidden = text.count <= Layout.nameMaxLength
        updateSaveButtonState()
    }
    
    @objc private func saveTapped() {
        guard saveButton.isUserInteractionEnabled else { return }
        guard let tracker = createTracker() else { return }
        onCreateTracker?(tracker)
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func updateSaveButtonState() {
        let isValid = (!settings.name.isEmpty && !settings.schedule.isEmpty && settings.category != nil)
        saveButton.configuration = isValid
        ? .filledPrimary(title: Texts.create)
        : .filledDisabled(title: Texts.create)
        saveButton.isUserInteractionEnabled = isValid
    }
    
    private func createTracker() -> Tracker? {
        guard
            !settings.name.isEmpty,
            !settings.schedule.isEmpty,
            let category = settings.category
        else {
            return nil
        }
        
        return Tracker(
            id: UUID(),
            name: settings.name,
            color: settings.color ?? .systemGreen,
            emoji: settings.emoji ?? "😪",
            schedule: settings.schedule,
            category: category
        )
    }
    
    private func presentSchedule() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.selectedWeekdays = Set(settings.schedule)
        scheduleVC.onWeekdaysSelected = { [weak self] selected in
            guard let self = self else { return }
            self.settings = self.settings.withSchedule(selected.sorted { $0.rawValue < $1.rawValue })
            self.optionsTableView.reloadData()
            self.updateSaveButtonState()
        }
        present(scheduleVC, animated: true)
    }
    
    private func presentCategory() {
        // TODO
    }
    
    private func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}

// MARK: - UIButton.Configuration Extensions
private extension UIButton.Configuration {
    static func filledPrimary(title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = TrackerConstants.Colors.primaryBlack
        config.baseForegroundColor = .white
        config.cornerStyle = .medium
        config.contentInsets = NSDirectionalEdgeInsets(top: 19, leading: 32, bottom: 19, trailing: 32)
        return config
    }
    
    static func filledDisabled(title: String) -> UIButton.Configuration {
        var config = UIButton.Configuration.filled()
        config.title = title
        config.baseBackgroundColor = TrackerConstants.Colors.secondaryGray
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
        charLimitLabel.isHidden = updatedText.count <= Layout.nameMaxLength
        return updatedText.count <= Layout.nameMaxLength
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
        var subtitle: String? = nil
        switch option {
        case .category:
            if let category = settings.category {
                subtitle = category.title.isEmpty ? option.defaultSubtitle : category.title
            } else {
                subtitle = option.defaultSubtitle
            }
        case .schedule:
            if settings.schedule.isEmpty {
                subtitle = option.defaultSubtitle
            } else if settings.schedule.count == Weekday.allCases.count {
                subtitle = Texts.createEveryDay
            } else {
                subtitle = settings.schedule.map { $0.localizedShortName }.joined(separator: ", ")
            }
        }
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
            cell.configure(with: emoji, isSelected: selectedEmojiIndex == indexPath)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ColorCell.reuseIdentifier, for: indexPath) as? ColorCell else { return UICollectionViewCell() }
            let color = TrackerConstants.availableColors[indexPath.row]
            cell.configure(with: color, isSelected: selectedColorIndex == indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == emojiCollectionView {
            selectedEmojiIndex = indexPath
            settings = settings.withEmoji(TrackerConstants.availableEmojis[indexPath.row])
            collectionView.reloadData()
        } else {
            selectedColorIndex = indexPath
            settings = settings.withColor(TrackerConstants.availableColors[indexPath.row])
            collectionView.reloadData()
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
        static let sidePadding: CGFloat = 16
        static let fieldHeight: CGFloat = 75
        static let optionHeight: CGFloat = 75
        static let buttonHeight: CGFloat = 60
        
        static let collectionItemSize: CGFloat = 52
        static let collectionSpacing: CGFloat = 5
        static let cellCornerRadius: CGFloat = 16
        
        static let nameMaxLength: Int = 38
        
        static let headerHeight: CGFloat = 28
        static let collectionRows: Int = 3
        static var collectionHeight: CGFloat {
            headerHeight
            + CGFloat(collectionRows) * collectionItemSize
            + CGFloat(collectionRows - 1) * collectionSpacing
        }
    }
    
    enum Texts {
        static let screenTitle = "Новая привычка"
        static let namePlaceholder = "Введите название трекера"
        static let nameLimit = "Ограничение \(Layout.nameMaxLength) символов"
        static let cancel = "Отменить"
        static let create = "Создать"
        static let createEveryDay = "Каждый день"
    }
}
