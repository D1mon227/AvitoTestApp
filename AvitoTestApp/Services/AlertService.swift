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
        let alert: UIAlertController
        
        if model.style == .alert {
            alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
            let leftAction = UIAlertAction(title: model.leftButton,
                                           style: .cancel)
            let rightAction = UIAlertAction(title: model.rightButton,
                                            style: .default) { _ in
                model.completion()
            }
            alert.addAction(leftAction)
            alert.addAction(rightAction)
        } else {
            alert = UIAlertController(title: nil,
                                      message: nil,
                                      preferredStyle: .actionSheet)
            
            let callAction = UIAlertAction(title: model.leftButton,
                                           style: .default)
            let cancelAction = UIAlertAction(title: model.rightButton,
                                             style: .cancel)
            alert.addAction(callAction)
            alert.addAction(cancelAction)
        }
        delegate?.present(alert, animated: true, completion: nil)
    }
}
