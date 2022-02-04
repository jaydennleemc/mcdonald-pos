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
    
    let data = [1,2,3,4,5,6,7,8]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initCollectionView()
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
}

extension CatalogViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // handle catalog collection view data
        if collectionView == catalogCollectionView {
            let cell = catalogCollectionView.dequeueReusableCell(withReuseIdentifier: "CatalogCollectionViewCellId", for: indexPath) as! CatalogCollectionViewCell
            return cell
        }
        // handle menu collection view data
        if collectionView == menuCollectionView {
            let cell = menuCollectionView.dequeueReusableCell(withReuseIdentifier: "MenuCollectionViewCellId", for: indexPath) as! MenuCollectionViewCell
            return cell
        }
        return UICollectionViewCell()
    }
        
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle catalog collection view did select action
        if collectionView == catalogCollectionView {
            let cell = catalogCollectionView.cellForItem(at: indexPath) as! CatalogCollectionViewCell
            cell.toggleSelected()
        }
        
        // handle menu collection view did select action
        if collectionView == menuCollectionView {
            
        }
        
    }
}
