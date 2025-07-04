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
        backgroundColor = UIColor(named: "BackgroundColor")
        
        titleLabel.font = UIFont.systemFont(ofSize: 17)
        titleLabel.textColor = UIColor(named: "PrimaryBlack")
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        daySwitch.onTintColor = UIColor.systemBlue
        daySwitch.translatesAutoresizingMaskIntoConstraints = false
        
        separatorView.backgroundColor = UIColor(named: "SecondaryGray")
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(daySwitch)
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            daySwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            daySwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
}
