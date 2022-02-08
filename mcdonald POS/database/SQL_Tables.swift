//
//  SQL_Tables.swift
//  mcdonald POS
//
//  Created by Jayden on 5/2/2022.
//

import Foundation
import SQLite

class SQLTables {
    
    public static func create_user_table(db: Connection) throws {
        let users = Table("user")
        let id = Expression<Int64>("id")
        let username = Expression<String>("username")
        let password = Expression<String>("password")
        let role = Expression<String>("role")
        let lastTime = Expression<Date?>("lastTime")
        
        do {
            try db.scalar(users.exists)
            debugPrint("user table exsits")
        }catch {
            debugPrint("created users table")
            try db.run(users.create {t in
                t.column(id, primaryKey: .autoincrement)
                t.column(username, unique: true)
                t.column(password)
                t.column(role)
                t.column(lastTime)
            })
            // Insert mock users
            try SQLData.insertUsers(db: db)
        }
    }
    
    public static func create_catalog_table(db: Connection) throws {
        let catalog = Table("catalog")
        let id = Expression<Int64>("id")
        let name_zh = Expression<String>("name_zh")
        let name_en = Expression<String>("name_en")
        let image_zh = Expression<String>("image_zh")
        let image_en = Expression<String>("image_en")
        let position = Expression<Int>("position")
        do {
            try db.scalar(catalog.exists)
            debugPrint("catalog table exsits")
        }catch {
            debugPrint("created catalog table")
            try db.run(catalog.create { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(name_zh)
                t.column(name_en)
                t.column(image_zh)
                t.column(image_en)
                t.column(position)
            })
            // Insert mock catalogs
            try SQLData.insertCatalog(db: db)
        }
    }
    
    public static func create_food_table(db: Connection) throws {
        let food = Table("food")
        let id = Expression<Int64>("id")
        let catalogId = Expression<Int64>("catalogId")
        let name_zh = Expression<String>("name_zh")
        let name_en = Expression<String>("name_en")
        let image_zh = Expression<String>("image_zh")
        let image_en = Expression<String>("image_en")
        let price = Expression<Float64>("price")
        let meal_price = Expression<Float64>("meal_price")
        do {
            try db.scalar(food.exists)
            debugPrint("food table exsits")
        }catch {
            debugPrint("created food table")
            try db.run(food.create { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(catalogId)
                t.column(name_zh)
                t.column(name_en)
                t.column(image_zh)
                t.column(image_en)
                t.column(price)
                t.column(meal_price)
            })
            // Insert mock foods
            try SQLData.insertFood(db: db)
        }
    }
    
    public static func drop_user_table(db: Connection) throws {
        let users = Table("users")
        try db.run(users.drop(ifExists: true))
    }
    
    public static func drop_catalog_table(db: Connection) throws {
        let catalog = Table("catalog")
        try db.run(catalog.drop(ifExists: true))
    }
    
    public static func drop_food_table(db: Connection) throws {
        let food = Table("food")
        try db.run(food.drop(ifExists: true))
    }
}
