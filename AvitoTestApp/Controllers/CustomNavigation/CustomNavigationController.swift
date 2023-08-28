import UIKit

final class CustomNavigationController: UINavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.isEmpty {
            if let navBar = viewController.navigationController?.navigationBar {
                navBar.isHidden = true
            }
        } else {
            let backButton = UIButton(type: .system)
            backButton.setImage(Resources.Images.backButton, for: .normal)
            backButton.tintColor = .blackDay
            backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
            let backButtonBarItem = UIBarButtonItem(customView: backButton)
            viewController.navigationItem.leftBarButtonItem = backButtonBarItem
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    @objc private func backButtonTapped() {
        popViewController(animated: true)
    }
}
