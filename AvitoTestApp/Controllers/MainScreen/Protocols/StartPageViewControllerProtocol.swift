import Foundation

protocol StartPageViewControllerProtocol: AnyObject {
    var presenter: StartPagePresenterProtocol? { get set }
    func reloadCollectionView()
}
