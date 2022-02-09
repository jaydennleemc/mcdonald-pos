//
//  CatalogCollectionViewCell.swift
//  macdonald_pos
//
//  Created by Jayden on 4/2/2022.
//

import UIKit

class CatalogCollectionViewCell: UICollectionViewCell {
    
    public static let Iditifier = "CatalogCollectionViewCellId"
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var cell_image: UIImageView!
    @IBOutlet weak var cell_text: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func toggleSelected (){
        if (isSelected){
            self.container.layer.cornerRadius = 10
            self.container.clipsToBounds = true
            self.container.backgroundColor = UIColor(named: "theme_color")
        }else {
            self.container.backgroundColor = UIColor.clear
        }
    }

}
