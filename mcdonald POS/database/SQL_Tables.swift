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
        let users = Table("users")
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
        do {
            try db.scalar(catalog.exists)
            debugPrint("catalog table exsits")
        }catch {
            debugPrint("created catalog table")
            try db.run(catalog.create { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(name_zh)
                t.column(name_en)
            })
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
    
    
}
