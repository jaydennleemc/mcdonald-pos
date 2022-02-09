//
//  MealOptionViewController.swift
//  mcdonald POS
//
//  Created by Jayden on 8/2/2022.
//

import UIKit

class MealOptionViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
    var food: Food? = nil
    private var optionFoods = Array<Food>()
    private var selectedOptionFood: Food? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select Option"
        self.optionFoods = try! SQLManager.sharedInstance.fetchFoodOptions(is_breakfasts: food!.is_breakfasts)
        
        self.collectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MenuCollectionViewCellId")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    @IBAction func nextOnPress(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MealDrinkViewController") as! MealDrinkViewController
        vc.food = food!
        vc.optionFood = selectedOptionFood!
        self.navigationController?.pushViewController(vc, animated: true)
        return
    }
}

extension MealOptionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return optionFoods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCellId", for: indexPath) as? MenuCollectionViewCell {
            let item = optionFoods[indexPath.row]
            cell.cell_text.text = item.name_zh
            cell.cell_image.image = UIImage(named: item.image_zh)
            cell.cell_price.text = "\(item.meal_price)"
            cell.isSelected = item.selected
            cell.toggleSelected()
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for i in 0..<optionFoods.count {
            optionFoods[i].selected = false
        }
        optionFoods[indexPath.row].selected = true
        self.selectedOptionFood = optionFoods[indexPath.row]
        self.collectionView.reloadData()
        self.nextButton.isHidden = false
    }
}



