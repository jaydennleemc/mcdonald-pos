//
//  MenuCollectionViewCell.swift
//  macdonald_pos
//
//  Created by Jayden on 4/2/2022.
//

import UIKit

class MenuCollectionViewCell: UICollectionViewCell {
    
    public static let Iditifier = "MenuCollectionViewCellId"

    @IBOutlet weak var cell_image: UIImageView!
    @IBOutlet weak var cell_text: UILabel!
    @IBOutlet weak var cell_price: UILabel!
    @IBOutlet weak var cell_selected: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func toggleSelected (){
        if (isSelected){
            self.cell_selected.isHidden = false
        }else {
            self.cell_selected.isHidden = true
        }
    }
}
