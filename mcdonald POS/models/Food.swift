//
//  Food.swift
//  mcdonald POS
//
//  Created by Jayden on 8/2/2022.
//

import Foundation

struct Food {
    var id: Int64
    var catalogId: Int64
    var name_zh: String
    var name_en: String
    var image_zh: String
    var image_en: String
    var price: Float64
    var meal_price: Float64
    var selected: Bool = false
}
