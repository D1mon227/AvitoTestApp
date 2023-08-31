import UIKit
import SnapKit

final class StartPageViewController: UIViewController, StartPageViewControllerProtocol {
    var presenter: StartPagePresenterProtocol?
    private var alertService: AlertServiceProtocol?
    private var sections = [Section(type: .categories),
                            Section(type: .products)]
    private var selectedIndex = IndexPath(item: 0, section: 0)
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let element = UICollectionView(frame: .zero, collectionViewLayout: layout)
        element.backgroundColor = .backgroundDay
        element.isMultipleTouchEnabled = false
        return element
    }()
    
    init(presenter: StartPagePresenterProtocol?) {
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
        setupCollectionView()
        presenter?.fetchProducts()
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.performBatchUpdates {
                self.collectionView.reloadSections(IndexSet(integer: 1))
            }
        }
    }
    
    func showErrorAlert() {
        let model = Alert(title: "Ошибка(",
                          message: "Не удалось загрузить данные",
                          leftButton: "Ок",
                          rightButton: "Повторить") { [weak self] in
            guard let self = self else { return }
            self.presenter?.fetchProducts()
        }
        alertService?.showAlert(model: model)
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CategoriesCollectionViewCell.self,
                                forCellWithReuseIdentifier: CategoriesCollectionViewCell.identifier)
        collectionView.register(ProductsCollectionViewCell.self,
                                forCellWithReuseIdentifier: ProductsCollectionViewCell.identifier)
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ in
            guard let self = self else { return nil }
            let section = self.sections[sectionIndex]
            switch section.type {
            case .categories:
                return self.createCategoriesSection()
            case .products:
                return self.createProductsSection()
            }
        }
    }
    
    private func createCategoriesSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .estimated(150),
                              heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .estimated(150),
                              heightDimension: .absolute(30)),
            subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 10, leading: 16, bottom: 16, trailing: 16)
        return section
    }
    
    private func createProductsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(
            layoutSize: .init(widthDimension: .absolute((collectionView.bounds.width - 40) / 2),
                              heightDimension: .fractionalHeight(1)))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: .init(widthDimension: .fractionalWidth(1),
                              heightDimension: .absolute(((collectionView.bounds.width - 40) / 2) + 115)),
            subitems: [item])
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8
        section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
        return section
    }
}

//MARK: UICollectionViewDataSource
extension StartPageViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch sections[section].type {
        case .categories:
            return presenter?.categories.count ?? 0
        case .products:
            return presenter?.products.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch sections[indexPath.section].type {
        case .categories:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as? CategoriesCollectionViewCell,
                  let category = presenter?.categories[indexPath.row] else { return UICollectionViewCell() }
            
            let isSelected = (indexPath == selectedIndex)
            cell.categoryLabel.textColor = isSelected ? .blackDay : .gray
            cell.configureCell(topicName: category)
            
            return cell
        case .products:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCollectionViewCell.identifier, for: indexPath) as? ProductsCollectionViewCell,
                  let product = presenter?.products[indexPath.row] else { return UICollectionViewCell() }
            
            cell.configureCell(model: product)
            
            return cell
        }
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension StartPageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let productID = presenter?.products[indexPath.row].id else { return }
        
        switch sections[indexPath.section].type {
        case .categories:
            guard let categories = presenter?.categories[indexPath.row],
                  let cell = collectionView.cellForItem(at: indexPath) as? CategoriesCollectionViewCell else { return }
            cell.categoryLabel.textColor = cell.isSelected ? .blackDay : .gray
            let previousIndex = selectedIndex
            selectedIndex = indexPath
            collectionView.reloadItems(at: [previousIndex, indexPath].compactMap { $0 })
            switch categories {
            case "Свежие":
                presenter?.sortProducts(by: .bydate)
            case "Дешевые":
                presenter?.sortProducts(by: .fromCheap)
            case "Дорогие":
                presenter?.sortProducts(by: .fromExpensive)
            case "A-Z":
                presenter?.sortProducts(by: .fromAtoZ)
            case "Z-A":
                presenter?.sortProducts(by: .fromZtoA)
            default:
                break
            }
        case .products:
            presenter?.switchToProductDetailsVC(id: productID)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CategoriesCollectionViewCell else { return }
        cell.categoryLabel.textColor = .gray
    }
}

extension StartPageViewController {
    private func setupViews() {
        view.backgroundColor = .backgroundDay
        view.addSubview(collectionView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
