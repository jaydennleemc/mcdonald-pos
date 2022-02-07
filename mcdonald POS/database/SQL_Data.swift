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
                    debugPrint("inserted")
                }catch {
                    debugPrint("insert user error", json)
                }
            }
        }
        
    }
}
