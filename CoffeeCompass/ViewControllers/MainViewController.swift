//
//  ViewController.swift
//  CoffeeCompass
//
//  Created by Elena Sharipova on 22.05.2023.
//

import UIKit

final class MainViewController: UITableViewController {
    
    private let coffeeHouses = CoffeeHouse.getCoffeeHouses()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelAction(_ segue: UIStoryboardSegue) {}
}


// MARK: - Table View Data Source
extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coffeeHouses.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        cell.nameLabel.text = coffeeHouses[indexPath.row].name
        cell.locationLabel.text = coffeeHouses[indexPath.row].location
        cell.descriptionLabel.text = coffeeHouses[indexPath.row].description
        cell.imageOfCoffeeHouse.image = UIImage(named: coffeeHouses[indexPath.row].image)
        cell.imageOfCoffeeHouse.layer.cornerRadius = cell.imageOfCoffeeHouse.frame.size.height / 2
        cell.imageOfCoffeeHouse.clipsToBounds = true
        
        return cell
    }
}
