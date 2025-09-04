import UIKit

final class OnboardingPageViewController: UIPageViewController {
    
    // MARK: - Data
    private var pages: [OnboardingPage] = []
    private var viewControllersCache: [UIViewController] = []
    var onFinish: (() -> Void)?
    
    // MARK: - UI
    private let pageControl = UIPageControl()
    
    // MARK: - Init
    init(pages: [OnboardingPage]) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        self.pages = pages
        self.viewControllersCache = pages.map { OnboardingPageViewController.makeContentVC(for: $0) }
        wireActions()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        delegate = self
        
        if let first = viewControllersCache.first {
            setViewControllers([first], direction: .forward, animated: false)
        }
        
        setupPageControl()
    }
    
    // MARK: - Setup
    private func setupPageControl() {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -120),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private static func makeContentVC(for page: OnboardingPage) -> UIViewController {
        let vc = OnboardingPageContentViewController(page: page)
        return vc
    }
    
    private func wireActions() {
        for controller in viewControllersCache {
            guard let content = controller as? OnboardingPageContentViewController else { continue }
            content.onAction = { [weak self] in
                self?.onFinish?()
            }
        }
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllersCache.firstIndex(of: viewController) else { return nil }
        if index == 0 {
            return viewControllersCache.last
        }
        return viewControllersCache[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllersCache.firstIndex(of: viewController) else { return nil }
        if index == viewControllersCache.count - 1 {
            return viewControllersCache.first
        }
        return viewControllersCache[index + 1]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let current = pageViewController.viewControllers?.first,
              let index = viewControllersCache.firstIndex(of: current) else { return }
        
        pageControl.currentPage = index
    }
}

// MARK: - Factory for demo
extension OnboardingPageViewController {
    static func demo() -> OnboardingPageViewController {
        let samplePages: [OnboardingPage] = [
            OnboardingPage(image: UIImage(named: "onbording1"), titleText: "Отслеживайте только то, что хотите", subtitleText: nil, showsActionButton: true, actionTitle: "Вот это технологии!"),
            OnboardingPage(image: UIImage(named: "onbording2"), titleText: "Даже если это  не литры воды и йога", subtitleText: nil, showsActionButton: true, actionTitle: "Вот это технологии!")
        ]
        return OnboardingPageViewController(pages: samplePages)
    }
}
