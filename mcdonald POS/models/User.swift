//
//  User.swift
//  mcdonald POS
//
//  Created by Jayden on 7/2/2022.
//

import Foundation

struct User: Identifiable, Codable {
    var id: String { username }
    var username: String
    var password: String
    var role: String
    var lastTime: Date
}
