import Foundation

struct ModuleFactory {
    static func makeStartPageModule() -> StartPageViewController {
        let presenter = StartPagePresenter()
        let viewController = StartPageViewController(presenter: presenter)
        presenter.view = viewController
        
        return viewController
    }
    
    
}
