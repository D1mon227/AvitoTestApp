import UIKit
import SnapKit

private enum Constraints {
    static let heightImage: CGFloat = 250
    static let heightStack: CGFloat = 50
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
        setupTargets()
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
                          rightButton: "Повторить",
                          style: .alert) { [weak self] in
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
    
    private func setupTargets() {
        productDetailView.callButton.addTarget(self, action: #selector(callButtonTapped), for: .touchUpInside)
    }
    
    @objc private func callButtonTapped() {
        guard let phoneNumber = presenter?.productInfo?.phone_number else { return }
        let model = Alert(title: nil,
                          message: nil,
                          leftButton: phoneNumber,
                          rightButton: "Отмена",
                          style: .actionSheet){}
        alertService?.showAlert(model: model)
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
        [productDetailView.blurredImage,
         productDetailView.blurredImageView,
         productDetailView.image].forEach { view in
            productDetailView.imageContainerView.addSubview(view)
        }
        [productDetailView.titleLabel,
         productDetailView.priceLabel,
         productDetailView.addressLabel,
         productDetailView.dateLabel].forEach { label in
            productDetailView.productInfoStackView.addArrangedSubview(label)
        }
        [productDetailView.callButton, productDetailView.writeButton].forEach { button in
            productDetailView.buttonsStack.addArrangedSubview(button)
        }
        [productDetailView.imageContainerView,
         productDetailView.productInfoStackView,
         productDetailView.buttonsStack,
         productDetailView.tableView].forEach { view in
            self.view.addSubview(view)
        }
        setupConstraints()
    }
    
    private func setupConstraints() {
        productDetailView.imageContainerView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constraints.heightImage)
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
        
        productDetailView.callButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        
        productDetailView.writeButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
        }
        
        productDetailView.buttonsStack.snp.makeConstraints { make in
            make.top.equalTo(productDetailView.productInfoStackView.snp.bottom).offset(Constraints.topOffset)
            make.leading.trailing.equalToSuperview().inset(Constraints.leadingTrailingOffset)
            make.height.equalTo(Constraints.heightStack)
        }
        
        productDetailView.tableView.snp.makeConstraints { make in
            make.top.equalTo(productDetailView.buttonsStack.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
