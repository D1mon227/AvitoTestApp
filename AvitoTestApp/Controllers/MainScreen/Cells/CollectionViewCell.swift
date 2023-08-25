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
    
    private lazy var productDescription: UILabel = {
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
    
    func configureCell(image: UIImage?,
                       decsription: String,
                       price: String,
                       location: String,
                       time: String) {
        productImage.image = image
        productDescription.text = decsription
        productPrice.text = price
        productLocation.text = location
        productTime.text = time
    }
    
    private func setupViews() {
        backgroundColor = .backgroundDay
        addSubview(productImage)
        addSubview(productDescription)
        addSubview(productPrice)
        addSubview(productLocation)
        addSubview(productTime)
    }
    
    private func setupConstraints() {
        productImage.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(productImage.snp.width)
        }
        
        productDescription.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(productImage.snp.bottom).offset(7)
        }
        
        productPrice.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(productDescription.snp.bottom).offset(7)
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
