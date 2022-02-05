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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
