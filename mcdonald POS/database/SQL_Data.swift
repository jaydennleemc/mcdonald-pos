//
//  SQL_Data.swift
//  mcdonald POS
//
//  Created by Jayden on 5/2/2022.
//

import Foundation
import SQLite
import SwiftyJSON

class SQLData {
    static func insertUsers(db: Connection) throws {
        if let jsonPath = Bundle.main.path(forResource: "users", ofType: ".json") {
            let fileUrl = URL(fileURLWithPath: jsonPath)
            let data = try Data(contentsOf: fileUrl)
            let users = try JSON(data: data)
            for (index, json) in users {
                do {
                    let username = json["username"].string!
                    let password = json["password"].string!.md5Value
                    let role = json["role"].string!
                    let insert = """
                        INSERT INTO "users" ("username", "password", "role", "lastTime") VALUES ('\(username)', '\(password)', '\(role)', '\(Date())')
                    """
                    try db.run(insert)
                    debugPrint("insert user success")
                }catch {
                    debugPrint("insert user error", json)
                }
            }
        }
    }
    
    static func insertCatalog(db: Connection) throws {
        if let jsonPath = Bundle.main.path(forResource: "catalogs", ofType: ".json") {
            let fileUrl = URL(fileURLWithPath: jsonPath)
            let data = try Data(contentsOf: fileUrl)
            let catalogs = try JSON(data: data)
            for (index, json) in catalogs {
                do {
                    let name_zh = json["name_zh"].string!
                    let name_en = json["name_en"].string!
                    let image_zh = json["image_zh"].string!
                    let image_en = json["image_en"].string!
                    let position = json["position"].int!
                    
                    let insert = """
                        INSERT INTO "catalog" ("name_zh", "name_en", "image_zh", "image_en", "position") VALUES ('\(name_zh)', '\(name_en)', '\(image_zh)', '\(image_en)', '\(position)')
                    """
                    try db.run(insert)
                    debugPrint("insert catalog success")
                }catch {
                    debugPrint("insert catalog error", json)
                }
            }
        }
    }
    
    static func insertFood(db: Connection) throws {
        if let jsonPath = Bundle.main.path(forResource: "foods", ofType: ".json") {
            let fileUrl = URL(fileURLWithPath: jsonPath)
            let data = try Data(contentsOf: fileUrl)
            let catalogs = try JSON(data: data)
            for (index, json) in catalogs {
                do {
                    let catalogId = SQLManager.sharedInstance.find_catalog_id(name: json["catalog"].string!)!
                    let name_zh = json["name_zh"].string!
                    let name_en = json["name_en"].string!
                    let image_zh = json["image_zh"].string!
                    let image_en = json["image_en"].string!
                    let price = json["price"].float!
                    let meal_price = json["meal_price"].float!
                    
                    let insert = """
                        INSERT INTO "food" ("catalogId", "name_zh", "name_en", "image_zh", "image_en", "price", "meal_price") VALUES ('\(catalogId)', '\(name_zh)', '\(name_en)', '\(image_zh)', '\(image_en)', '\(price)', '\(meal_price)')
                    """
                    try db.run(insert)
                    debugPrint("insert food success")
                }catch {
                    debugPrint("insert food error", json)
                }
            }
        }
    }
}
