import UIKit

protocol AlertServiceProtocol: AnyObject {
    func showAlert(model: Alert)
}

protocol AlertPresenterDelegate: AnyObject {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}

final class AlertService: AlertServiceProtocol {
    
    private weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate?) {
        self.delegate = delegate
    }
    
    func showAlert(model: Alert) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        let leftAction = UIAlertAction(title: model.leftButton,
                                       style: .cancel)
        alert.addAction(leftAction)
        let rightAction = UIAlertAction(title: model.rightButton,
                                        style: .default) { _ in
            model.completion()
        }
        alert.addAction(rightAction)
        delegate?.present(alert, animated: true, completion: nil)
    }
}
