//
//  MoreDetailViewController.swift
//  Smart Movie
//
//  Created by Phuong on 10/03/2022.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {
    // MARK: - Variables
    private var presenter = MovieDetailPresenter(model: MovieDetailModel())
    private var listTrailer: [TrailerEntity] = []
    var idMovie: Int = 0
    var section: [String] = ["Cast","Similar"]
    
    // MARK: - IBOutlet
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var seeAllButton: UIButton!
    @IBOutlet weak var castTableView: UITableView!
    @IBOutlet var ratedImageView: [UIImageView]!
    @IBOutlet weak var voteAvengerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        
        presenter.fetchMovieDetail(id: idMovie)
        presenter.fetchTrailer(id: idMovie)
        presenter.fetchListCasts(id: idMovie)
        presenter.fetchListSimilar(id: idMovie)
        presenter.needReloadCast = { [weak self] in
            self?.castTableView.reloadData()
        }
        presenter.getListTrailers = { [weak self] results in
            self?.listTrailer = results
        }
        setupData()
    }
    
    func setupTableView() {
        castTableView.dataSource = self
        castTableView.delegate = self
        
        castTableView.separatorStyle = .none
        
        castTableView.register(CastTableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "CastTableViewHeaderFooterView")
        
        castTableView.register(UINib(nibName: "CastTableViewCell", bundle: nil), forCellReuseIdentifier: "CastTableViewCell")
        castTableView.register(UINib(nibName: "MovieTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieTableViewCell")
    }
    
    func setupData() {
        presenter.needReload = { [weak self] in
            guard let self = self else {
                return
            }
            guard let data = self.presenter.movieDetailEntity else {
                return ()
            }
            
            self.movieNameLabel.text = data.originalTitle
            self.overviewLabel.text = data.overview
            
            var genres: String = ""
            for genreIndex in 0..<data.genres.count {
                if genreIndex == data.genres.count - 1 {
                    genres.append("\(data.genres[genreIndex].name)")
                } else {
                    genres.append("\(data.genres[genreIndex].name) | ")
                }
            }
            self.genresLabel.text = genres
            
            self.languageLabel.text = "Language: \(data.spokenLanguages[0].englishName)"
            
            self.timeLabel.text = "\(self.formatDate(data.releaseDate)) (\(data.productionCountries[0].iso3166_1)) \(self.formatTime(data.runtime))"
            self.formatRating(data.voteAverage)
            self.voteAvengerLabel.text = "\(data.voteAverage) / 10"
            
            if let url = URL(string: "https://image.tmdb.org/t/p/w500\(data.posterPath)") {
                let processor = DownsamplingImageProcessor(size: self.movieImageView.bounds.size)
                |> RoundCornerImageProcessor(cornerRadius: 5)
                self.movieImageView.kf.setImage(with: url,
                                                placeholder: nil,
                                                options: [
                                                    .processor(processor),
                                                    .scaleFactor(UIScreen.main.scale),
                                                    .transition(.fade(1)),
                                                    .cacheOriginalImage
                                                ])
            }
            
            if DatabaseManager.share.checkRecent(with: data.id) {
                DatabaseManager.share.deleteRecent(with: data.id)
            }
            DatabaseManager.share.addRecent(id: data.id, name: data.title, posterPath: data.posterPath, time: data.runtime, overview: data.overview)
        }
    }
    
    func formatTime(_ time: Int) -> String {
        var hour: Int = 0
        var minute: Int = 0
        hour = Int(time/60)
        minute = time - hour * 60
        return "\(hour)h \(minute)m"
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
        return "\(monthString) \(item[2]), \(item[0])"
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
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func invokeWatchTrailerButton(_ sender: UIButton) {
        guard let url = URL(string: "https://www.youtube.com/embed/\(listTrailer[0].key)") else {
            return
        }
//        let storyboard = UIStoryboard.init(name: "TrailerViewController", bundle: nil)
//        guard let trailerViewController = storyboard.instantiateViewController(withIdentifier: "TrailerViewController") as? TrailerViewController else {
//            return
//        }
        let trailerViewController = WatchTrainerViewController()
        trailerViewController.modalPresentationStyle = .overFullScreen
        trailerViewController.url = url
        navigationController?.pushViewController(trailerViewController, animated: true)
    }
    
    @IBAction func invokeSeeAllButton(_ sender: UIButton) {
        overviewLabel.numberOfLines = 0
        seeAllButton.isHidden = true
    }
    
    @IBAction func invokeWatchReviewButton(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "ReviewViewController" , bundle: nil)
        guard let reviewViewController = storyboard.instantiateViewController(withIdentifier: "ReviewViewController") as? ReviewViewController else {
            return
        }
        reviewViewController.idMovie = self.idMovie
        navigationController?.pushViewController(reviewViewController, animated: true)
    }
}
// MARK: - UITableViewDataSource
extension MovieDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return presenter.numberOfRowsInSection()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CastTableViewCell", for: indexPath) as? CastTableViewCell else
            {
                return UITableViewCell()
            }
            cell.delegate = self
            cell.data = presenter.cellForRowCastAt(indexPath: indexPath)
            return cell
            
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as? MovieTableViewCell else
            {
                return UITableViewCell()
            }
            cell.bindData(presenter.cellForRowAt(indexPath: indexPath))
            return cell
            
        default:
            return UITableViewCell()
        }
    }
}
// MARK: - UITableViewDelegate
extension MovieDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CastTableViewHeaderFooterView") as? CastTableViewHeaderFooterView else {
            return UIView()
        }
        header.nameLabel.text = self.section[section]
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        40
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return self.view.frame.height/2 
        }
        return tableView.bounds.height/2.5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
        } else {
            let storyboard = UIStoryboard.init(name: "MovieDetail", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
                return
            }
            viewController.idMovie = presenter.getIDMovie(indexPath: indexPath)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        overviewLabel.numberOfLines = 3
        seeAllButton.isHidden = false
    }
}
// MARK: - Extension
extension MovieDetailViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
        setupTableView()
    }
}

extension MovieDetailViewController: MovieDetailViewProtocol {
    
    func refeshView() {
        castTableView.reloadData()
    }
    
    func showErrorMessage(_ message: String) {
        Logger.debug(message)
    }
    
    func displayListMovie(_ movieDetail: MovieDetailEntity) {
        Logger.debug(movieDetail)
    }
}

extension MovieDetailViewController: CastTableViewCellDelegate {
    func didSelectRowAt(idCast: Int) {
        let storyboard = UIStoryboard.init(name: "CastDetailViewController", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "CastDetailViewController") as? CastDetailViewController else {
                    return
                }
        viewController.idCast = idCast
        navigationController?.pushViewController(viewController, animated: true)
    }
}
