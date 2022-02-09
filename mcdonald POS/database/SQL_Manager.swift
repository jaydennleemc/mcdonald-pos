//
//  SQL_Manager.swift
//  mcdonald POS
//
//  Created by Jayden on 5/2/2022.
//

import Foundation
import SQLite

class SQLManager{
    static let sharedInstance = SQLManager()
    
    private var sqlitePath :String? = nil
    private var sqlDB :Connection? = nil
    
    init() {
        self.request_access()
        self.connect_sql()
    }
    
    private func request_access() {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        sqlitePath = urls[urls.count-1].absoluteString + "db.sqlite3"
    }
    
    private func connect_sql() {
        sqlDB = try? Connection(sqlitePath!)
    }
    
    func check_db_status() -> Bool {
        if sqlDB == nil {
            return false
        }
        return true
    }
    
    func create_tables() {
        do {
            try SQLTables.create_user_table(db: sqlDB!)
            try SQLTables.create_catalog_table(db: sqlDB!)
            try SQLTables.create_food_table(db: sqlDB!)
            
        }catch {
            debugPrint("sql table error...")
        }
    }
    
    func fetchUsers() throws -> Array<Any>{
        let users = Table("user")
        var data = Array<Any>()
        for row in try sqlDB!.prepare(users) {
            data.append(row)
        }
        return data
    }
    
    func loginUser(username: String, password: String) throws  -> User? {
        let sql = try sqlDB!.prepare("select * from user where username='\(username)' and password='\(password)' limit 1")
        var users = Array<User>()
        for i in sql {
            let username = i[1] as! String
            let password = i[2] as! String
            let role = i[3] as! String
            let lastTime = i[4] as! String
            let time = lastTime.toDate()
            users.append(User(username: username, password: password, role: role, lastTime: time!))
        }
        if users.count != 0 {
            return users[0]
        }
        return nil
    }
    
    
    func fetchCatalogs() throws -> Array<Catalog>{
        let sql = try sqlDB!.prepare("select id, name_zh, name_en, image_zh, image_en, position from catalog order by position")
        var catalogs = Array<Catalog>()
        for i in sql {
            let id = i[0] as! Int64
            let name_zh = i[1] as! String
            let name_en = i[2] as! String
            let image_zh = i[3] as! String
            let image_en = i[4] as! String
            let position = i[5] as! Int64
            catalogs.append(Catalog(id: id, name_zh: name_zh, name_en: name_en, image_zh: image_zh, image_en: image_en, position: position))
        }
        return catalogs
    }
    
    func find_catalog_id(name: String) -> Int64? {
        if let sql = try? sqlDB!.prepare("select id from catalog where name_zh='\(name)'") {
            for i in sql {
                return i[0] as! Int64
            }
            return 0
        }else {
            return nil
        }
    }
    
    
    func fetchFoods(catalogId: Int64) throws -> Array<Food> {
        let sql = try sqlDB!.prepare("select * from food where catalogId='\(catalogId)'")
        var foods = Array<Food>()
        for i in sql {
            let id = i[0] as! Int64
            let catalogId = i[1] as! Int64
            let name_zh = i[2] as! String
            let name_en = i[3] as! String
            let image_zh = i[4] as! String
            let image_en = i[5] as! String
            let price = i[6] as! Float64
            let meal_price = i[7] as! Float64
            
            let is_breakfasts = (i[8] as! String).bool!
            let is_set_meal = (i[9] as! String).bool!
            let is_set_option = (i[10] as! String).bool!
            let is_set_drink = (i[11] as! String).bool!
            foods.append(
                Food(id: id, catalogId: catalogId, name_zh: name_zh, name_en: name_en, image_zh: image_zh, image_en: image_en, price: price, meal_price: meal_price, is_breakfasts: is_breakfasts, is_set_meal: is_set_meal, is_set_option: is_set_option, is_set_drink: true)
            )
        }
        return foods
    }
    
    
    func fetchFoodOptions(is_breakfasts: Bool) throws -> Array<Food> {
        let sql = try sqlDB!.prepare("select * from food where is_breakfasts='\(is_breakfasts)' and is_set_option='true'")
        var foods = Array<Food>()
        for i in sql {
            let id = i[0] as! Int64
            let catalogId = i[1] as! Int64
            let name_zh = i[2] as! String
            let name_en = i[3] as! String
            let image_zh = i[4] as! String
            let image_en = i[5] as! String
            let price = i[6] as! Float64
            let meal_price = i[7] as! Float64
            
            let is_breakfasts = (i[8] as! String).bool!
            let is_set_meal = (i[9] as! String).bool!
            let is_set_option = (i[10] as! String).bool!
            let is_set_drink = (i[11] as! String).bool!
            foods.append(
                Food(id: id, catalogId: catalogId, name_zh: name_zh, name_en: name_en, image_zh: image_zh, image_en: image_en, price: price, meal_price: meal_price, is_breakfasts: is_breakfasts, is_set_meal: is_set_meal, is_set_option: is_set_option, is_set_drink: true)
            )
        }
        return foods
    }
    
    func fetchDrinkOptions() throws -> Array<Food> {
        let sql = try sqlDB!.prepare("select * from food where is_set_drink='true'")
        var foods = Array<Food>()
        for i in sql {
            let id = i[0] as! Int64
            let catalogId = i[1] as! Int64
            let name_zh = i[2] as! String
            let name_en = i[3] as! String
            let image_zh = i[4] as! String
            let image_en = i[5] as! String
            let price = i[6] as! Float64
            let meal_price = i[7] as! Float64
            
            let is_breakfasts = (i[8] as! String).bool!
            let is_set_meal = (i[9] as! String).bool!
            let is_set_option = (i[10] as! String).bool!
            let is_set_drink = (i[11] as! String).bool!
            foods.append(
                Food(id: id, catalogId: catalogId, name_zh: name_zh, name_en: name_en, image_zh: image_zh, image_en: image_en, price: price, meal_price: meal_price, is_breakfasts: is_breakfasts, is_set_meal: is_set_meal, is_set_option: is_set_option, is_set_drink: true)
            )
        }
        return foods
    }
}
