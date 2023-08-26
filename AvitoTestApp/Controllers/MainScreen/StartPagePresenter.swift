import Foundation

final class StartPagePresenter: StartPagePresenterProtocol {
    weak var view: StartPageViewControllerProtocol?
    private let networkManager = NetworkManager.shared
    
    var products: [Products]? {
        didSet {
            view?.reloadCollectionView()
        }
    }
    
    func getData() {
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
}
