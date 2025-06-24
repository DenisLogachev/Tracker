import UIKit

final class TrackersViewController: UIViewController {
    
    // MARK: - UI Components
    private lazy var plusButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var dateLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "GrayBackground")
        view.layer.cornerRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = formattedToday()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Трекеры"
        label.textColor = UIColor(named: "PrimaryText")
        label.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var searchField: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Поиск"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private lazy var placeholderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "PlaceholderImage")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 80),
            imageView.heightAnchor.constraint(equalToConstant: 80)
        ])
        return imageView
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textColor = UIColor(named: "PrimaryText")
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var placeholderStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [placeholderImage, placeholderLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureUI()
        updatePlaceholderVisibility(isEmpty: true)
    }
    
    // MARK: - UI Setup
    private func configureUI() {
        view.addSubview(plusButton)
        view.addSubview(dateLabelView)
        dateLabelView.addSubview(dateLabel)
        view.addSubview(titleLabel)
        view.addSubview(searchField)
        view.addSubview(placeholderStack)
        
        NSLayoutConstraint.activate([
            plusButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            plusButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            plusButton.widthAnchor.constraint(equalToConstant: 42),
            plusButton.heightAnchor.constraint(equalToConstant: 42),
            
            
            dateLabelView.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
            dateLabelView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dateLabelView.heightAnchor.constraint(equalToConstant: 34),
            
            dateLabel.leadingAnchor.constraint(equalTo: dateLabelView.leadingAnchor, constant: 12),
            dateLabel.trailingAnchor.constraint(equalTo: dateLabelView.trailingAnchor, constant: -12),
            dateLabel.topAnchor.constraint(equalTo: dateLabelView.topAnchor, constant: 6),
            dateLabel.bottomAnchor.constraint(equalTo: dateLabelView.bottomAnchor, constant: -6),
            
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            searchField.topAnchor.constraint(equalTo: view.topAnchor, constant: 136),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchField.heightAnchor.constraint(equalToConstant: 36),
            
            placeholderStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderStack.topAnchor.constraint(equalTo: view.topAnchor, constant: 402)
        ])
    }
    
    private func updatePlaceholderVisibility(isEmpty: Bool) {
        placeholderStack.isHidden = !isEmpty
    }
    
    private func formattedToday() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy"
        return formatter.string(from: Date())
    }
    
    // MARK: - Actions
    @objc private func plusButtonTapped() {
        print("Нажата кнопка +")
    }
}
