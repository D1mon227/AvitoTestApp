import UIKit
import SnapKit

final class CollectionViewCell: UICollectionViewCell {
    private lazy var productImage: UIImageView = {
        let element = UIImageView()
        element.layer.cornerRadius = 8
        element.contentMode = .scaleAspectFill
        element.layer.masksToBounds = true
        return element
    }()
    
    private lazy var productTitle: UILabel = {
        let element = UILabel()
        element.font = .systemFont(ofSize: 15, weight: .regular)
        element.textAlignment = .left
        element.textColor = .blackDay
        element.numberOfLines = 2
        return element
    }()
    
    private lazy var productPrice: UILabel = {
        let element = UILabel()
        element.font = .systemFont(ofSize: 15, weight: .bold)
        element.textAlignment = .left
        element.textColor = .blackDay
        return element
    }()
    
    private lazy var productLocation: UILabel = {
        let element = UILabel()
        element.font = .systemFont(ofSize: 13, weight: .regular)
        element.textAlignment = .left
        element.textColor = .gray
        return element
    }()
    
    private lazy var productTime: UILabel = {
        let element = UILabel()
        element.font = .systemFont(ofSize: 13, weight: .regular)
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
        productTime.text = convert(date: model.created_date)
    }
    
    private func setupViews() {
        backgroundColor = .backgroundDay
        addSubview(productImage)
        addSubview(productTitle)
        addSubview(productPrice)
        addSubview(productLocation)
        addSubview(productTime)
    }
    
    private func setupConstraints() {
        productImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(productImage.snp.width)
        }
        
        productTitle.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(productImage.snp.bottom).offset(7)
        }
        
        productPrice.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(productTitle.snp.bottom).offset(7)
        }
        
        productLocation.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(productPrice.snp.bottom).offset(7)
        }
        
        productTime.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(productLocation.snp.bottom).offset(2)
        }
    }
}
