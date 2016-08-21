//
//  MealDB.swift
//  FoodTracker
//
//  Created by jhonny on 7/26/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import Foundation
import RealmSwift


class MealDB: Object {
    dynamic var id = ""
    dynamic var name = ""
    dynamic var photo:NSData? = nil
    dynamic var rating = 0
    dynamic var coordenadas = 0.0

    
    //override Primary Key
    
    override static func primaryKey() ->String {
        return "id"
    }
}
