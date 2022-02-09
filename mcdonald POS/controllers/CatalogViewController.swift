//
//  CatalogViewController.swift
//  macdonald_pos
//
//  Created by Jayden on 4/2/2022.
//

import UIKit

class CatalogViewController: UIViewController {

    @IBOutlet weak var catalogCollectionView: UICollectionView!
    @IBOutlet weak var menuCollectionView: UICollectionView!
    @IBOutlet weak var addItemButton: UIButton!
    
    private var catalogs = Array<Catalog>()
    private var foods = Array<Food>()
    private var selectedFood:Food? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCollectionView()
        self.fetchCatalogs()
    }
    
    private func initCollectionView() {
        // setup catalog collction view
        self.catalogCollectionView.register(UINib(nibName: "CatalogCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CatalogCollectionViewCellId")
        self.catalogCollectionView.delegate = self
        self.catalogCollectionView.dataSource = self
        // setup menu collection view
        self.menuCollectionView.register(UINib(nibName: "MenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MenuCollectionViewCellId")
        self.menuCollectionView.delegate = self
        self.menuCollectionView.dataSource = self
    }
    
    private func fetchCatalogs() {
        self.catalogs = try! SQLManager.sharedInstance.fetchCatalogs()
        self.catalogs[0].selected = true
        self.foods =  try! SQLManager.sharedInstance.fetchFoods(catalogId: self.catalogs[0].id)
        self.catalogCollectionView.reloadData()
    }
    
    @IBAction func addItemToBill(_ sender: Any) {
        let billItem = BillItem(is_set_meal: false, food: selectedFood!, option_food: nil, option_drink: nil)
        let userInfo:[String: BillItem] = ["billItem": billItem]
        NotificationCenter.default.post(name: Notification.Name(rawValue: "addItemToBill"), object: nil, userInfo: userInfo)
        
        for i in 0..<foods.count {
            foods[i].selected = false
        }
        self.addItemButton.isHidden = true
        self.catalogCollectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
}

extension CatalogViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.catalogCollectionView) {
            return catalogs.count
        }
        
        if (collectionView == self.menuCollectionView) {
            return foods.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // handle catalog collection view data
        if collectionView == catalogCollectionView {
            let cell = catalogCollectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCollectionViewCellId", for: indexPath) as! CatalogCollectionViewCell
            let item = catalogs[indexPath.row]
            cell.cell_text.text = item.name_zh
            cell.cell_image.image = UIImage(named: item.image_zh)
            cell.isSelected = item.selected
            cell.toggleSelected()
            self.addItemButton.isHidden = true
            return cell
        }
        // handle menu collection view data
        if collectionView == menuCollectionView {
            let cell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCellId", for: indexPath) as! MenuCollectionViewCell
            let item = foods[indexPath.row]
            cell.cell_text.text = item.name_zh
            cell.cell_image.image = UIImage(named: item.image_zh)
            cell.cell_price.text = "\(item.price)"
            cell.isSelected = item.selected
            cell.toggleSelected()
            return cell
        }
        return UICollectionViewCell()
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle catalog collection view did select action
        if collectionView == catalogCollectionView {
            for i in 0..<catalogs.count {
                catalogs[i].selected = false
            }
            catalogs[indexPath.row].selected = true
            self.foods = try! SQLManager.sharedInstance.fetchFoods(catalogId: catalogs[indexPath.row].id)
            self.catalogCollectionView.reloadData()
            self.menuCollectionView.reloadData()
        }
        
        // handle menu collection view did select action
        if collectionView == menuCollectionView {
            for i in 0..<foods.count {
                foods[i].selected = false
            }
            foods[indexPath.row].selected = true
            if (foods[indexPath.row].is_set_meal || foods[indexPath.row].is_breakfasts) {
                let vc = storyboard?.instantiateViewController(withIdentifier: "MealOptionViewController") as! MealOptionViewController
                vc.food = foods[indexPath.row]
                self.navigationController?.pushViewController(vc, animated: true)
                return
            }
            
            self.addItemButton.setTitle("HKD $\(foods[indexPath.row].price), Add Item", for: .normal)
            self.selectedFood = foods[indexPath.row]
            self.menuCollectionView.reloadData()
            self.addItemButton.isHidden = false
        }
    }
}
