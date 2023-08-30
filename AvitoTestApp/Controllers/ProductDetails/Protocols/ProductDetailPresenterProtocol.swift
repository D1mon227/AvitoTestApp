import Foundation

protocol ProductDetailPresenterProtocol: AnyObject {
    var view: ProductDetailViewControllerProtocol? { get set }
    var productInfo: ProductInfo? { get set }
    func fetchProductInformation()
}
