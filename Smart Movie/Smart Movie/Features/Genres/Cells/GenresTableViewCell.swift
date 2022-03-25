//
//  GenresTableViewCell.swift
//  Smart Movie
//
//  Created by Phuong on 15/03/2022.
//

import UIKit

class GenresTableViewCell: UITableViewCell {

    @IBOutlet weak var nameGenresLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindDat( data: GenreEntity) {
        nameGenresLabel.text = data.name
    }
}
