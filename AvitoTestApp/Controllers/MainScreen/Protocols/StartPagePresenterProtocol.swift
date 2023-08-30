import Foundation

protocol StartPagePresenterProtocol: AnyObject {
    var view: StartPageViewControllerProtocol? { get set }
    var categories: [String] { get }
    var products: [Products] { get }
    func fetchProducts()
    func sortProducts(by: Sort)
    func switchToProductDetailsVC(id: String)
}
