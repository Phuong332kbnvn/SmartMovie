//
//  DataViewController.swift
//  Smart Movie
//
//  Created by Phuong on 12/03/2022.
//

import UIKit
import SwiftUI
struct NameCategories {
    var title: String
}
class MoviesViewController: UIViewController {
    // MARK: - Variables
    private var presenter = DiscoverPresenter(model: DiscoverModel())
    private var nameCategories: [NameCategories] = []
    var pageIndex: Int!
    
    // MARK: - IBOutlet
    @IBOutlet weak var movieCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        
        presenter.fetchListPopularMovies(page: 1)
        presenter.fetchListTopRatedMovies(page: 1)
        presenter.fetchListUpcommingMovies(page: 1)
        presenter.fetchListNowPlayingMovies(page: 1)
        setupCollectionView()
        
        nameCategories.append(NameCategories(title: "Popular"))
        nameCategories.append(NameCategories(title: "Top Rated"))
        nameCategories.append(NameCategories(title: "Up Comming"))
        nameCategories.append(NameCategories(title: "Now Playing"))
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeStyle(noti:)), name: Notification.Name("StyleCell"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeStyle(noti:)), name: NSNotification.Name("favorite"), object: nil)
    }
    
    @objc func changeStyle(noti: Notification) {
        movieCollectionView.reloadData()
    }
    
    func setupCollectionView() {
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
        
        movieCollectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        movieCollectionView.register(UINib(nibName: "GridStyleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GridStyleCollectionViewCell")
        movieCollectionView.register(UINib(nibName: "ListStyleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListStyleCollectionViewCell")
        
        movieCollectionView.register(UINib(nibName: "HeaderCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView")
    }
}
// MARK: - UICollectionViewDataSource
extension MoviesViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        presenter.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfItemsInSection(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch StyleCell.mode {
        case .grid:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GridStyleCollectionViewCell.self), for: indexPath) as? GridStyleCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.idMovie = presenter.getIDMovie(indexPath: indexPath)
            cell.bindData(data: presenter.cellForRowAt(indexPath: indexPath))
            return cell
            
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ListStyleCollectionViewCell.self), for: indexPath) as? ListStyleCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.idMovie = presenter.getIDMovie(indexPath: indexPath)
            cell.bindData(data: presenter.cellForRowAt(indexPath: indexPath))
            return cell
        }
    }
    
}
// MARK: - UICollectionViewDelegate
extension MoviesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderCollectionReusableView", for: indexPath) as? HeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        headerView.bindData(nameCategories[indexPath.section])
        headerView.seeAllButton.tag = indexPath.section
        headerView.seeAllButton.addTarget(self, action: #selector(clickSeeAll(sender:)), for: .touchUpInside)
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "MovieDetail", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
            return
        }
        viewController.idMovie = presenter.getIDMovie(indexPath: indexPath)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension MoviesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch StyleCell.mode {
        case .grid:
            return CGSize(width: collectionView.bounds.width/2 - 30, height: collectionView.bounds.height/3)
        case .list:
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height/4)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        CGSize(width: collectionView.frame.width, height: collectionView.frame.height/9)
    }
    
}
// MARK: - Extension
extension MoviesViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
    
    @objc func clickSeeAll(sender: UIButton) {
        let position: Int = sender.tag + 1
        NotificationCenter.default.post(name: NSNotification.Name("goToPage"), object: nil, userInfo: ["position": position])
    }
}

extension MoviesViewController: DiscoverViewProtocol {
    func refeshView() {
        movieCollectionView.reloadData()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Load data failed", message: "Can't get data from server, please try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Reload", style: .default, handler: { (action: UIAlertAction!) in
            self.presenter.fetchData(page: 1)
        }))
        self.present(alert, animated: true, completion: nil)
    }

    func showErrorMessage(_ message: String) {
        Logger.debug(message)
    }

    func displayListMovie(_ listMovie: [MovieEntity]) {
        Logger.debug(listMovie)
    }

}
