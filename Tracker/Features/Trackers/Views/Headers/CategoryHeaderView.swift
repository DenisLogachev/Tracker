import UIKit

final class CategoryHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "CategoryHeaderView"
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        label.textColor = UIConstants.Colors.primaryBlack
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var title: String? {
        didSet { titleLabel.text = title }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}
