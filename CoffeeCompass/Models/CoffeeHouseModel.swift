//
//  CoffeeHouseModel.swift
//  CoffeeCompass
//
//  Created by Elena Sharipova on 22.05.2023.
//

import Foundation
import RealmSwift

final class CoffeeHouse: Object {
    @Persisted var name = ""
    @Persisted var location: String?
    @Persisted var type: String?
    @Persisted var imageData: Data?
    @Persisted var date = Date()
    
    convenience init(name: String, location: String?, type: String?, imageData: Data?) {
        self.init()
        self.name = name
        self.location = location
        self.type = type
        self.imageData = imageData
    }
}
