//
//  CoffeeHouseModel.swift
//  CoffeeCompass
//
//  Created by Elena Sharipova on 22.05.2023.
//

import Foundation

struct CoffeeHouse {
    var name: String
    var location: String
    var description: String
    var image: String
    
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
                image: coffeeHouse
            ))
        }
        
        return coffeeHouses
    }
}
