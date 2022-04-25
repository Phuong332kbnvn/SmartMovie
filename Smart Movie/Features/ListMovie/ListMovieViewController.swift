//
//  FavoriteViewController.swift
//  Smart Movie
//
//  Created by Phuong on 25/04/2022.
//

import UIKit

class ListMovieViewController: UIViewController {
    private var presenter = ListMoviePresenter(model: ListMovieModel())
    
    @IBOutlet private weak var listNameLabel: UILabel!
    @IBOutlet private weak var listMovieCollectionView: UICollectionView!
    
    private var favoriteMovies: [Favorite] = []
    private var favoriteMoviesEntity: [MovieDetailEntity] = []
//    private var recentMovies: [Favorite] = []
    var state: ArtistCategoryType = .favorite
    var listName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.attach(view: self)
        
        setupCollectionView()
        setupData()
    }
    
    private func setupCollectionView() {
        listMovieCollectionView.dataSource = self
        listMovieCollectionView.delegate = self
        
        listMovieCollectionView.register(UINib(nibName: "ListStyleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListStyleCollectionViewCell")
    }
    
    private func setupData() {
        listNameLabel.text = listName
        favoriteMovies = DatabaseManager.share.getListFavorite()
        for movie in favoriteMovies {
            presenter.fetchMovie(id: Int(movie.id))
            favoriteMoviesEntity = presenter.movies
        }
    }

    @IBAction func invokeBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
}

// MARK: - UICollectionViewDataSource
extension ListMovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch state {
        case .favorite:
            return favoriteMoviesEntity.count
        case .recentMovie:
            return 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListStyleCollectionViewCell", for: indexPath) as? ListStyleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        switch state {
        case .favorite:
//            presenter.fetchMovie(id: Int(favoriteMovies[indexPath.row].id))
            let data = favoriteMoviesEntity[indexPath.row]
            cell.movieNameLabel.text = data.title
        default:
            return UICollectionViewCell()
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension ListMovieViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "MovieDetail", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
            return
        }
        switch state {
        case .favorite:
            viewController.idMovie = Int(favoriteMovies[indexPath.row].id)
        default:
            return
        }
        
        navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ListMovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height/4.5)
    }
}

extension ListMovieViewController: ListMovieViewProtocol {
    func refreshView() {
        listMovieCollectionView.reloadData()
    }
    
}
