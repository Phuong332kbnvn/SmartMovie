//
//  ReviewTableViewCell.swift
//  Smart Movie
//
//  Created by Phuong on 24/04/2022.
//

import UIKit
import Kingfisher
class ReviewTableViewCell: UITableViewCell {

    @IBOutlet private weak var avatarImage: UIImageView!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var timeWriteLabel: UILabel!
    @IBOutlet private weak var contentLabel: UILabel!
    @IBOutlet var ratedImageView: [UIImageView]!
    @IBOutlet weak var rateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupUI() {
        avatarImage.layer.cornerRadius = avatarImage.frame.height/1.7
    }
    
    func bindData(data: AuthorReview) {
        authorNameLabel.text = data.author
        timeWriteLabel.text = String(data.createdAt.prefix(10))
        contentLabel.text = data.content
        guard let rate = data.authorDetails.rating else {
            return
        }
        rateLabel.text = "\(Int(rate))/10"
        formatRating(Int(rate))
        guard let avatarPath = data.authorDetails.avatarPath else {
            return
        }
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(avatarPath)") {
            let processor = DownsamplingImageProcessor(size: self.avatarImage.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: 5)
            self.avatarImage.kf.setImage(with: url,
                                            placeholder: nil,
                                            options: [
                                                .processor(processor),
                                                .scaleFactor(UIScreen.main.scale),
                                                .transition(.fade(1)),
                                                .cacheOriginalImage
                                            ])
        }
    }
    
    func formatRating(_ rate: Int) {
        if rate == 0 {
            return
        } else if rate < 2 {
            ratedImageView[0].tintColor = .systemYellow
        } else if rate < 4 {
            for indexStar in 0..<2 {
                ratedImageView[indexStar].tintColor = .systemYellow
            }
        } else if rate < 6 {
            for indexStar in 0..<3 {
                ratedImageView[indexStar].tintColor = .systemYellow
            }
        } else if rate < 8 {
            for indexStar in 0..<4 {
                ratedImageView[indexStar].tintColor = .systemYellow
            }
        } else {
            for indexStar in 0..<5 {
                ratedImageView[indexStar].tintColor = .systemYellow
            }
        }
    }
    
}
