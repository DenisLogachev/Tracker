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
        textField.layer.cornerRadius = 16
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
        table.layer.cornerRadius = 16
        table.separatorStyle = .none
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .clear
        table.register(TrackerOptionCell.self, forCellReuseIdentifier: TrackerOptionCell.reuseIdentifier)
        return table
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
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var saveButton: UIButton = {
        let button = UIButton(configuration: .filledDisabled(title: Texts.create))
        button.layer.cornerRadius = 16
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
    
    // MARK: - State
    private var settings: TrackerSettings = {
        var random = TrackerSettings()
        random.setRandomColorAndEmoji()
        return random
    }()
    
    var onCreateTracker: ((Tracker) -> Void)?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupKeyboardDismissGesture()
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(charLimitLabel)
        view.addSubview(optionsTableView)
        view.addSubview(buttonStack)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            nameTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.sidePadding),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.sidePadding),
            nameTextField.heightAnchor.constraint(equalToConstant: Layout.fieldHeight),
            
            charLimitLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            charLimitLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            charLimitLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            charLimitLabel.heightAnchor.constraint(equalToConstant: 22),
            
            optionsTableView.topAnchor.constraint(equalTo: charLimitLabel.bottomAnchor, constant: 20),
            optionsTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.sidePadding),
            optionsTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.sidePadding),
            optionsTableView.heightAnchor.constraint(equalToConstant: CGFloat(OptionType.allCases.count) * Layout.optionHeight),
            
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
        settings.name = text
        charLimitLabel.isHidden = text.count <= 38
        updateSaveButtonState()
    }
    
    @objc private func saveTapped() {
        guard saveButton.isUserInteractionEnabled else { return }
        let tracker = createTracker()
        onCreateTracker?(tracker)
        dismiss(animated: true)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func updateSaveButtonState() {
        let isValid = (!settings.name.isEmpty && !settings.schedule.isEmpty)
        saveButton.configuration = isValid
        ? .filledPrimary(title: Texts.create)
        : .filledDisabled(title: Texts.create)
        saveButton.isUserInteractionEnabled = isValid
    }
    
    private func createTracker() -> Tracker {
        return Tracker(
            id: UUID(),
            name: settings.name,
            color: settings.color ?? .systemGreen,
            emoji: settings.emoji ?? "😪",
            schedule: settings.schedule,
            category: settings.category
        )
    }
    
    private func presentSchedule() {
        let scheduleVC = ScheduleViewController()
        scheduleVC.selectedWeekdays = Set(settings.schedule)
        scheduleVC.onWeekdaysSelected = { [weak self] selected in
            guard let self = self else { return }
            self.settings.schedule = selected.sorted { $0.rawValue < $1.rawValue }
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
        charLimitLabel.isHidden = updatedText.count <= 38
        return updatedText.count <= 38
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
            subtitle = settings.category.isEmpty ? option.defaultSubtitle : settings.category
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

private extension CreateTrackerViewController {
    enum Layout {
        static let sidePadding: CGFloat = 16
        static let fieldHeight: CGFloat = 75
        static let optionHeight: CGFloat = 75
        static let buttonHeight: CGFloat = 60
    }

    enum Texts {
        static let screenTitle = "Новая привычка"
        static let namePlaceholder = "Введите название трекера"
        static let nameLimit = "Ограничение 38 символов"
        static let cancel = "Отменить"
        static let create = "Создать"
        static let createEveryDay = "Каждый день"
    }
}
