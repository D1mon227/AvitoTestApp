import Foundation

struct ModuleFactory {
    static func makeStartPageModule(appCoordinator: AppCoordinator) -> StartPageViewController {
        let networkManager = NetworkManager()
        let presenter = StartPagePresenter(networkManager: networkManager, appCoordinator: appCoordinator)
        let viewController = StartPageViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
    
    static func makeProductDetailsModule(id: String, appCoordinator: AppCoordinator) -> ProductDetailViewController {
        let networkManager = NetworkManager()
        let presenter = ProductDetailPresenter(networkManager: networkManager, appCoordinator: appCoordinator, id: id)
        let viewController = ProductDetailViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
}
