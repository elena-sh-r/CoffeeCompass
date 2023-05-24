//
//  StorageManager.swift
//  CoffeeCompass
//
//  Created by Elena Sharipova on 23.05.2023.
//

import Foundation
import RealmSwift


final class StorageManager {
    static let shared = StorageManager()
    
    let realm: Realm
    
    private init() {
        do {
            realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error)")
        }
    }
    
    func save(_ coffeeHouse: CoffeeHouse) {
        write {
            realm.add(coffeeHouse)
        }
    }
    
    private func write(completion: () -> Void) {
        do {
            try realm.write {
                completion()
            }
        } catch {
            print(error)
        }
    }
}
