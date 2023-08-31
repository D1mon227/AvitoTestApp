import UIKit

final class AppCoordinator {
    private let window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func switchToProductDetailsVC(id: String) {
        let productDetailsVC = ModuleFactory.makeProductDetailsModule(id: id, appCoordinator: self)
        guard let navController = window?.rootViewController as? CustomNavigationController else { return }
        navController.pushViewController(productDetailsVC, animated: true)
    }
}
