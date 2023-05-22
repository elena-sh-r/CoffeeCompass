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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = coffeeHousesNames[indexPath.row]
        content.image = UIImage(named: coffeeHousesNames[indexPath.row])
        content.imageProperties.cornerRadius = cell.frame.size.height / 2
        cell.contentConfiguration = content
        
        return cell
    }
}

// MARK: - Table View Delegate
extension MainViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        85
    }
}
