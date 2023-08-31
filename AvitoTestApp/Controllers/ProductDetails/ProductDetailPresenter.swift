import Foundation

final class ProductDetailPresenter: ProductDetailPresenterProtocol {
    weak var view: ProductDetailViewControllerProtocol?
    private let networkManager: NetworkManager
    private let appCoordinator: AppCoordinator
    private var productID: String
    
    var productInfo: ProductInfo? {
        didSet {
            if let productInfo = self.productInfo {
                view?.updateProductImage(model: productInfo)
                view?.updateTableView()
            }
        }
    }
    
    init(networkManager: NetworkManager, appCoordinator: AppCoordinator, id: String) {
        self.networkManager = networkManager
        self.appCoordinator = appCoordinator
        self.productID = id
    }
    
    func fetchProductInformation() {
        UIBlockingProgressHUD.show()
        
        let urlString = Resources.Network.baseURL + Resources.Network.Paths.detailsPage + "\(productID).json"
        guard let url = URL(string: urlString) else { return }
        networkManager.fetchData(for: url, type: ProductInfo.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.productInfo = data
            case .failure(_):
                self.view?.showErrorAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
}
