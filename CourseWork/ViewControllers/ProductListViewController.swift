//
//  ProductListViewController.swift
//  CourseWork
//
//  Created by Matvei Semenov on 11/12/2022.
//

import UIKit
import SVProgressHUD


class ProductListController: UIViewController, UISearchResultsUpdating, UISearchBarDelegate {

    let searchController = UISearchController()

    @IBOutlet weak var tableView: UITableView!

    let dataProvider = DataProvider.shared

    var products = [Product]()
    var filteredProducts = [Product]()

    func initSearchController(){
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        definesPresentationContext = true

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.scopeButtonTitles = ["All","🥩","🥤","🍿","🥛","🍞","🍣","🍫","🥥"]
        searchController.searchBar.delegate = self
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchController()

        dataProvider.setupProductListUpdatesListener { [weak self] products in
            guard let self = self else { return }
            let difference = products.difference(from: self.products)
            self.products = products
            self.tableView.reloadData()

        }
    }

    private func showProductDetails(with product: Product) {
        guard let vc = UIStoryboard.main.instantiateViewController(withIdentifier: ProductDetailsViewController.storyboardId) as? ProductDetailsViewController else {
            return
        }
        vc.mode = .edit
        vc.product = product
        present(vc, animated: true)
    }

    private func remove(product: Product, at indexPath: IndexPath) {
        SVProgressHUD.show()
        dataProvider.removeProduct(product) { error in
            SVProgressHUD.dismiss()
        }
    }

    @IBAction func didTapAdd(){
        let vc = ScannerViewController()
        navigationController?.pushViewController(vc,animated: true)
    }
   func updateSearchResults(for searchController: UISearchController) {
        let searchBar  = searchController.searchBar
        let scopeButton = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
       let searchText = searchBar.text!

       filterForSearchTextAndScopeButton(searchText: searchText, scopeButton: scopeButton)
   }

    func filterForSearchTextAndScopeButton(searchText: String, scopeButton: String = "All"){
        filteredProducts = products.filter{
            let scopeMatch = (scopeButton == "All" || $0.category.emojiValue == scopeButton)
            if(searchController.searchBar.text != ""){
                let searchTextMatch = $0.name.lowercased().contains(searchText.lowercased())

                return scopeMatch && searchTextMatch
            } else {
                return scopeMatch
            }
        }
        tableView.reloadData()
    }
}

extension ProductListController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController.isActive){
            return filteredProducts.count
        }
        return products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ProductTableViewCell else {
            return UITableViewCell()
        }

        let thisProduct: Product!

        if(searchController.isActive){
            thisProduct = filteredProducts[indexPath.row]
        } else {
            thisProduct = products[indexPath.row]
        }

        cell.setup(with: thisProduct)

        return cell
    }
}

extension ProductListController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actions: [UIContextualAction] = [.init(style: .destructive, title: "Удалить", handler: { [weak self] _, _, _ in
            if let product = self?.products[indexPath.row] {
                self?.remove(product: product, at: indexPath)
            }
        })]
        let configuration = UISwipeActionsConfiguration(actions: actions)
        return configuration
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let thisProduct: Product!

        if(searchController.isActive){
            thisProduct = filteredProducts[indexPath.row]
        } else {
            thisProduct = products[indexPath.row]
        }
        showProductDetails(with: thisProduct)
    }
}
