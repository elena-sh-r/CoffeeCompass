//
//  ViewController.swift
//  CoffeeCompass
//
//  Created by Elena Sharipova on 22.05.2023.
//

import UIKit
import RealmSwift

final class MainViewController: UIViewController {
    // MARK: IB Outlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var reversedSortingButton: UIBarButtonItem!
    
    // MARK: - Private Properties
    private let searchController = UISearchController(searchResultsController: nil)
    private var coffeeHouses: Results<CoffeeHouse>!
    private var filteredCoffeeHouses: Results<CoffeeHouse>!
    private var ascendingSorting = true
    
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        searchController.isActive && !searchBarIsEmpty
    }
    
    private let storageManager = StorageManager.shared

    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coffeeHouses = storageManager.realm.objects(CoffeeHouse.self)
        
        // Setup the search controller
        searchController.searchResultsUpdater = self // получатель информации текста по поисковой строке - сам класс
        searchController.obscuresBackgroundDuringPresentation = false // по умолчанию вью контроллер с результатами поиска не позволяет взаимодействовать с отображаемым контентом, если отключить параметр, то можно взаимодействовать с этим вью контроллером, как с основным (смотреть детали записей, исправлять их и удалять
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController // интегрируем строку поиска в навигейшн бар
        definesPresentationContext = true // отпускаем строку поиска при переходе на другой экран
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let coffeeHouse: CoffeeHouse
            
            coffeeHouse = isFiltering
                ? filteredCoffeeHouses[indexPath.row]
                : coffeeHouses[indexPath.row]
            
            guard let newCoffeeHouseVC = segue.destination as? NewCoffeeHouseViewController else { return }
            newCoffeeHouseVC.currentCoffeeHouse = coffeeHouse
        }
    }
    
    // MARK: - IB Actions
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newCoffeeHouseVC = segue.source as? NewCoffeeHouseViewController else { return }
        newCoffeeHouseVC.saveCoffeeHouse()
        tableView.reloadData()
    }
    
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        sorting()
    }
    
    @IBAction func reversedSorting(_ sender: Any) {
        ascendingSorting.toggle()
        
        ascendingSorting
            ? (reversedSortingButton.image = #imageLiteral(resourceName: "AZ"))
            : (reversedSortingButton.image = #imageLiteral(resourceName: "ZA"))
        
        sorting()
    }
    
    // MARK: - Private Methods
    private func sorting() {
        segmentedControl.selectedSegmentIndex == 0
            ? (coffeeHouses = coffeeHouses.sorted(byKeyPath: "date", ascending: ascendingSorting))
            : (coffeeHouses = coffeeHouses.sorted(byKeyPath: "name", ascending: ascendingSorting))
        
        tableView.reloadData()
    }
}


// MARK: - Table view data source
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering
            ? filteredCoffeeHouses.count // поисковый запрос активирован
            : (coffeeHouses.isEmpty ? 0 : coffeeHouses.count) // поисковый запрос не активирован
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        var coffeeHouse = CoffeeHouse()
        
        coffeeHouse = isFiltering
            ? filteredCoffeeHouses[indexPath.row] // поисковый запрос активирован
            : coffeeHouses[indexPath.row] // поисковый запрос не активирован

        cell.nameLabel.text = coffeeHouse.name
        cell.locationLabel.text = coffeeHouse.location
        cell.typeLabel.text = coffeeHouse.type
        cell.imageOfCoffeeHouse.image = UIImage(data: coffeeHouse.imageData!)
        
        cell.imageOfCoffeeHouse.layer.cornerRadius = cell.imageOfCoffeeHouse.frame.size.height / 2
        cell.imageOfCoffeeHouse.clipsToBounds = true

        return cell
    }
}

// MARK: - Table view delegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let coffeeHouse = coffeeHouses[indexPath.row]
            storageManager.delete(coffeeHouse)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - Search results updating
extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!) // вызывается только когда мы тапаем по поисковой строке, даже если строка будет пустой, она не будет nil
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredCoffeeHouses = coffeeHouses.filter("name CONTAINS[c] %@", searchText) // поиск по полю name и location и фильтр данных по значению из параметра searchText, вне зависимости от регистра символов
        tableView.reloadData()
    }
}
