//
//  CatalogCollectionViewCell.swift
//  macdonald_pos
//
//  Created by Jayden on 4/2/2022.
//

import UIKit

class CatalogCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cell_image: UIImageView!
    @IBOutlet weak var cell_text: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func toggleSelected (){
        if (isSelected){
            backgroundColor = UIColor.red
        }else {
            backgroundColor = UIColor.white
        }
    }

}
