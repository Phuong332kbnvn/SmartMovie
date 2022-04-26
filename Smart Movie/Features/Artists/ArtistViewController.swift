//
//  ArtistViewController.swift
//  Smart Movie
//
//  Created by Phuong on 10/03/2022.
//

import UIKit
import SwiftKeychainWrapper

class ArtistViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var artistTableView: UITableView!
    
    private var listCategory: [ArtistCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    private func setupUI() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height/2.1
    }
    
    private func setupData() {
        listCategory = [
            ArtistCategory(icon: "person.fill", name: "Profile", type: .infor),
            ArtistCategory(icon: "heart.fill", name: "Favorite", type: .favorite),
            ArtistCategory(icon: "list.bullet.rectangle.portrait.fill", name: "Recent", type: .recent),
            ArtistCategory(icon: "rectangle.portrait.and.arrow.right.fill", name: "Log out", type: .logout)
        ]
    }
    
    private func setupTableView() {
        artistTableView.dataSource = self
        artistTableView.delegate = self
        
        artistTableView.register(UINib(nibName: "ArtistTableViewCell", bundle: nil), forCellReuseIdentifier: "ArtistTableViewCell")
    }

}

extension ArtistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ArtistTableViewCell") as? ArtistTableViewCell else {
            return UITableViewCell()
        }
        cell.bindData(data: listCategory[indexPath.row])
        return cell
    }
}

extension ArtistViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch listCategory[indexPath.row].type {
        case .infor:
            let storyboard = UIStoryboard.init(name: "ProfileViewController", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as? ProfileViewController else {
                return
            }
            navigationController?.pushViewController(viewController, animated: true)
        case .favorite:
            let storyboard = UIStoryboard.init(name: "ListMovieViewController", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "ListMovieViewController") as? ListMovieViewController else {
                return
            }
            viewController.state = .favorite
            viewController.listName = listCategory[indexPath.row].name
            navigationController?.pushViewController(viewController, animated: true)
        case .recent:
            let storyboard = UIStoryboard.init(name: "ListMovieViewController", bundle: nil)
            guard let viewController = storyboard.instantiateViewController(withIdentifier: "ListMovieViewController") as? ListMovieViewController else {
                return
            }
            viewController.state = .recent
            viewController.listName = listCategory[indexPath.row].name
            navigationController?.pushViewController(viewController, animated: true)
        case .logout:
            logout(title: "Log Out", messsage: "Do you want log out?")
        }
    }
}

extension ArtistViewController {
    private func logout(title: String, messsage: String) {
        let alert = UIAlertController(title: title, message: messsage, preferredStyle: .alert)
        let YesAction = UIAlertAction(title: "Yes", style: .default) { (action:UIAlertAction!) in
            UsersAPIFetcher.share.fetchLogout()
            let storyboard = UIStoryboard.init(name: "SignInViewController", bundle: nil)
                guard let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController else {
                return
            }
            signInViewController.modalPresentationStyle = .overFullScreen
            signInViewController.modalTransitionStyle = .crossDissolve
            self.present(signInViewController, animated: true, completion: nil)
        }
        let NoAction = UIAlertAction(title: "No", style: .cancel) { (action:UIAlertAction!) in
            
        }
        alert.addAction(YesAction)
        alert.addAction(NoAction)
        self.present(alert, animated: true, completion:nil)
    }
}
