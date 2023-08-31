import UIKit
import SnapKit

private enum Constraints {
    static let height: CGFloat = 250
    static let topOffset: CGFloat = 20
    static let leadingTrailingOffset: CGFloat = 16
}

final class ProductDetailViewController: UIViewController, ProductDetailViewControllerProtocol, DateConvertable {
    var presenter: ProductDetailPresenterProtocol?
    private var alertService: AlertServiceProtocol?
    private let productDetailView = ProductDetailView()
    
    init(presenter: ProductDetailPresenterProtocol?) {
        super.init(nibName: nil, bundle: nil)
        self.presenter = presenter
        self.alertService = AlertService(delegate: self)
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
        productDetailView.blurredImage.setImage(with: model.image_url)
        productDetailView.titleLabel.text = model.title
        productDetailView.priceLabel.text = model.price
        productDetailView.addressLabel.text = "\(model.location), \(model.address)"
        productDetailView.dateLabel.text = convert(date: model.created_date)
        
    }
    
    func updateTableView() {
        productDetailView.tableView.reloadData()
    }
    
    func showErrorAlert() {
        let model = Alert(title: "Ошибка(",
                          message: "Не удалось загрузить данные",
                          leftButton: "Ок",
                          rightButton: "Повторить") { [weak self] in
            guard let self else { return }
            self.presenter?.fetchProductInformation()
        }
        alertService?.showAlert(model: model)
    }
    
    private func setupTableView() {
        productDetailView.tableView.register(ProductDetailTableViewCell.self, forCellReuseIdentifier: ProductDetailTableViewCell.identifier)
        productDetailView.tableView.register(ProductDetailTableViewHeader.self, forHeaderFooterViewReuseIdentifier: ProductDetailTableViewHeader.identifier)
        productDetailView.tableView.dataSource = self
        productDetailView.tableView.delegate = self
    }
}

//MARK: UITableViewDataSource
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

//MARK: UITableViewDelegate
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

//MARK: SetupViews
extension ProductDetailViewController {
    private func setupViews() {
        view.backgroundColor = .backgroundDay
        view.addSubview(productDetailView.imageContainerView)
        productDetailView.imageContainerView.addSubview(productDetailView.blurredImage)
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
            make.height.equalTo(Constraints.height)
        }
        
        productDetailView.blurredImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        productDetailView.blurredImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        productDetailView.image.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        productDetailView.productInfoStackView.snp.makeConstraints { make in
            make.top.equalTo(productDetailView.imageContainerView.snp.bottom).offset(Constraints.topOffset)
            make.leading.trailing.equalToSuperview().inset(Constraints.leadingTrailingOffset)
        }
        
        productDetailView.tableView.snp.makeConstraints { make in
            make.top.equalTo(productDetailView.productInfoStackView.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
