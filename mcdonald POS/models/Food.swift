//
//  Food.swift
//  mcdonald POS
//
//  Created by Jayden on 8/2/2022.
//  Updated for SwiftUI with Identifiable conformance
//

import Foundation

struct Food: Identifiable, Codable {
    var id: Int64
    var catalogId: Int64
    var name_zh: String
    var name_en: String
    var image_zh: String
    var image_en: String
    var price: Float64
    var meal_price: Float64
    var is_breakfasts: Bool
    var is_set_meal: Bool
    var is_set_option: Bool
    var is_set_drink: Bool

    // For SwiftUI previews and testing
    static let sample = Food(
        id: 1,
        catalogId: 1,
        name_zh: "漢堡包",
        name_en: "Hamburger",
        image_zh: "hamburger_zh",
        image_en: "hamburger_en",
        price: 15.0,
        meal_price: 25.0,
        is_breakfasts: false,
        is_set_meal: true,
        is_set_option: true,
        is_set_drink: true
    )
}
