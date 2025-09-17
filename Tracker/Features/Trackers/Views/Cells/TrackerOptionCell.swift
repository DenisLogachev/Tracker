import UIKit

enum OptionType: String, CaseIterable {
    case category
    case schedule
    
    var title: String {
        switch self {
        case .category:
            return "Категория"
        case .schedule:
            return "Расписание"
        }
    }
    
    var defaultSubtitle: String {
        switch self {
        case .category:
            return TrackerConstants.Strings.importantCategoryTitle
        case .schedule:
            return ""
        }
    }
    
    var showsSeparator: Bool {
        return self != OptionType.allCases.last
    }
}

final class TrackerOptionCell: UITableViewCell {
    
    // MARK: - UI
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let arrowImageView = UIImageView()
    private let separatorView = UIView()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: - Configuration
    func configure(with title: String, subtitle: String? = nil, showSeparator: Bool = true) {
        titleLabel.text = title
        
        if let subtitle = subtitle, !subtitle.isEmpty {
            subtitleLabel.attributedText = formattedSubtitle(subtitle)
            subtitleLabel.isHidden = false
        } else {
            subtitleLabel.attributedText = nil
            subtitleLabel.isHidden = true
        }
        
        separatorView.isHidden = !showSeparator
    }
    
    // MARK: - Setup
    private func setup() {
        backgroundColor = UIConstants.Colors.background
        selectionStyle = .none
        
        setupTitleLabel()
        setupSubtitleLabel()
        setupArrowImageView()
        setupSeparatorView()
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(arrowImageView)
        contentView.addSubview(separatorView)
        
        setupConstraints()
    }
    
    private func setupTitleLabel() {
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSubtitleLabel() {
        subtitleLabel.font = UIFont.systemFont(ofSize: 17)
        subtitleLabel.textColor = UIConstants.Colors.secondaryGray
        subtitleLabel.numberOfLines = 1
        subtitleLabel.isHidden = true
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupArrowImageView() {
        arrowImageView.image = UIImage(systemName: "chevron.right")
        arrowImageView.tintColor = UIConstants.Colors.secondaryGray
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupSeparatorView() {
        separatorView.backgroundColor = UIConstants.Colors.secondaryGray
        separatorView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: arrowImageView.leadingAnchor, constant: -8),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -12),
            
            arrowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 13),
            arrowImageView.heightAnchor.constraint(equalToConstant: 22),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    private func formattedSubtitle(_ text: String) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 22
        paragraphStyle.maximumLineHeight = 22
        return NSAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: 17),
            .paragraphStyle: paragraphStyle,
            .kern: 0
        ])
    }
}

// MARK: - Reuse ID
extension TrackerOptionCell {
    static let reuseIdentifier = "TrackerOptionCell"
}
