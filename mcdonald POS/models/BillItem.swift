//
//  BillItem.swift
//  mcdonald POS
//
//  Created by Jayden on 9/2/2022.
//

import Foundation

struct BillItem: Identifiable, Codable {
    var id = UUID()
    var is_set_meal: Bool
    var food: Food
    var option_food: Food?
    var option_drink: Food?

    var totalPrice: Float64 {
        if is_set_meal {
            var total = food.meal_price
            if let option = option_food {
                total += option.meal_price
            }
            if let drink = option_drink {
                total += drink.meal_price
            }
            return total
        } else {
            return food.price
        }
    }

    var formattedPrice: String {
        String(format: "HKD $%.2f", totalPrice)
    }
}
