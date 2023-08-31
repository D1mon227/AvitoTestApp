import UIKit
import SnapKit

final class ProductDetailView {
    lazy var imageContainerView: UIView = {
        let element = UIView()
        return element
    }()
    
    lazy var blurredImageView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialDark)
        let element = UIVisualEffectView(effect: blurEffect)
        return element
    }()
    
    lazy var image: UIImageView = {
        let element = UIImageView()
        element.contentMode = .scaleAspectFit
        return element
    }()
    
    lazy var productInfoStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 5
        element.alignment = .leading
        element.distribution = .fill
        return element
    }()
    
    lazy var titleLabel: UILabel = {
        let element = UILabel()
        element.textColor = .blackDay
        element.numberOfLines = 0
        element.textAlignment = .left
        element.font = .headlineRegular
        return element
    }()

    lazy var priceLabel: UILabel = {
        let element = UILabel()
        element.textColor = .blackDay
        element.font = .headlineBold2
        element.textAlignment = .left
        return element
    }()
    
    lazy var addressLabel: UILabel = {
        let element = UILabel()
        element.textColor = .blackDay
        element.font = .bodyRegular
        return element
    }()
    
    lazy var dateLabel: UILabel = {
        let element = UILabel()
        element.textColor = .gray
        element.font = .caption1
        return element
    }()
    
    lazy var tableView: UITableView = {
        let element = UITableView()
        element.separatorStyle = .none
        element.backgroundColor = .backgroundDay
        element.isScrollEnabled = false
        return element
    }()
}
