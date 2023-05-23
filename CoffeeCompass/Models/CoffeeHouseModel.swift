//
//  CoffeeHouseModel.swift
//  CoffeeCompass
//
//  Created by Elena Sharipova on 22.05.2023.
//

import UIKit

struct CoffeeHouse {
    var name: String
    var location: String?
    var description: String?
    var image: UIImage?
    var coffeeHouseImage: String?
    
    static let coffeeHousesNames = [
        "Кофейня 1554",
        "Хочу кофе",
        "Герои нашего времени",
        "Кофе Культ",
        "IT-coffee",
        "Entrée"
    ]
    
    static func getCoffeeHouses() -> [CoffeeHouse] {
        var coffeeHouses = [CoffeeHouse]()
        
        for coffeeHouse in coffeeHousesNames {
            coffeeHouses.append(CoffeeHouse(
                name: coffeeHouse,
                location: "Калуга",
                description: "Кофе и авторские напитки",
                image: nil,
                coffeeHouseImage: coffeeHouse
            ))
        }
        
        return coffeeHouses
    }
}
