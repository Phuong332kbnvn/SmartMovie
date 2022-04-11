//
//  WatchTrainerViewController.swift
//  Smart Movie
//
//  Created by Tú on 28/03/2022.
//

import UIKit
import WebKit

class WatchTrainerViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    //MARK: Vars
    var url: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        setupView()
        
    }

    //MARK: Functions
     private func setupView() {
        showAnimate()
        guard let url = url else {
//            showAlert(title: "Error", message: "Invalid URL")
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    private func showAnimate() {
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    private func removeAnimate() {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: { (finished : Bool)  in
            if (finished) {
                self.view.removeFromSuperview()
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func invokeCloseButton(_ sender: UIButton) {
        removeAnimate()
        navigationController?.popViewController(animated: true)
    }
}

//MARK: WKNavigationDelegate
extension WatchTrainerViewController: WKNavigationDelegate {
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        loadingView.isHidden = true
//    }
}
