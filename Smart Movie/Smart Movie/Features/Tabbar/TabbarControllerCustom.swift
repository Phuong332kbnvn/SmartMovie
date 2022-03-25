//
//  TabbarControllerCustom.swift
//  Smart Movie
//
//  Created by Phuong on 10/03/2022.
//

import UIKit
@available(iOS 13.0, *)
final class TabbarControllerCustom: UITabBarController {
    
    //MARK: - Properties
    private lazy var discoverViewController: DiscoverViewController = {
        let storyboard = UIStoryboard.init(name: "Discover", bundle: nil)
        let discoverViewController = storyboard.instantiateViewController(withIdentifier: "Discover") as! DiscoverViewController
        discoverViewController.tabBarItem.image = UIImage(systemName: "square.grid.2x2.fill")?.withTintColor(.gray)
        discoverViewController.tabBarItem.selectedImage = UIImage(systemName: "square.grid.2x2.fill")?.withTintColor(.systemBlue)
        discoverViewController.tabBarItem.title = "Discover"
        return discoverViewController
    }()
    
    private lazy var searchViewController: SearchViewController = {
        let storyboard = UIStoryboard.init(name: "Search", bundle: nil)
        let searchViewController = storyboard.instantiateViewController(withIdentifier: "Search") as! SearchViewController
        searchViewController.tabBarItem.image = UIImage(systemName: "magnifyingglass")?.withTintColor(.gray)
        searchViewController.tabBarItem.selectedImage = UIImage(systemName: "magnifyingglass")?.withTintColor(.systemBlue)
        searchViewController.tabBarItem.title = "Search"
        return searchViewController
    }()
    
    private lazy var genresViewController: GenresViewController = {
        let storyboard = UIStoryboard.init(name: "Genres", bundle: nil)
        let genresViewController = storyboard.instantiateViewController(withIdentifier: "Genres") as! GenresViewController
        genresViewController.tabBarItem.image = UIImage(systemName: "bolt.horizontal.fill")?.withTintColor(.gray)
        genresViewController.tabBarItem.selectedImage = UIImage(systemName: "bolt.horizontal.fill")?.withTintColor(.systemBlue)
        genresViewController.tabBarItem.title = "Genres"
        return genresViewController
    }()
    
    private lazy var artistViewController: ArtistViewController = {
        let storyboard = UIStoryboard.init(name: "Artist", bundle: nil)
        let artistViewController = storyboard.instantiateViewController(withIdentifier: "Artist") as! ArtistViewController
        artistViewController.tabBarItem.image = UIImage(systemName: "person.crop.circle")?.withTintColor(.gray)
        artistViewController.tabBarItem.selectedImage = UIImage(systemName: "person.crop.circle")?.withTintColor(.systemBlue)
        artistViewController.tabBarItem.title = "Artist"
        return artistViewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        customTabbarTitle()
        
        let discoverNavigation = UINavigationController.init(rootViewController: discoverViewController)
        let searchNavigation = UINavigationController.init(rootViewController: searchViewController)
        let genresNavigation = UINavigationController.init(rootViewController: genresViewController)
        let artistNavigation = UINavigationController.init(rootViewController: artistViewController)
        
        self.viewControllers = [discoverNavigation, searchNavigation, genresNavigation, artistNavigation]
        tabBar.backgroundColor = .white
        selectedIndex = 0
    }
    
    private func customTabbarTitle() {
    
            let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Bold", size: 14)!,NSAttributedString.Key.foregroundColor:UIColor.systemBlue]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.font:UIFont(name: "HelveticaNeue-Bold", size: 12)!,NSAttributedString.Key.foregroundColor:UIColor.gray]
            tabBar.standardAppearance = appearance
            self.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        
    }
}
