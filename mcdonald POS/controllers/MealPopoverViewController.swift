//
//  MealPopoverViewController.swift
//  mcdonald POS
//
//  Created by Jayden on 9/2/2022.
//

import UIKit

class MealPopoverViewController: UIViewController {
    
    @IBOutlet weak var mealFoodView: UIView!
    @IBOutlet weak var mealFoodImage: UIImageView!
    @IBOutlet weak var mealFoodNameLabel: UILabel!
    @IBOutlet weak var mealFoodPriceLabel: UILabel!
    
    @IBOutlet weak var mealFoodOptionView: UIView!
    @IBOutlet weak var mealFoodOptionImage: UIImageView!
    @IBOutlet weak var mealFoodOptionNameLabel: UILabel!
    @IBOutlet weak var mealFoodOptionPriceLabel: UILabel!
    
    @IBOutlet weak var mealFoodDrinkView: UIView!
    @IBOutlet weak var mealFoodDrinkImage: UIImageView!
    @IBOutlet weak var mealFoodDrinkNameLabel: UILabel!
    @IBOutlet weak var mealFoodDrinkPriceLabel: UILabel!
    
    var billItem: BillItem? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setMealFoodView(food: billItem!.food)
        if billItem!.is_set_meal {
            self.setMealFoodOptionView(food: billItem!.option_food!)
            self.setMealFoodDrinkView(food: billItem!.option_drink!)
        }
    }
    
    private func setMealFoodView(food:Food) {
        self.mealFoodView.isHidden = false
        self.mealFoodImage.image = UIImage(named: food.image_zh)
        self.mealFoodNameLabel.text = food.name_zh
        if food.is_set_meal {
            self.mealFoodPriceLabel.text = "HKD $\(food.meal_price)"
        }else {
            self.mealFoodPriceLabel.text = "HKD $\(food.price)"
        }
    }
    
    private func setMealFoodOptionView(food:Food) {
        self.mealFoodOptionView.isHidden = false
        self.mealFoodOptionImage.image = UIImage(named: food.image_zh)
        self.mealFoodOptionNameLabel.text = food.name_zh
        self.mealFoodOptionPriceLabel.text = "HKD $\(food.meal_price)"
    }
    
    
    private func setMealFoodDrinkView(food:Food) {
        self.mealFoodDrinkView.isHidden = false
        self.mealFoodDrinkImage.image = UIImage(named: food.image_zh)
        self.mealFoodDrinkNameLabel.text = food.name_zh
        self.mealFoodDrinkPriceLabel.text = "HKD $\(food.meal_price)"
    }

}
