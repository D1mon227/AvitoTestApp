import UIKit
import SnapKit

final class ProductDetailTableViewHeader: UITableViewHeaderFooterView {
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .blackDay
        label.font = .boldSystemFont(ofSize: 20)
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(headerLabel)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String) {
        headerLabel.text = text
    }
    
    private func setupConstraints() {
        headerLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
    }
}
