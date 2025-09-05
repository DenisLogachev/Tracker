import UIKit

final class OnboardingPageContentViewController: UIViewController {
    // MARK: - UI
    private let imageView = UIImageView()
    private let centerTitleLabel = UILabel()
    private let actionButton = UIButton(type: .system)
    
    // MARK: - Layout constants
    private enum Layout {
        static let horizontalInset: CGFloat = 16
        static let buttonHeight: CGFloat = 60
        static let buttonBottomInset: CGFloat = 50
        static let indicatorSpacing: CGFloat = 24
        static let titleFontSize: CGFloat = 32
        static let buttonCornerRadius: CGFloat = 16
    }
    
    // MARK: - Properties
    private let page: OnboardingPage
    var onAction: (() -> Void)?
    
    // MARK: - Init
    init(page: OnboardingPage) {
        self.page = page
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupViews()
        apply(page: page)
    }
    
    // MARK: - Setup
    private func setupViews() {
        // Background image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        // Center title
        centerTitleLabel.font = UIFont.systemFont(ofSize: Layout.titleFontSize, weight: .bold)
        centerTitleLabel.textAlignment = .center
        centerTitleLabel.numberOfLines = 2
        centerTitleLabel.textColor = .label
        centerTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(centerTitleLabel)
        
        // Button
        actionButton.titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.backgroundColor = .black
        actionButton.layer.cornerRadius = Layout.buttonCornerRadius
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.addTarget(self, action: #selector(handleAction), for: .touchUpInside)
        view.addSubview(actionButton)
        
        let layoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // Background fills the screen
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Title centered
            centerTitleLabel.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor),
            centerTitleLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: Layout.horizontalInset),
            centerTitleLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -Layout.horizontalInset),
            
            // Button
            actionButton.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: Layout.horizontalInset),
            actionButton.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -Layout.horizontalInset),
            actionButton.heightAnchor.constraint(equalToConstant: Layout.buttonHeight),
            actionButton.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -Layout.buttonBottomInset),
        ])
    }
    
    private func apply(page: OnboardingPage) {
        imageView.image = page.image
        centerTitleLabel.text = page.titleText
        actionButton.isHidden = !page.showsActionButton
        actionButton.setTitle(page.actionTitle, for: .normal)
    }
    
    // MARK: - Actions
    @objc private func handleAction() {
        onAction?()
    }
}
