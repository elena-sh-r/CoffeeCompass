//
//  ViewController.swift
//  CoffeeCompass
//
//  Created by Elena Sharipova on 22.05.2023.
//

import UIKit

final class MainViewController: UITableViewController {
    
    private var coffeeHouses = CoffeeHouse.getCoffeeHouses()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newCoffeeHouseVC = segue.source as? NewCoffeeHouseViewController else { return }
        newCoffeeHouseVC.saveNewCoffeeHouse()
        
        guard let newCoffeeHouse = newCoffeeHouseVC.newCoffeeHouse else { return }
        coffeeHouses.append(newCoffeeHouse)
        
        tableView.reloadData()
    }
}


// MARK: - Table View Data Source
extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coffeeHouses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        let coffeeHouse = coffeeHouses[indexPath.row]
        
        cell.nameLabel.text = coffeeHouse.name
        cell.locationLabel.text = coffeeHouse.location
        cell.descriptionLabel.text = coffeeHouse.description
        
        (coffeeHouse.image == nil)
            ? (cell.imageOfCoffeeHouse.image = UIImage(named: coffeeHouse.coffeeHouseImage ?? ""))
            : (cell.imageOfCoffeeHouse.image = coffeeHouse.image)
        
        
        
        cell.imageOfCoffeeHouse.layer.cornerRadius = cell.imageOfCoffeeHouse.frame.size.height / 2
        cell.imageOfCoffeeHouse.clipsToBounds = true
        
        return cell
    }
}
