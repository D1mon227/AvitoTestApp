import Foundation

protocol StartPagePresenterProtocol: AnyObject {
    var view: StartPageViewControllerProtocol? { get set }
    var products: [Products]? { get }
    func getData()
}