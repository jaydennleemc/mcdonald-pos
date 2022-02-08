//
//  Catalog.swift
//  mcdonald POS
//
//  Created by Jayden on 7/2/2022.
//

import Foundation

struct Catalog {
    var id: Int64
    var name_zh: String
    var name_en: String
    var image_zh: String
    var image_en: String
    var position: Int64
    var selected: Bool = false
}
