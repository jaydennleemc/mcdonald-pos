//
//  CashierViewController.swift
//  mcdonald POS
//
//  Created by Jayden on 5/2/2022.
//

import UIKit

class CashierViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var paymentButton: UIButton!
    @IBOutlet weak var cashierTableView: UITableView!
    
    private var billItems = Array<BillItem>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(handleBillItem(_:)), name: Notification.Name(rawValue: "addItemToBill"), object: nil)
    }
    
    
    private func setupTableView() {
        self.cashierTableView.register(UINib(nibName: "CashierTableViewCell", bundle: nil), forCellReuseIdentifier: "CashierTableViewCellId")
        self.cashierTableView.delegate = self
        self.cashierTableView.dataSource = self
    }

    @objc private func handleBillItem(_ notification: Notification) {
        let billItem = notification.userInfo!["billItem"] as! BillItem
        self.billItems.append(billItem)
        self.cashierTableView.reloadData()
        self.paymentButton.isEnabled = true
    }
    
    @IBAction func settingOnPress(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    @IBAction func trashOnPress(_ sender: Any) {
        let alert = UIAlertController(title: "Warning", message: "Clear all record ??", preferredStyle: .alert)
        alert.setTitlet(font: UIFont.systemFont(ofSize: 18, weight: .bold), color: .red)
        alert.setMessage(font: UIFont.systemFont(ofSize: 14, weight: .regular), color: .black)
        alert.addAction(UIAlertAction(title: "Clear", style: .default, handler: { ActionHandler in
            debugPrint("Clear all record")
            self.billItems = Array<BillItem>()
            self.cashierTableView.reloadData()
            self.paymentButton.isEnabled = false
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func paymentOnPress(_ sender: Any) {
        
    }
}


extension CashierViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            self.billItems.remove(at: indexPath.row)
            if self.billItems.isEmpty {
                self.paymentButton.isEnabled = false
            }
            self.cashierTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return billItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CashierTableViewCellId") as? CashierTableViewCell {
            let item = billItems[indexPath.row]
            cell.cell_name.text = item.food.name_zh
            cell.cell_image.image = UIImage(named: item.food.image_zh)
            if item.is_set_meal {
                cell.cell_price.text = "HKD $\(item.food.meal_price + item.option_food!.meal_price + item.option_drink!.meal_price)"
            }else {
                cell.cell_price.text = "HKD $\(item.food.price)"
            }
            return cell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let popover = storyboard?.instantiateViewController(withIdentifier: "MealPopoverViewController") as! MealPopoverViewController
            popover.modalPresentationStyle = .popover
            popover.preferredContentSize = CGSize(width: 300, height: 300)
            popover.billItem = billItems[indexPath.row]
            
            let popoverController = popover.popoverPresentationController
            popoverController?.sourceView = tableView.cellForRow(at: indexPath)
            popoverController?.permittedArrowDirections = .left
            self.present(popover, animated: true, completion: nil)
        }
    }
    
    
}
