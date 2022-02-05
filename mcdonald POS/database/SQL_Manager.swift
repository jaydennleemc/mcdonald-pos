//
//  SQL_Helper.swift
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
    
}
