//
//  ListStyleCollectionViewCell.swift
//  Smart Movie
//
//  Created by Phuong on 10/03/2022.
//

import UIKit
import Kingfisher

class ListStyleCollectionViewCell: UICollectionViewCell {
    
    private var presenter = DiscoverPresenter(model: DiscoverModel())
    var idMovie: Int = 0
    var name: String = ""
    var posterPath: String = ""
    var time: Int = 0
    var overview: String = ""
    
    
    @IBOutlet weak var viewBound: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBound.layer.cornerRadius = 10
        viewBound.layer.shadowColor = UIColor.black.cgColor
        viewBound.layer.shadowOpacity = 0.3
        viewBound.layer.shadowOffset = CGSize(width: 0, height: 0)
        
    }
    
    func bindData(data: MovieEntity) {
        
        movieNameLabel.font = UIFont(name: "American Typewriter", size: self.frame.size.height/9)
        timeLabel.font = UIFont.systemFont(ofSize: self.frame.size.height/10)
        overviewLabel.font = UIFont.systemFont(ofSize: self.frame.size.height/10)
        
        movieNameLabel.text = "\(data.title) (\(formatDate(data.releaseDate)))"
        timeLabel.text = self.formatRunTime(presenter.getRunTimeMovie(data: data, id: data.id))
        overviewLabel.text = data.overview
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
        if DatabaseManager.share.checkFavorite(with: data.id, of: idOfUser ?? "") {
            self.starImageView.tintColor = .systemYellow
        } else {
            self.starImageView.tintColor = .gray
        }
        
        name = data.title
        posterPath = data.posterPath
        time = presenter.getRunTimeMovie(data: data, id: data.id)
        overview = data.overview
    }
    
    func bindDataForFavorite(data: Favorite) {
        movieNameLabel.font = UIFont(name: "American Typewriter", size: self.frame.size.height/9)
        timeLabel.font = UIFont.systemFont(ofSize: self.frame.size.height/10)
        overviewLabel.font = UIFont.systemFont(ofSize: self.frame.size.height/10)
        
        movieNameLabel.text = data.name
        timeLabel.text = self.formatRunTime(Int(data.time))
        overviewLabel.text = data.overview
        
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
        
        if DatabaseManager.share.checkFavorite(with: Int(data.id), of: idOfUser ?? "") {
            self.starImageView.tintColor = .systemYellow
        } else {
            self.starImageView.tintColor = .gray
        }
        
    }
    
    func bindDataForRecent(data: Recent) {
        movieNameLabel.font = UIFont(name: "American Typewriter", size: self.frame.size.height/9)
        timeLabel.font = UIFont.systemFont(ofSize: self.frame.size.height/10)
        overviewLabel.font = UIFont.systemFont(ofSize: self.frame.size.height/10)
        
        movieNameLabel.text = data.name
        timeLabel.text = self.formatRunTime(Int(data.time))
        overviewLabel.text = data.overview
        
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
        
        if DatabaseManager.share.checkFavorite(with: Int(data.id), of: idOfUser ?? "") {
            self.starImageView.tintColor = .systemYellow
        } else {
            self.starImageView.tintColor = .gray
        }
        
    }
    
    func formatDate(_ date: String) -> String {
        let item = date.components(separatedBy: "-")
        let month = Int(item[1])
        var monthString: String = ""
        switch month {
        case 1:
            monthString = "January"
        case 2:
            monthString = "February"
        case 3:
            monthString = "March"
        case 4:
            monthString = "April"
        case 5:
            monthString = "May"
        case 6:
            monthString = "June"
        case 7:
            monthString = "July"
        case 8:
            monthString = "August"
        case 9:
            monthString = "September"
        case 10:
            monthString = "October"
        case 11:
            monthString = "November"
        case 12:
            monthString = "December"
        default:
            break
        }
        return "\(item[2]) \(monthString) \(item[0])"
    }

    func formatRunTime(_ time: Int) -> String {
        var hour: Int = 0
        var minute: Int = 0
        hour = Int(time/60)
        minute = time - hour * 60
        return "\(hour)h, \(minute)mins"
    }
    
    @IBAction func favoriteButton(_ sender: UIButton) {
        if DatabaseManager.share.checkFavorite(with: idMovie, of: idOfUser ?? ""){
            DatabaseManager.share.deleteFavorite(with: idMovie, of: idOfUser ?? "")
            self.starImageView.tintColor = .gray
        } else {
            DatabaseManager.share.addFavorite(idUser: idOfUser ?? "", id: idMovie, name: name, posterPath: posterPath, time: time, overview: overview)
            self.starImageView.tintColor = .systemYellow
        }
    }
    
}
