import UIKit
import SnapKit

private enum Constraints {
    static let leadingTrailingOffset: CGFloat = 16
}

final class ProductDetailTableViewCell: UITableViewCell {
    private lazy var descriptionLabel: UILabel = {
        let element = UILabel()
        element.textColor = .blackDay
        element.font = .bodyRegular
        element.textAlignment = .left
        element.numberOfLines = 0
        element.sizeToFit()
        return element
    }()
    
    private lazy var contactStackeView: UIStackView = {
        let element = UIStackView()
        element.axis = .vertical
        element.spacing = 5
        element.alignment = .leading
        element.distribution = .fill
        return element
    }()
    
    private lazy var emailStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 2
        element.alignment = .leading
        element.distribution = .fill
        return element
    }()
    
    private lazy var phoneNumberStackView: UIStackView = {
        let element = UIStackView()
        element.axis = .horizontal
        element.spacing = 5
        element.alignment = .leading
        element.distribution = .fill
        return element
    }()
    
    private lazy var emailLabel: UILabel = {
        let element = UILabel()
        element.textColor = .gray
        element.textAlignment = .left
        element.text = "Email: "
        element.font = .bodyRegular
        element.sizeToFit()
        return element
    }()
    
    private lazy var email: UILabel = {
        let element = UILabel()
        element.textColor = .blackDay
        element.textAlignment = .left
        element.font = .bodyRegular
        element.sizeToFit()
        return element
    }()
    
    private lazy var phoneNumberLabel: UILabel = {
        let element = UILabel()
        element.textColor = .gray
        element.textAlignment = .left
        element.text = "Телефон: "
        element.font = .bodyRegular
        element.sizeToFit()
        return element
    }()
    
    private lazy var phoneNumber: UILabel = {
        let element = UILabel()
        element.textColor = .blackDay
        element.textAlignment = .left
        element.font = .bodyRegular
        element.sizeToFit()
        return element
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .backgroundDay
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDescription(description: String) {
        contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constraints.leadingTrailingOffset)
            make.top.bottom.equalToSuperview()
        }
        
        descriptionLabel.text = description
    }
    
    func configureContactInfo(email: String, phoneNumber: String) {
        emailStackView.addArrangedSubview(emailLabel)
        emailStackView.addArrangedSubview(self.email)
        phoneNumberStackView.addArrangedSubview(phoneNumberLabel)
        phoneNumberStackView.addArrangedSubview(self.phoneNumber)
        contactStackeView.addArrangedSubview(emailStackView)
        contactStackeView.addArrangedSubview(phoneNumberStackView)
        contentView.addSubview(contactStackeView)
        contactStackeView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constraints.leadingTrailingOffset)
        }
        
        self.email.text = email
        self.phoneNumber.text = phoneNumber
    }
}
