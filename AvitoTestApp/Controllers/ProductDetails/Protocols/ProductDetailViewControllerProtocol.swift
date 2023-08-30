import Foundation

protocol ProductDetailViewControllerProtocol: AlertPresenterDelegate {
    var presenter: ProductDetailPresenterProtocol? { get set }
    func updateProductImage(model: ProductInfo)
    func updateTableView()
    func showErrorAlert()
}
