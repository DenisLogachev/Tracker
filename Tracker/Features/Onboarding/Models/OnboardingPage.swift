import UIKit

struct OnboardingPage {
    let image: UIImage?
    let titleText: String
    let showsActionButton: Bool
    let actionTitle: String?

    init(image: UIImage?, titleText: String, showsActionButton: Bool, actionTitle: String?, isAdvanceAction: Bool = true) {
        self.image = image
        self.titleText = titleText
        self.showsActionButton = showsActionButton
        self.actionTitle = actionTitle
    }
}



