//
//  DiscoverViewController.swift
//  Smart Movie
//
//  Created by Phuong on 08/03/2022.
//

import Foundation
import UIKit

final class DiscoverViewController: UIViewController {
    // MARK: - Variables
    private var presenter = DiscoverPresenter(model: DiscoverModel())
    private var currentIndex: Int?
    private var pageController: UIPageViewController!
    private let dataSource: [[MovieEntity]] = []
    private var listViewController: [UIViewController] = []
    

    // MARK: - IBOutlet
    @IBOutlet private var tabsView: TabsView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var styleCellImageView: UIImageView!
    @IBOutlet weak var midIndicator: UIActivityIndicatorView!
    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        containerView.isHidden = true
        midIndicator.startAnimating()
        presenter.fetchData(page: 1)
        presenter.handleAPIError = { [weak self] viewController, pageType in
            guard let self = self else {
                return
            }
            for (index, value) in self.listViewController.enumerated() {
                if index == viewController {
                    self.listViewController.remove(at: index)
                    self.pageController.reloadInputViews()
                }
            }
            for (index, value) in self.tabsView.tabs.enumerated() {
                if pageType == value.type {
                    self.tabsView.tabs.remove(at: index)
                    self.tabsView.collectionView.reloadData()
                }
            }
            self.containerView.isHidden = false
        }
        presenter.needReloadData = { [weak self] in
            self?.containerView.isHidden = false
            self?.midIndicator.stopAnimating()
        }
        presenter.hanđleAllAPIFail = { [weak self] in
            self?.containerView.isHidden = true
            self?.showErrorMessage(title: "Load data failed", message: "Can't get data from server, please try again later.")
        }
        presenter.attach(view: self)
        setupTabs()
        
        setupPageViewController()
        
        initSubViewController()
        pageController.setViewControllers([listViewController[0]], direction: .forward, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(receivedNotification(noti:)), name: NSNotification.Name("goToPage"), object: nil)
    }
    
    private func setupTabs() {
            tabsView.tabs = [
                Tab(title: "Movies", type: .movies),
                Tab(title: "Popular", type: .popular),
                Tab(title: "Top Rated", type: .topRated),
                Tab(title: "Up Comming", type: .upcomming),
                Tab(title: "Now Playing", type: .nowPlaying)
            ]
        
            tabsView.tabMode = .scrollable
            
            // TabView Customization
            tabsView.titleColor = .gray
            tabsView.indicatorColor = .gray
            tabsView.titleFont = UIFont.systemFont(ofSize: 20, weight: .semibold)
            
            // Set TabsView Delegate
            tabsView.delegate = self
            
            // Set the selected Tab when the app starts
            tabsView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
    }
    
    private func initSubViewController() {
        let storyboard = UIStoryboard.init(name: "DataViewController", bundle: nil)
        let homeViewController = storyboard.instantiateViewController(withIdentifier: "MoviesViewController") as! MoviesViewController

        let popularViewController = storyboard.instantiateViewController(withIdentifier: "PopularViewController") as! PopularViewController

        let toprateViewController = storyboard.instantiateViewController(withIdentifier: "TopRatedViewController") as! TopRatedViewController

        let upComingViewController =  storyboard.instantiateViewController(withIdentifier: "UpcommingViewController") as! UpcommingViewController

        let nowPlayingViewController = storyboard.instantiateViewController(withIdentifier: "NowPlayingViewController") as! NowPlayingViewController

        listViewController = [homeViewController, popularViewController, toprateViewController, upComingViewController, nowPlayingViewController]

        }
    
    private func setupPageViewController() {
        // PageViewController
        let storyboard = UIStoryboard.init(name: "TabsPageViewController", bundle: nil)
        guard let pageController = storyboard.instantiateViewController(withIdentifier: "TabsPageViewController") as? TabsPageViewController else {
            return
        }
        
        // Set PageViewController Delegate & DataSource
        pageController.delegate = self
        pageController.dataSource = self
        
        self.pageController = pageController
        
        self.addChild(pageController)
        contentView.addSubview(pageController.view)

        // PageViewController Constraints
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageController.view.topAnchor.constraint(equalTo: self.tabsView.bottomAnchor),
            pageController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            pageController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            pageController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Refresh CollectionView Layout when you rotate the device
        tabsView.collectionView.collectionViewLayout.invalidateLayout()
    }
    
    @IBAction func StyleCellButton(_ sender: UIButton) {
        StyleCell.mode = StyleCell.mode == .grid ? .list : .grid
        switch StyleCell.mode {
        case .grid:
            styleCellImageView.image = UIImage(systemName: "line.3.horizontal")
        case .list:
            styleCellImageView.image = UIImage(systemName: "square.grid.2x2.fill")
        }
        NotificationCenter.default.post(name: NSNotification.Name("StyleCell"), object: nil)
    }
}
// MARK: - TabsDelegate
extension DiscoverViewController: TabsDelegate {
    func tabsViewDidSelectItemAt(position: Int) {
        if position != currentIndex {
            pageController?.setViewControllers([listViewController[position]], direction: .forward, animated: true, completion: nil)
            tabsView.collectionView.scrollToItem(at: IndexPath(item: position, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}
// MARK: - UIPageViewControllerDataSource,UIPageViewControllerDelegate
extension DiscoverViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return listViewController.count
    }
    // return ViewController when go forward
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = listViewController.firstIndex(of: viewController) ?? 0
        if(currentIndex <= 0) {
            return nil
        }
        return listViewController[currentIndex - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = listViewController.firstIndex(of: viewController) ?? 0
        if(currentIndex >= listViewController.count-1) {
            return nil
        }
        return listViewController[currentIndex + 1]

    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            if completed {
                guard let vc = pageViewController.viewControllers?.first else { return }
                let index: Int
                index = getVCPageIndex(vc)

                tabsView.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredVertically)
                // Animate the tab in the TabsView to be centered when you are scrolling using .scrollable
                tabsView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
//
        NotificationCenter.default.post(name: NSNotification.Name("favorite"), object: nil)
    }

    func getVCPageIndex(_ viewController: UIViewController?) -> Int {
        for (index, controller) in listViewController.enumerated() {
            if viewController === controller {
                currentIndex = index
                return index
            }
        }
        return 0

    }
}
// MARK: - Extension
extension DiscoverViewController {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.viewDidAppear()
    }
    
    @objc private func receivedNotification(noti: Notification) {
        if let position = noti.userInfo?["position"] as? Int {
            currentIndex = position
            pageController.setViewControllers([listViewController[position]], direction: .forward, animated: true, completion: nil)
            tabsView.collectionView.selectItem(at: IndexPath(item: position, section: 0), animated: true, scrollPosition: .centeredVertically)
        }
    }
    
    func showErrorMessage(title: String, message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else {
                return
                }
                let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Reload", style: .default) { (act) in
                    self.presenter.recallApiError()
                })
                self.present(alert, animated: true)
            }
        }
}

extension DiscoverViewController: DiscoverViewProtocol {
    
    func refeshView() {
        
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
