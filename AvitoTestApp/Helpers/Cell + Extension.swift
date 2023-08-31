import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        String(describing: self)
    }
}

extension UITableViewCell {
    static var identifier: String {
        String(describing: self)
    }
}

extension UITableViewHeaderFooterView {
    static var identifier: String {
        String(describing: self)
    }
}
