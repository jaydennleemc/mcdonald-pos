//
//  CashierTableViewCell.swift
//  mcdonald POS
//
//  Created by Jayden on 5/2/2022.
//

import UIKit

class CashierTableViewCell: UITableViewCell {
    
    public static let Iditifier = "CashierTableViewCellId"

    @IBOutlet weak var cell_image: UIImageView!
    @IBOutlet weak var cell_name: UILabel!
    @IBOutlet weak var cell_price: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
