import UIKit
import SnapKit

final class ProductDetailViewController: UIViewController, ProductDetailViewControllerProtocol, DateConvertable {
    var presenter: ProductDetailPresenterProtocol?
    private let productDetailView = ProductDetailView()
    
    init(presenter: ProductDetailPresenterProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupTableView()
        presenter?.fetchProductInformation()
    }
    
    func updateProductImage(model: ProductInfo) {
        productDetailView.image.setImage(with: model.image_url)
        productDetailView.titleLabel.text = model.title
        productDetailView.priceLabel.text = model.price
        productDetailView.addressLabel.text = "\(model.location), \(model.address)"
        productDetailView.dateLabel.text = convert(date: model.created_date)
        
    }
    
    func updateTableView() {
        productDetailView.tableView.reloadData()
    }
    
    private func setupTableView() {
        productDetailView.tableView.register(ProductDetailTableViewCell.self, forCellReuseIdentifier: ProductDetailTableViewCell.identifier)
        productDetailView.tableView.register(ProductDetailTableViewHeader.self, forHeaderFooterViewReuseIdentifier: ProductDetailTableViewHeader.identifier)
        productDetailView.tableView.dataSource = self
        productDetailView.tableView.delegate = self
    }
}

extension ProductDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductDetailTableViewCell.identifier, for: indexPath) as? ProductDetailTableViewCell,
              let info = presenter?.productInfo else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            cell.configureDescription(description: info.description)
        case 1:
            cell.configureContactInfo(email: info.email, phoneNumber: info.phone_number)
        default:
            break
        }
        
        return cell
    }
}

extension ProductDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: ProductDetailTableViewHeader.identifier) as? ProductDetailTableViewHeader else { return UIView() }

        switch section {
        case 0:
            header.configure(text: "Описание")
        case 1:
            header.configure(text: "Контактная информация")
        default:
            return nil
        }

        return header
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        false
    }
}

extension ProductDetailViewController {
    private func setupViews() {
        view.backgroundColor = .backgroundDay
        view.addSubview(productDetailView.imageContainerView)
        productDetailView.imageContainerView.addSubview(productDetailView.blurredImageView)
        productDetailView.imageContainerView.addSubview(productDetailView.image)
        productDetailView.productInfoStackView.addArrangedSubview(productDetailView.titleLabel)
        productDetailView.productInfoStackView.addArrangedSubview(productDetailView.priceLabel)
        productDetailView.productInfoStackView.addArrangedSubview(productDetailView.addressLabel)
        productDetailView.productInfoStackView.addArrangedSubview(productDetailView.dateLabel)
        view.addSubview(productDetailView.productInfoStackView)
        view.addSubview(productDetailView.tableView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        productDetailView.imageContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(250)
        }
        
        productDetailView.blurredImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        productDetailView.image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        productDetailView.productInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(productDetailView.imageContainerView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        productDetailView.tableView.snp.makeConstraints { make in
            make.top.equalTo(productDetailView.productInfoStackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
