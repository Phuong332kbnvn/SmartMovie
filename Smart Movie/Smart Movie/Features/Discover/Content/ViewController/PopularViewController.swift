//
//  PopularViewController.swift
//  Smart Movie
//
//  Created by Phuong on 13/03/2022.
//

import UIKit

class PopularViewController: UIViewController {
    // MARK: - Variables
    private var presenter = DiscoverPresenter(model: DiscoverModel())
    private var loadingView: FooterCollectionReusableView?
    fileprivate var activityIndicator: LoadMoreActivityIndicator!
    var refreshControl: UIRefreshControl?
    var pageIndex: Int!
    
    // MARK: - IBOutlet
    @IBOutlet weak var popularCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attach(view: self)
        
        presenter.fetchListPopularMovies(page: 1)
        
        setupCollectionView()
        addRefreshControl()
        
        NotificationCenter.default.addObserver(self, selector: #selector(changeStyle(noti:)), name: Notification.Name("StyleCell"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeStyle(noti:)), name: NSNotification.Name("favorite"), object: nil)
    }
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(refresh(_ :)), for: .valueChanged)
        popularCollectionView.refreshControl = refreshControl
    }

    func setupCollectionView() {
        popularCollectionView.dataSource = self
        popularCollectionView.delegate = self
        popularCollectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        
        
        popularCollectionView.register(UINib(nibName: "GridStyleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GridStyleCollectionViewCell")
        popularCollectionView.register(UINib(nibName: "ListStyleCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ListStyleCollectionViewCell")
        popularCollectionView.register(UINib(nibName: "FooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterCollectionReusableView")
    }
    
    @objc func changeStyle(noti: Notification) {
        popularCollectionView.reloadData()
    }
    
    @objc func refresh(_ : Any) {
        presenter.refreshPopular()
        refreshControl?.endRefreshing()
        popularCollectionView.reloadData()
    }
}
// MARK: - UICollectionViewDataSource
extension PopularViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.numberOfRowsInPopular(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch StyleCell.mode {
        case .grid:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GridStyleCollectionViewCell.self), for: indexPath) as? GridStyleCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.idMovie = presenter.getIDMovieOfPopular(indexPath: indexPath)
            cell.bindData(data: presenter.cellForRowAtPopular(indexPath: indexPath))
            return cell
        case .list:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ListStyleCollectionViewCell.self), for: indexPath) as? ListStyleCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.idMovie = presenter.getIDMovieOfPopular(indexPath: indexPath)
            cell.bindData(data: presenter.cellForRowAtPopular(indexPath: indexPath))
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        presenter.checkLoadMorePopular(indexPath: indexPath)
    }
}
// MARK: - UICollectionViewDelegate
extension PopularViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "MovieDetail", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "MovieDetailViewController") as? MovieDetailViewController else {
            return
        }
        viewController.idMovie = presenter.cellForRowAtPopular(indexPath: indexPath).id
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
extension PopularViewController: UICollectionViewDelegateFlowLayout {
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
extension PopularViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
}

extension PopularViewController: DiscoverViewProtocol {
    func refeshView() {
        popularCollectionView.reloadData()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Load data failed", message: "Can't get data from server, please try again later.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Reload", style: .default, handler: { (action: UIAlertAction!) in
            self.presenter.fetchListPopularMovies(page: 1)
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
