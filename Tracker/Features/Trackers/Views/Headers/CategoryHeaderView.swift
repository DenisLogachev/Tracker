import UIKit

final class CategoryHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "CategoryHeaderView"
    
    private let titleLabel = UILabel()
    
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
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.textColor = UIColor(named: "PrimaryBlack") ?? .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.numberOfLines = 1
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = 18
        paragraphStyle.maximumLineHeight = 18
        let attributed = NSAttributedString(string: "", attributes: [
            .font: titleLabel.font!,
            .paragraphStyle: paragraphStyle,
            .kern: 0
        ])
        titleLabel.attributedText = attributed
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
