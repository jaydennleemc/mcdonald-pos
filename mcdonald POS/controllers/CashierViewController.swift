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
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController
//        vc?.modalPresentationStyle = .fullScreen
        self.present(vc!, animated: true, completion: nil)
    }
    
    
    @IBAction func trashOnPress(_ sender: Any) {
        let alert = UIAlertController(title: "Warning", message: "Discard all record ??", preferredStyle: .alert)
        alert.setTitlet(font: UIFont.systemFont(ofSize: 18, weight: .bold), color: .red)
        alert.setMessage(font: UIFont.systemFont(ofSize: 14, weight: .regular), color: .black)
        alert.addAction(UIAlertAction(title: "Discard", style: .default, handler: { ActionHandler in
            debugPrint("discard all record")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
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
