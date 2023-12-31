import UIKit
import SnapKit

private enum Constraints {
    static let topMainOffset: CGFloat = 7
    static let topOffset: CGFloat = 2
}

final class ProductsCollectionViewCell: UICollectionViewCell, DateConvertable {
    private lazy var productImage: UIImageView = {
        let element = UIImageView()
        element.layer.cornerRadius = 8
        element.contentMode = .scaleAspectFill
        element.layer.masksToBounds = true
        return element
    }()
    
    private lazy var productTitle: UILabel = {
        let element = UILabel()
        element.font = .bodyRegular2
        element.textAlignment = .left
        element.textColor = .blackDay
        element.numberOfLines = 2
        return element
    }()
    
    private lazy var productPrice: UILabel = {
        let element = UILabel()
        element.font = .bodyBold
        element.textAlignment = .left
        element.textColor = .blackDay
        return element
    }()
    
    private lazy var productLocation: UILabel = {
        let element = UILabel()
        element.font = .caption1
        element.textAlignment = .left
        element.textColor = .gray
        return element
    }()
    
    private lazy var productDate: UILabel = {
        let element = UILabel()
        element.font = .caption1
        element.textAlignment = .left
        element.textColor = .gray
        return element
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(model: Products) {
        productImage.setImage(with: model.image_url)
        productTitle.text = model.title
        productPrice.text = model.price
        productLocation.text = model.location
        productDate.text = convert(date: model.created_date)
    }
    
    private func setupViews() {
        backgroundColor = .backgroundDay
        [productImage, productTitle, productPrice, productLocation, productDate].forEach { view in
            addSubview(view)
        }
    }
    
    private func setupConstraints() {
        productImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(productImage.snp.width)
        }
        
        productTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(productImage.snp.bottom).offset(Constraints.topMainOffset)
        }
        
        productPrice.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(productTitle.snp.bottom).offset(Constraints.topMainOffset)
        }
        
        productLocation.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(productPrice.snp.bottom).offset(Constraints.topMainOffset)
        }
        
        productDate.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(productLocation.snp.bottom).offset(Constraints.topOffset)
        }
    }
}
