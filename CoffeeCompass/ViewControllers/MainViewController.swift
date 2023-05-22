//
//  ViewController.swift
//  CoffeeCompass
//
//  Created by Elena Sharipova on 22.05.2023.
//

import UIKit

class MainViewController: UITableViewController {
    
    let coffeeHousesNames = [
        "Кофейня 1554",
        "Хочу кофе",
        "Герои нашего времени",
        "Кофе Культ",
        "IT-coffee",
        "Entrée"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
}


// MARK: - Table View Data Source
extension MainViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        coffeeHousesNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomTableViewCell
        
        cell.nameLabel.text = coffeeHousesNames[indexPath.row]
        cell.imageOfCoffeeHouse.image = UIImage(named: coffeeHousesNames[indexPath.row])
        cell.imageOfCoffeeHouse.layer.cornerRadius = cell.imageOfCoffeeHouse.frame.size.height / 2
        cell.imageOfCoffeeHouse.clipsToBounds = true
        
        return cell
    }
}

// MARK: - Table View Delegate
extension MainViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        85
    }
}
