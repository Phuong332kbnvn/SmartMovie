//
//  CastCollectionViewCell.swift
//  Smart Movie
//
//  Created by Phuong on 17/03/2022.
//

import UIKit
import Kingfisher

class CastCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var castImageView: UIImageView!
    @IBOutlet weak var castNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindData(_ data: CastEntity) {
        castNameLabel.font = UIFont(name: "Avenir Next", size: self.frame.size.height/11)
        castNameLabel.text = data.name
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(data.profilePath ?? "")") {
        let processor = DownsamplingImageProcessor(size: castImageView.bounds.size)
                    |> RoundCornerImageProcessor(cornerRadius: 5)
        castImageView.kf.setImage(with: url,
                                            placeholder: nil,
                                            options: [
                                                .processor(processor),
                                                .scaleFactor(UIScreen.main.scale),
                                                .transition(.fade(1)),
                                                .cacheOriginalImage
                                            ])
                }
    }
}
