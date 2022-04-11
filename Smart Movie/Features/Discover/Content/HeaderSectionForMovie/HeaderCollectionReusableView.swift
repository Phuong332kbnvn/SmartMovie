//
//  HeaderCollectionReusableView.swift
//  Smart Movie
//
//  Created by Phuong on 13/03/2022.
//

import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var nameCategoryLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bindData(_ data: NameCategories) {
        nameCategoryLabel.text = data.title
    }
    
    @IBAction func seeAllButton(_ sender: UIButton) {
        
    }
    
}
