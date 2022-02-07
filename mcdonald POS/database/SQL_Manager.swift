//
//  SQL_Manager.swift
//  mcdonald POS
//
//  Created by Jayden on 5/2/2022.
//

import Foundation
import SQLite

class SQLManager{
    
    private var sqlitePath :String? = nil
    private var sqlDB :Connection? = nil
    
    init() {
        self.request_access()
        self.connect_sql()
        do {
            try SQLTables.create_user_table(db: sqlDB!)
        }catch {
            debugPrint("sql table error...")
        }
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
    
    func fetchUsers() throws -> Array<Any>{
        let users = Table("users")
        var data = Array<Any>()
        for row in try sqlDB!.prepare(users) {
            data.append(row)
        }
        return data
    }
    
    func loginUser(username: String, password: String) throws  -> User? {
        let statement = try sqlDB!.prepare("select * from users where username='\(username)' and password='\(password)' limit 1")
        var users = Array<User>()
        for i in statement {
            let username = i[1] as! String
            let password = i[2] as! String
            let role = i[3] as! String
            let lastTime = i[4] as! String
            let time = lastTime.toDate()
            users.append(User(username: username, password: password, role: role, lastTime: time!))
        }
        if users.count > 1 {
            return users[0]
        }
        return nil
    }
    
}
