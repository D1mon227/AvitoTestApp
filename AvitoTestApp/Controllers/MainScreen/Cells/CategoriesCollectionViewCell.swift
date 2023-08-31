import UIKit
import SnapKit

final class CategoriesCollectionViewCell: UICollectionViewCell {
    lazy var categoryLabel: UILabel = {
        let element = UILabel()
        element.numberOfLines = 1
        element.textAlignment = .center
        element.font = .headlineBold1
        return element
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(topicName: String) {
        categoryLabel.text = topicName
    }
    
    func configureTextColor(isSelected: Bool) {
        if isSelected == true {
            categoryLabel.textColor = .blackDay
        } else {
            categoryLabel.textColor = .gray
        }
    }
    
    private func setupView() {
        addSubview(categoryLabel)
    }
    
    private func setConstraints() {
        categoryLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
