import UIKit

final class TrackerCell: UICollectionViewCell {
    static let reuseIdentifier = "TrackerCell"
    
    // MARK: - UI Elements
    private let emojiLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private let emojiBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = .white
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.textColor = UIConstants.Colors.primaryBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.layer.cornerRadius = 17
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let cardView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = UIConstants.Layout.cellCornerRadius
        view.layer.borderWidth = 1
        view.layer.borderColor = UIConstants.Colors.secondaryGray.withAlphaComponent(0.3).cgColor
        view.clipsToBounds = true
        return view
    }()
    
    private let bottomContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let pinImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: UIConstants.Images.pinIcon)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    // MARK: - Callback
    var onAction: (() -> Void)?
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Configuration
    func configure(with viewModel: TrackerCellViewModel) {
        emojiLabel.text = viewModel.emoji
        nameLabel.text = viewModel.title
        countLabel.text = formattedDayCount(viewModel.completedDays)
        configureActionButton(isCompleted: viewModel.isCompleted, isFuture: viewModel.isFuture, color: viewModel.color)
        cardView.backgroundColor = viewModel.color
        pinImageView.isHidden = !viewModel.isPinned
    }
    
    func updateActionButton(isCompleted: Bool, isFuture: Bool, color: UIColor) {
        configureActionButton(isCompleted: isCompleted, isFuture: isFuture, color: color)
    }
    
    func updateCountLabel(_ count: Int) {
        countLabel.text = formattedDayCount(count)
    }
    
    private func configureActionButton(isCompleted: Bool, isFuture: Bool, color: UIColor) {
        let imageName = isCompleted ? "checkmark" : UIConstants.Images.plusIcon
        actionButton.setImage(UIImage(systemName: imageName), for: .normal)
        actionButton.backgroundColor = color
        actionButton.alpha = isCompleted ? 0.3 : (isFuture ? 0.5 : 1.0)
        actionButton.isEnabled = !isFuture
    }
    
    private func formattedDayCount(_ count: Int) -> String {
        let rem100 = count % 100
        let rem10 = count % 10
        let suffix: String
        
        if rem100 >= 11 && rem100 <= 14 {
            suffix = UIConstants.TrackerCell.daysSuffix[2]
        } else {
            switch rem10 {
            case 1: suffix = UIConstants.TrackerCell.daysSuffix[0]
            case 2...4: suffix = UIConstants.TrackerCell.daysSuffix[1]
            default: suffix = UIConstants.TrackerCell.daysSuffix[2]
            }
        }
        return "\(count) \(suffix)"
    }
    
    // MARK: - Setup
    private func setup() {
        contentView.backgroundColor = .clear
        contentView.layer.masksToBounds = false
        
        contentView.addSubview(cardView)
        cardView.addSubview(emojiBackgroundView)
        emojiBackgroundView.addSubview(emojiLabel)
        cardView.addSubview(nameLabel)
        cardView.addSubview(pinImageView)
        
        contentView.addSubview(bottomContainerView)
        bottomContainerView.addSubview(countLabel)
        bottomContainerView.addSubview(actionButton)
        
        
        NSLayoutConstraint.activate([
            // Card View
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90),
            
            // Emoji background
            emojiBackgroundView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: UIConstants.Layout.emojiSize),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: UIConstants.Layout.emojiSize),
            
            // Emoji label
            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            
            // Name label
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            nameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            
            // Pin image view
            pinImageView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            pinImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            pinImageView.widthAnchor.constraint(equalToConstant: 12),
            pinImageView.heightAnchor.constraint(equalToConstant: 12),
            
            // Bottom container
            bottomContainerView.topAnchor.constraint(equalTo: cardView.bottomAnchor),
            bottomContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bottomContainerView.heightAnchor.constraint(equalToConstant: 58),
            
            // Count label
            countLabel.leadingAnchor.constraint(equalTo: bottomContainerView.leadingAnchor, constant: 12),
            countLabel.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor),
            
            // Action button
            actionButton.trailingAnchor.constraint(equalTo: bottomContainerView.trailingAnchor, constant: -12),
            actionButton.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor),
            actionButton.widthAnchor.constraint(equalToConstant: UIConstants.Layout.actionButtonSize),
            actionButton.heightAnchor.constraint(equalToConstant: UIConstants.Layout.actionButtonSize)
        ])
        
        actionButton.addTarget(self, action: #selector(actionTapped), for: .touchUpInside)
    }
    
    // MARK: - Actions
    @objc private func actionTapped() {
        onAction?()
    }
}
