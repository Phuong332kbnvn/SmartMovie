//
//  MovieTableViewCell.swift
//  Smart Movie
//
//  Created by Phuong on 14/03/2022.
//

import UIKit
import Kingfisher

class MovieTableViewCell: UITableViewCell {
    
    private var presenter = SearchPresenter(model: SearchModel())
    private var listGenres: [GenreEntity] = []
    
    @IBOutlet weak var viewBound: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet var ratedImageView: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        presenter.fetchListgenres()
        
        viewBound.layer.cornerRadius = 10
        viewBound.layer.shadowColor = UIColor.black.cgColor
        viewBound.layer.shadowOpacity = 0.3
        viewBound.layer.shadowOffset = CGSize(width: 0, height: 0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func bindData(_ data: MovieEntity) {
        movieNameLabel.font = UIFont(name: "American Typewriter", size: self.frame.size.height/8)
        genresLabel.font = UIFont.systemFont(ofSize: self.frame.size.height/9)
        
        movieNameLabel.text = data.title
        
        presenter.needReload = { [weak self] () in
            var genres: String = ""
            for genreIndex in 0..<data.genreIDs.count {
                if genreIndex == data.genreIDs.count - 1 {
                    genres.append("\(self?.presenter.getNameGenre(id: data.genreIDs[genreIndex]) ?? "")")
                } else {
genres.append("\(self?.presenter.getNameGenre(id: data.genreIDs[genreIndex]) ?? "") | ")
                }
            }
            self?.genresLabel.text = genres
        }
        
        self.formatRating(data.voteAverage)
        
        guard let backdrop = data.backdropPath else {
            return
        }
        if let url = URL(string: "https://image.tmdb.org/t/p/w500\(backdrop)") {
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
    
    
    func formatRating(_ voteAverage: Double) {
        if voteAverage == 0 {
            return
        } else if voteAverage < 2 {
            ratedImageView[0].tintColor = .systemYellow
        } else if voteAverage < 4 {
            for indexStar in 0..<2 {
                ratedImageView[indexStar].tintColor = .systemYellow
            }
        } else if voteAverage < 6 {
            for indexStar in 0..<3 {
                ratedImageView[indexStar].tintColor = .systemYellow
            }
        } else if voteAverage < 8 {
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
