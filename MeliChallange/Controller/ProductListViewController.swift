//
//  ProductListViewController.swift
//  MeliChallange
//
//  Created by Juan Martin Rezk Elso on 10/3/23.
//

import UIKit

let userDefaults = UserDefaults.standard

class ProductListViewController: UIViewController {
    
    private enum Constants {
        static let cornerRadius = CGFloat(5)
        static let rowHeight = CGFloat(150)
    }
    var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        return activityIndicator
    }()
    
    var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    var tableView: UITableView = {
        let tableView = UITableView()
        return tableView
    }()
    
    var searchTableView: UITableView = {
        let searchTableView = UITableView()
        return searchTableView
    }()
    
    var products: [Product] = []
    var searches: [String] = []
    var isFiltering = false
    var position = 0
    var limit = 25
    var paging: Paging?
    
    /// Function used to obtain all the searches so that can be shown on a search history
    func getSearchFromMemory() {
        Utils.getSearches { [weak self] result in
            switch result {
            case .success(let searches):
                self?.searches = searches
                searchTableView.reloadData()
            case .failure(_):
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async {
                    Utils.showAlert(on: self, with: "Error", message: "Ocurrio un error al cargar el historial de busqueda")
                }
            }
        }
    }
    
    /// Function used to add searches to UserDefaults
    /// - Parameter searchedText: search text given by the user
    func addSearchToMyList(searchedText: String) {
        do {
            if !searches.contains(where: {$0 == searchedText}) {
                searches.append(searchedText)
            }
            let encodedData = try JSONEncoder().encode(searches)
            userDefaults.setValue(encodedData, forKey: "mySearches")
        }
        catch {
            DispatchQueue.main.async {
                Utils.showAlert(on: self, with: "Error", message: "Ocurrio un error al agregar la busqueda al historial")
            }
        }
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        configureActivityIndicator()
        configureSearchBar()
        configureTableView()
        configureSearchTableView()
    }
    
    func setUpView() {
        view.backgroundColor = UIColor(red: 1, green: 0.8667, blue: 0, alpha: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    /// Show the table on screen
    func showTable() {
        tableView.isHidden = false
        tableView.reloadData()
    }
    
    /// Show the searchBar on screen
    func showSearchTable() {
        searchTableView.isHidden = false
        searchTableView.reloadData()
    }
    
    /// Show a loader on screen
    func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    //MARK: UI items configuration
    func configureActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.isHidden = true
        view.addSubview(activityIndicator)
        activityIndicator.color = .black
        activityIndicator.style = .large
    }
    
    func configureSearchBar() {
        view.addSubview(searchBar)
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "Buscar en Mercado Libre"
        searchBar.searchTextField.clearButtonMode = .whileEditing
        searchBar.searchTextField.backgroundColor = .white
        searchBar.searchTextField.layer.cornerRadius = 15
        searchBar.searchTextField.clipsToBounds = true
        searchBar.tintColor = .black
        searchBar.barTintColor = UIColor(red: 1, green: 0.8667, blue: 0, alpha: 1)
        setSearchBarConstraints()
        searchBar.delegate = self
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.isHidden = true
        tableView.layer.cornerRadius = Constants.cornerRadius
        tableView.clipsToBounds = true
        tableView.backgroundColor = UIColor(red: 1, green: 0.8667, blue: 0, alpha: 1)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.separatorColor = .lightGray
        tableView.rowHeight = Constants.rowHeight
        setTableViewConstraints()
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: "productCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func configureSearchTableView() {
        view.addSubview(searchTableView)
        searchTableView.isHidden = true
        searchTableView.backgroundColor = .white
        searchTableView.separatorColor = .white
        searchTableView.rowHeight = 40
        setSearchTableViewConstraints()
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "searchCell")
        searchTableView.dataSource = self
        searchTableView.delegate = self
        getSearchFromMemory()
    }
    
    //MARK: UI items constraints
    func setSearchBarConstraints() {
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
    }
    
    func setTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func setSearchTableViewConstraints() {
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 0),
            searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            searchTableView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
    }
    
    func filterAction(searchBarText: String, position: Int, limit: Int) {
        let searchString = searchBarText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        searchTableView.isHidden = true
        searchBar.endEditing(true)
        Facade.shared.filterData(searchText: searchString!, position: position, limit: limit) {
            [weak self] result in
            switch result {
            case .success(let products):
                self?.paging = products.paging
                self?.products = products.results
                self?.isFiltering = true
                DispatchQueue.main.async {
                    self?.searchBar.showsCancelButton = false
                    self?.showTable()
                }
            case .failure(_):
                guard let self = self else {
                    return
                }
                DispatchQueue.main.async {
                    Utils.showAlert(on: self, with: "Error", message: "Ocurrio un error al filtrar las peliculas")
                }
            }
        }
    }
}

extension ProductListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return products.count
        } else {
            return searches.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellToReturn = UITableViewCell()
        if tableView == self.tableView {
            let product = products[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "productCell") as? ProductTableViewCell else {
                return cellToReturn
            }
            cell.setUp(product: product)
            cellToReturn = cell
        } else {
            let search = searches[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as? SearchTableViewCell else {
                return cellToReturn
            }
            cell.searchText.text = search
            cell.searchIconImage.image = UIImage(named: "lupa ")
            cellToReturn = cell
        }
        return cellToReturn
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.tableView {
            let product = products[indexPath.row]
            let detailVC = DetailViewController()
            detailVC.product = product
            tableView.deselectRow(at: indexPath, animated: true)
            navigationController?.pushViewController(detailVC, animated: true)
        } else {
            let selectedText = searches[indexPath.row]
            showActivityIndicator()
            searchBar.text = selectedText
            tableView.deselectRow(at: indexPath, animated: true)
            filterAction(searchBarText: selectedText, position: position, limit: limit)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let searchBarText = searchBar.text else {
            return
        }
        if indexPath.row + 1 == products.count && products.count > 25 && self.products.count < self.paging?.total ?? 0 {
            position += 25
            let limitAux = self.products.count + limit > self.paging?.total ?? 0 ? (self.paging?.total ?? 0) - self.products.count : limit
            filterAction(searchBarText: searchBarText, position: position, limit: limitAux)
        }
    }
}

extension ProductListViewController: UISearchBarDelegate {
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.showsCancelButton = true
        tableView.isHidden = true
        showSearchTable()
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
        if !isFiltering {
            searchBar.text = ""
        }
        searchTableView.isHidden = true
        showTable()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchBarText = searchBar.text else {
            return
        }
        showActivityIndicator()
        addSearchToMyList(searchedText: searchBarText)
        filterAction(searchBarText: searchBarText, position: position, limit: limit)
    }
}
