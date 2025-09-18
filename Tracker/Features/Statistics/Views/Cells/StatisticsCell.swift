import UIKit

final class StatisticsCell: UITableViewCell {
    static let reuseIdentifier = "StatisticsCell"
    
    // MARK: - Properties
    private var gradientLayer: CAGradientLayer?
    
    // MARK: - UI Components
    private lazy var cardView: UIView = {
        let view = UIView()
        view.backgroundColor = UIConstants.Colors.screenBackground
        view.layer.cornerRadius = UIConstants.Statistics.Layout.cardCornerRadius
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIConstants.Statistics.Layout.titleFontSize, weight: .bold)
        label.textColor = UIConstants.Colors.primaryBlack
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: UIConstants.Statistics.Layout.subtitleFontSize, weight: .medium)
        label.textColor = UIConstants.Colors.primaryBlack
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        
        contentView.addSubview(cardView)
        cardView.addSubview(valueLabel)
        cardView.addSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UIConstants.Statistics.Layout.cardBottomSpacing),
            cardView.heightAnchor.constraint(equalToConstant: UIConstants.Statistics.Layout.cardHeight),
            
            valueLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: UIConstants.Statistics.Layout.cardPadding),
            valueLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -UIConstants.Statistics.Layout.cardPadding),
            valueLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: UIConstants.Statistics.Layout.cardPadding),
            
            subtitleLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: UIConstants.Statistics.Layout.cardPadding),
            subtitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -UIConstants.Statistics.Layout.cardPadding),
            subtitleLabel.topAnchor.constraint(equalTo: valueLabel.bottomAnchor, constant: UIConstants.Statistics.Layout.titleBottomSpacing),
            subtitleLabel.bottomAnchor.constraint(lessThanOrEqualTo: cardView.bottomAnchor, constant: -UIConstants.Statistics.Layout.cardPadding)
        ])
    }
    
    // MARK: - Configuration
    func configure(with item: StatisticsItem) {
        valueLabel.text = item.value
        subtitleLabel.text = item.title
        
        if gradientLayer == nil {
            applyGradient()
        }
    }
    
    // MARK: - Private Methods
    private func applyGradient() {
        guard gradientLayer == nil else { return }
        
        let newGradientLayer = CAGradientLayer()
        newGradientLayer.colors = UIConstants.Statistics.Colors.gradient.map { $0.cgColor }
        newGradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        newGradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        newGradientLayer.cornerRadius = UIConstants.Statistics.Layout.cardCornerRadius
        newGradientLayer.frame = cardView.bounds

        let maskLayer = createMaskLayer()
        newGradientLayer.mask = maskLayer
        cardView.layer.addSublayer(newGradientLayer)
        gradientLayer = newGradientLayer
    }
    
    private func createMaskLayer() -> CAShapeLayer {
        let maskLayer = CAShapeLayer()
        let path = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: UIConstants.Statistics.Layout.cardCornerRadius)
        let innerPath = UIBezierPath(roundedRect: CGRect(
            x: UIConstants.Statistics.Layout.gradientBorderWidth,
            y: UIConstants.Statistics.Layout.gradientBorderWidth,
            width: cardView.bounds.width - UIConstants.Statistics.Layout.gradientBorderWidth * 2,
            height: cardView.bounds.height - UIConstants.Statistics.Layout.gradientBorderWidth * 2
        ), cornerRadius: UIConstants.Statistics.Layout.gradientInnerCornerRadius)
        path.append(innerPath.reversing())
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        return maskLayer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let gradientLayer = gradientLayer else { return }
        
        if gradientLayer.frame != cardView.bounds {
            gradientLayer.frame = cardView.bounds
            
            if let maskLayer = gradientLayer.mask as? CAShapeLayer {
                let path = UIBezierPath(roundedRect: cardView.bounds, cornerRadius: UIConstants.Statistics.Layout.cardCornerRadius)
                let innerPath = UIBezierPath(roundedRect: CGRect(
                    x: UIConstants.Statistics.Layout.gradientBorderWidth,
                    y: UIConstants.Statistics.Layout.gradientBorderWidth,
                    width: cardView.bounds.width - UIConstants.Statistics.Layout.gradientBorderWidth * 2,
                    height: cardView.bounds.height - UIConstants.Statistics.Layout.gradientBorderWidth * 2
                ), cornerRadius: UIConstants.Statistics.Layout.gradientInnerCornerRadius)
                path.append(innerPath.reversing())
                maskLayer.path = path.cgPath
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        gradientLayer?.removeFromSuperlayer()
        gradientLayer = nil
    }
    
}
