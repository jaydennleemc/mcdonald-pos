//
//  MealDrinkViewController.swift
//  mcdonald POS
//
//  Created by Jayden on 8/2/2022.
//

import UIKit

class MealDrinkViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIButton!
    
    var food: Food? = nil
    var optionFood: Food? = nil
    private var drinks = Array<Food>()
    private var selectedDrink:Food? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select Drink"
        self.drinks = try! SQLManager.sharedInstance.fetchDrinkOptions()
        
        self.collectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MenuCollectionViewCellId")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    
    @IBAction func addToBill(_ sender: Any) {
        let billItem = BillItem(is_set_meal: true, food: food!, option_food: optionFood, option_drink: selectedDrink)
        let userInfo:[String: BillItem] = ["billItem": billItem]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "addItemToBill"), object: nil, userInfo: userInfo)
        
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers
        for aViewController in viewControllers {
            if aViewController is CatalogViewController {
                self.navigationController!.popToViewController(aViewController, animated: true)
            }
        }
    }
    
}

extension MealDrinkViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return drinks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCellId", for: indexPath) as? MenuCollectionViewCell {
            let item = drinks[indexPath.row]
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
        for i in 0..<drinks.count {
            drinks[i].selected = false
        }
        drinks[indexPath.row].selected = true
        self.selectedDrink = drinks[indexPath.row]
        self.collectionView.reloadData()
        let total_price = food!.meal_price + optionFood!.meal_price + selectedDrink!.meal_price
        self.addButton.setTitle("HKD $\(total_price), Add Item", for: .normal)
        self.addButton.isHidden = false
    }
}



