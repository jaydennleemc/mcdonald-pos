//
//  PaymentViewController.swift
//  mcdonald POS
//
//  Created by Jayden on 9/2/2022.
//

import UIKit
import Toast

class PaymentTableViewCell: UITableViewCell {
    @IBOutlet weak var cell_image: UIImageView!
}

class PaymentViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let paymentMethods = ["visapay", "masterpay", "alipay", "wechatpay"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.dataSource = self
        self.tableView.delegate = self
    }

}

extension PaymentViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentTableViewCellId") as! PaymentTableViewCell
        cell.cell_image.image = UIImage(named: paymentMethods[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.view.makeToastActivity(.center)
        self.isModalInPresentation = true
        tableView.allowsSelection = false
        tableView.isScrollEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.isModalInPresentation = false
            tableView.allowsSelection = true
            tableView.isScrollEnabled = true
            self.view.hideToastActivity()
            var style = ToastStyle()
            style.messageFont = UIFont.systemFont(ofSize: 20)
            style.messageColor = .white
            style.backgroundColor = .darkGray
            self.view.makeToast("Count't connect payment system", duration: 3.0, position: .bottom, style: style)
        }
    }
    
}
