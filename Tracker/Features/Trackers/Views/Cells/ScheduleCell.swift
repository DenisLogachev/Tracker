import UIKit

final class ScheduleCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let daySwitch = UISwitch()
    private let separatorView = UIView()
    var onSwitchChanged: ((Bool) -> Void)?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func configure(with title: String, isOn: Bool, showSeparator: Bool = true) {
        titleLabel.text = title
        daySwitch.isOn = isOn
        separatorView.isHidden = !showSeparator
        daySwitch.removeTarget(self, action: #selector(switchChanged), for: .valueChanged)
        daySwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
    }
    
    @objc private func switchChanged() {
        onSwitchChanged?(daySwitch.isOn)
    }
    
    private func setup() {
        selectionStyle = .none
        backgroundColor = UIConstants.Colors.background
        titleLabel.font = UIFont.systemFont(ofSize: Layout.titleFontSize)
        titleLabel.textColor = UIConstants.Colors.primaryBlack
        daySwitch.onTintColor = UIColor.systemBlue
        separatorView.backgroundColor = UIConstants.Colors.secondaryGray
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        [titleLabel, daySwitch, separatorView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.horizontalInset),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            daySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.horizontalInset),
            daySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Layout.horizontalInset),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Layout.horizontalInset),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: Layout.separatorHeight)
        ])
    }
}

private extension ScheduleCell {
    enum Layout {
        static let horizontalInset: CGFloat = 16
        static let separatorHeight: CGFloat = 0.5
        static let titleFontSize: CGFloat = 17
    }
}
