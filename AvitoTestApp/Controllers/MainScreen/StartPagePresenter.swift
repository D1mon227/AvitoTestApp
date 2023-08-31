import Foundation

final class StartPagePresenter: StartPagePresenterProtocol {
    weak var view: StartPageViewControllerProtocol?
    private let networkManager: NetworkManager
    private let appCoordinator: AppCoordinator
    
    var categories = ["Свежие", "Дешевые", "Дорогие", "A-Z", "Z-A"]
    var products: [Products] = [] {
        didSet {
            view?.reloadCollectionView()
        }
    }
    
    init(networkManager: NetworkManager, appCoordinator: AppCoordinator) {
        self.networkManager = networkManager
        self.appCoordinator = appCoordinator
    }
    
    func fetchProducts() {
        UIBlockingProgressHUD.show()
        
        let urlString = Resources.Network.baseURL + Resources.Network.Paths.mainPage
        guard let url = URL(string: urlString) else { return }
        networkManager.fetchData(for: url, type: Advertisements.self) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let data):
                self.products = data.advertisements
            case .failure(_):
                self.view?.showErrorAlert()
            }
            UIBlockingProgressHUD.dismiss()
        }
    }
    
    func switchToProductDetailsVC(id: String) {
        appCoordinator.switchToProductDetailsVC(id: id)
    }
    
    func sortProducts(by: Sort) {
        switch by {
        case .bydate:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            products.sort {
                guard let date1 = dateFormatter.date(from: $0.created_date),
                      let date2 = dateFormatter.date(from: $1.created_date) else { return false }
                return date1 > date2
            }
        case .fromCheap:
            products.sort {
                guard let price1 = convertPriceToString(from: $0.price),
                      let price2 = convertPriceToString(from: $1.price) else { return false }
                
                return price1 < price2
            }
        case .fromExpensive:
            products.sort {
                guard let price1 = convertPriceToString(from: $0.price),
                      let price2 = convertPriceToString(from: $1.price) else { return false }
                
                return price1 > price2
            }
        case .fromAtoZ:
            products.sort { $0.title < $1.title }
        case .fromZtoA:
            products.sort { $0.title > $1.title }
        }
    }
    
    private func convertPriceToString(from priceString: String) -> Int? {
        let numbers = priceString.filter { $0.isNumber }
        return Int(numbers)
    }
}
