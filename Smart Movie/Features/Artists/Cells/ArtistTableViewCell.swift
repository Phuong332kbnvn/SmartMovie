//
//  ArtistTableViewCell.swift
//  Smart Movie
//
//  Created by Phuong on 25/04/2022.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameCategoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindData(data: ArtistCategory) {
        avatarImageView.image = UIImage(systemName: data.icon)
        nameCategoryLabel.text = data.name
    }
    
}
