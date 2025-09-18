import UIKit

final class CategoryEditViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    // MARK: - UI
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = UIConstants.CategoryManagement.editCategory
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
        table.isScrollEnabled = false
        table.separatorStyle = .none
        table.backgroundColor = .clear
        table.layer.cornerRadius = 16
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(UITableViewCell.self, forCellReuseIdentifier: "NameCell")
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
    
    private let charLimitLabel: UILabel = {
        let label = UILabel()
        label.text = UIConstants.CategoryManagement.categoryNameLimit
        label.font = UIFont.systemFont(ofSize: 17)
        label.textColor = UIConstants.Colors.destructiveAccent
        label.textAlignment = .center
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - State
    private let viewModel: CategoryEditViewModel
    private var nameTextField: UITextField?
    var onSave: ((UUID, String) -> Void)?
    
    // MARK: - Init
    init(viewModel: CategoryEditViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = CategoryEditViewModel(categoryId: UUID(), name: "")
        super.init(coder:coder)
        assertionFailure("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIConstants.Colors.screenBackground
        setupUI()
        bind()
        setupKeyboardDismissGesture()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField?.becomeFirstResponder()
    }
    
    private func setupUI() {
        view.addSubview(titleLabel)
        view.addSubview(tableView)
        view.addSubview(charLimitLabel)
        view.addSubview(doneButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 28),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 75),
            
            charLimitLabel.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 8),
            charLimitLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 44),
            charLimitLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -45),
            charLimitLabel.heightAnchor.constraint(equalToConstant: 22),
            
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            doneButton.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func bind() {
        viewModel.onValidityChanged = { [weak self] isValid in
            self?.doneButton.isEnabled = isValid
            self?.doneButton.alpha = isValid ? 1.0 : 0.5
        }
        viewModel.onValidityChanged?(!viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }
    
    // MARK: - Actions
    @objc private func doneTapped() {
        onSave?(viewModel.categoryId, viewModel.name)
        dismiss(animated: true)
    }
    
    // MARK: - Table DataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 1 }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { 75 }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath)
        cell.selectionStyle = .none
        cell.backgroundColor = UIConstants.Colors.background
        
        if nameTextField == nil {
            let tf = UITextField()
            tf.translatesAutoresizingMaskIntoConstraints = false
            tf.font = UIFont.systemFont(ofSize: 17)
            tf.textColor = UIConstants.Colors.primaryBlack
            tf.delegate = self
            tf.placeholder = UIConstants.CategoryManagement.categoryNamePlaceholder
            cell.contentView.addSubview(tf)
            NSLayoutConstraint.activate([
                tf.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                tf.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                tf.centerYAnchor.constraint(equalTo: cell.contentView.centerYAnchor)
            ])
            tf.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
            nameTextField = tf
        }
        nameTextField?.text = viewModel.name
        return cell
    }
    
    // MARK: - UITextField
    @objc private func textChanged(_ textField: UITextField) {
        let raw = textField.text ?? ""
        let limited = String(raw.prefix(UIConstants.TextLimits.nameMaxLength))
        if raw != limited {
            textField.text = limited
        }
        viewModel.updateName(limited)
        charLimitLabel.isHidden = limited.count <= UIConstants.TextLimits.nameMaxLength
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func setupKeyboardDismissGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
}



