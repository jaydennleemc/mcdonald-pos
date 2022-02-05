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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
    }
    
    
    private func setupTableView() {
        self.cashierTableView.register(UINib(nibName: "CashierTableViewCell", bundle: nil), forCellReuseIdentifier: "CashierTableViewCellId")
        self.cashierTableView.delegate = self
        self.cashierTableView.dataSource = self
    }

    
    @IBAction func settingOnPress(_ sender: Any) {
        
    }
    
    
    @IBAction func trashOnPress(_ sender: Any) {
        
    }
    
    @IBAction func paymentOnPress(_ sender: Any) {
        
    }
}


extension CashierViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CashierTableViewCellId") as? CashierTableViewCell {
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    
}
