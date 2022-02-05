//
//  SQL_Tables.swift
//  mcdonald POS
//
//  Created by Jayden on 5/2/2022.
//

import Foundation
import SQLite

class SQLTables {
    
    func create_user_table(db: Connection) throws {
        let users = Table("users")
        let id = Expression<Int64>("id")
        let username = Expression<String>("username")
        let password = Expression<String>("password")
        let role = Expression<String>("role")
        let lastTime = Expression<Date>("lastTime")
        
        try db.run(users.create {t in
            t.column(id, primaryKey: true)
            t.column(username)
            t.column(password)
            t.column(role)
            t.column(lastTime)
        })
    }
    
    func drop_user_table(db: Connection) throws {
        
    }
    
    
}
