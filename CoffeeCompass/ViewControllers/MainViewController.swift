//
//  ViewController.swift
//  CoffeeCompass
//
//  Created by Elena Sharipova on 22.05.2023.
//

import UIKit
import RealmSwift

final class MainViewController: UIViewController {
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var reversedSortingButton: UIBarButtonItem!
    
    private var coffeeHouses: Results<CoffeeHouse>!
    private var ascendingSorting = true
    private let storageManager = StorageManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        coffeeHouses = storageManager.realm.objects(CoffeeHouse.self)
    }
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let coffeeHouse = coffeeHouses[indexPath.row]
            
            guard let newCoffeeHouseVC = segue.destination as? NewCoffeeHouseViewController else { return }
            newCoffeeHouseVC.currentCoffeeHouse = coffeeHouse
        }
    }
    
    private func sorting() {
        (segmentedControl.selectedSegmentIndex == 0)
            ? (coffeeHouses = coffeeHouses.sorted(byKeyPath: "date", ascending: ascendingSorting))
            : (coffeeHouses = coffeeHouses.sorted(byKeyPath: "name", ascending: ascendingSorting))
        
        tableView.reloadData()
    }
}


// MARK: - Table view data source
extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coffeeHouses.isEmpty ? 0 : coffeeHouses.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell

        let coffeeHouse = coffeeHouses[indexPath.row]

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
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let coffeeHouse = coffeeHouses[indexPath.row]
            storageManager.delete(coffeeHouse)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
