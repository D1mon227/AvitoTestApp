import Foundation

protocol ProductDetailViewControllerProtocol: AnyObject {
    var presenter: ProductDetailPresenterProtocol? { get set }
    func updateProductImage(model: ProductInfo)
    func updateTableView()
}
