//
//  MovieOfCastCollectionViewCell.swift
//  Smart Movie
//
//  Created by Phuong on 26/04/2022.
//

import UIKit
import Kingfisher

class MovieOfCastCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func bindData(data: MovieOfCastEntity) {
        movieNameLabel.text = data.title
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(data.posterPath ?? "")") {
        let processor = DownsamplingImageProcessor(size: movieImageView.bounds.size)
                    |> RoundCornerImageProcessor(cornerRadius: 5)
            movieImageView.kf.setImage(with: url,
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
