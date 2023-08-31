import Foundation

protocol StartPageViewControllerProtocol: AlertPresenterDelegate {
    var presenter: StartPagePresenterProtocol? { get set }
    func reloadCollectionView()
    func showErrorAlert()
}
