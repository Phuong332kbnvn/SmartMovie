//
//  TopRatedViewController.swift
//  Smart Movie
//
//  Created by Phuong on 13/03/2022.
//

import UIKit

class TopRatedViewController: UIViewController {
    // MARK: - Variables
    private var presenter = DiscoverPresenter(model: DiscoverModel())
    private var loadingView: FooterCollectionReusableView?
    var refreshControl: UIRefreshControl?
    var pageIndex: Int!
    
    // MARK: - IBOutlet
    @IBOutlet weak var topRatedCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        presenter.fetchListTopRatedMovies(page: 1)
        
        setupCollectionView()
        addRefreshControl()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeStyle(noti:)), name: Notification.Name("StyleCell"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeStyle(noti:)), name: NSNotification.Name("favorite"), object: nil)
    }
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_ :)), for: .valueChanged)
        topRatedCollectionView.refreshControl = refreshControl
    }

    func setupCollectionView() {
        topRatedCollectionView.dataSource = self
        topRatedCollectionView.delegate = self
        topRatedCollectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        topRatedCollectionView.register(UINib(nibName: "GridStyleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GridStyleCollectionViewCell")
        topRatedCollectionView.register(UINib(nibName: "ListStyleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListStyleCollectionViewCell")
        topRatedCollectionView.register(UINib(nibName: "FooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterCollectionReusableView")
    }

    @objc func changeStyle(noti: Notification) {
        topRatedCollectionView.reloadData()
    }
    
    @objc func refresh(_ : Any) {
        presenter.refreshTopRated()
        refreshControl?.endRefreshing()
        topRatedCollectionView.reloadData()
    }
}
// MARK: - UICollectionViewDataSource
extension TopRatedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfRowsInTopRated(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch StyleCell.mode {
        case .grid:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GridStyleCollectionViewCell.self), for: indexPath) as? GridStyleCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.idMovie = presenter.getIDMovieOfTopRated(indexPath: indexPath)
            cell.bindData(data: presenter.cellForRowAtTopRated(indexPath: indexPath))
            return cell
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ListStyleCollectionViewCell.self), for: indexPath) as? ListStyleCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.idMovie = presenter.getIDMovieOfTopRated(indexPath: indexPath)
            cell.bindData(data: presenter.cellForRowAtTopRated(indexPath: indexPath))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.checkLoadMoreTopRated(indexPath: indexPath)
    }
}
// MARK: - UICollectionViewDelegate
extension TopRatedViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "MovieDetail", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
            return
        }
        viewController.idMovie = presenter.getIDMovieOfTopRated(indexPath: indexPath)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind{
        case UICollectionView.elementKindSectionFooter:
            if let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterCollectionReusableView", for: indexPath) as? FooterCollectionReusableView {
                loadingView = footerView
                return footerView
            }
        default:
            assert(false, "Unexpected element kind")
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.loadMoreIndicator.startAnimating()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.loadMoreIndicator.stopAnimating()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 50)
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension TopRatedViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch StyleCell.mode {
        case .grid:
            return CGSize(width: collectionView.bounds.width/2 - 30, height: collectionView.bounds.height/3)
        case .list:
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height/4)
        }
    }
    
}
// MARK: - Extension
extension TopRatedViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
}

extension TopRatedViewController: DiscoverViewProtocol {
    func refeshView() {
        topRatedCollectionView.reloadData()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Load data failed", message: "Can't get data from server, please try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Reload", style: .default, handler: { (action: UIAlertAction!) in
            self.presenter.fetchListTopRatedMovies(page: 1)
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
