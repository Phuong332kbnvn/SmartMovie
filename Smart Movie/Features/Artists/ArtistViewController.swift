//
//  ArtistViewController.swift
//  Smart Movie
//
//  Created by Phuong on 10/03/2022.
//

import UIKit
import SwiftKeychainWrapper

class ArtistViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func invokeLogoutButton(_ sender: UIButton) {
        UsersAPIFetcher.share.fetchLogout()
//        let rootViewController = UIApplication.shared.windows.first?.rootViewController
//        if let topViewController = UIApplication.getTopViewController() {
//            if rootViewController?.children.first is TabbarControllerCustom {
        let storyboard = UIStoryboard.init(name: "SignInViewController", bundle: nil)
            guard let signInViewController = storyboard.instantiateViewController(withIdentifier: "SignInViewController") as? SignInViewController else {
            return
        }
//                topViewController.navigationController?.pushViewController(signInViewController, animated: true)
        signInViewController.modalPresentationStyle = .overFullScreen
        signInViewController.modalTransitionStyle = .crossDissolve
        present(signInViewController, animated: true, completion: nil)
//            } else {
//                topViewController.navigationController?.popToRootViewController(animated: true)
//            }
//        }
//        dismiss(animated: true)
    }
}
