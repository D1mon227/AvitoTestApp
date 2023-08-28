import Foundation

final class StartPagePresenter: StartPagePresenterProtocol {
    weak var view: StartPageViewControllerProtocol?
    private let networkManager: NetworkManager
    private let appCoordinator: AppCoordinator
    
    var products: [Products]? {
        didSet {
            view?.reloadCollectionView()
        }
    }
    
    init(networkManager: NetworkManager, appCoordinator: AppCoordinator) {
        self.networkManager = networkManager
        self.appCoordinator = appCoordinator
    }
    
    func fetchProducts() {
        networkManager.fetchProducts { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.products = data
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func switchToProductDetailsVC(id: String) {
        appCoordinator.switchToProductDetailsVC(id: id)
    }
}
