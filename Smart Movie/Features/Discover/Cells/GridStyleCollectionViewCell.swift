//
//  GridStyleCollectionViewCell.swift
//  Smart Movie
//
//  Created by Phuong on 10/03/2022.
//

import UIKit
import Kingfisher

class GridStyleCollectionViewCell: UICollectionViewCell {
    
    private var presenter = DiscoverPresenter(model: DiscoverModel())
    var idMovie: Int = 0
    
    @IBOutlet weak var viewBound: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBound.layer.cornerRadius = 10
        viewBound.layer.shadowColor = UIColor.black.cgColor
        viewBound.layer.shadowOpacity = 0.3
        viewBound.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    func bindData(data: MovieEntity) {
        movieNameLabel.font = UIFont(name: "American Typewriter", size: self.frame.size.height/14)
//        movieNameLabel.font = UIFont.systemFont(ofSize: self.frame.size.height/13)
        timeLabel.font = UIFont.systemFont(ofSize: self.frame.size.height/15)
        
        movieNameLabel.text = data.title
        
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(data.posterPath)") {
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
        
        
        presenter.fetchMovieDetail(id: data.id)
        presenter.needReload = { [weak self] runTime in
            self?.timeLabel.text = self?.formatRunTime(runTime)
        }
        
        idMovie = data.id
        if DatabaseManager.share.checkFavorite(with: data.id) {
            self.starImageView.tintColor = .systemYellow
        } else {
            self.starImageView.tintColor = .gray
        }
    }
    
    
    func formatRunTime(_ time: Int) -> String {
        var hour: Int = 0
        var minute: Int = 0
        hour = Int(time/60)
        minute = time - hour * 60
        return "\(hour)h, \(minute)mins"
    }
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        if DatabaseManager.share.checkFavorite(with: idMovie){
            DatabaseManager.share.deleteFavorite(with: idMovie)
            self.starImageView.tintColor = .gray
        } else {
            DatabaseManager.share.addFavorite(id: idMovie)
            self.starImageView.tintColor = .systemYellow
        }
    }
    
}
