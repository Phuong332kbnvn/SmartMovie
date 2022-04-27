//
//  ArtistTableViewCell.swift
//  Smart Movie
//
//  Created by Phuong on 25/04/2022.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {

    @IBOutlet private weak var avatarImageView: UIImageView!
    @IBOutlet private weak var nameCategoryLabel: UILabel!
    @IBOutlet private weak var nextImageView: UIImageView!
    
    var state: Bool = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindData(data: ArtistCategory) {
        avatarImageView.image = UIImage(systemName: data.icon)
        nameCategoryLabel.text = data.name
        if state {
            nextImageView.isHidden = false
        } else {
            nextImageView.isHidden = true
        }

    }
    
}
