//
//  LogInViewController.swift
//  Smart Movie
//
//  Created by Phuong on 11/04/2022.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func setupUI(){
        backgroundView.layer.cornerRadius = 30
        
        signInButton.layer.shadowColor = UIColor.systemBlue.cgColor
        signInButton.layer.shadowOpacity = 0.5
        signInButton.layer.shadowOffset = .zero
        signInButton.layer.shadowRadius = 10
        signInButton.layer.cornerRadius = 10
    }

    @IBAction func invokeSignInButton(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let discoverViewController = storyboard.instantiateViewController(withIdentifier: "TabbarControllerCustom") as? TabbarControllerCustom else {
            return
        }
        present(discoverViewController, animated: true, completion: nil)
    }
    
    @IBAction func invokeSignUpButton(_ sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "SignUpViewController", bundle: nil)
        guard let signUpViewController = storyboard.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController else {
            return
        }
        present(signUpViewController, animated: true, completion: nil)
    }
    
    @IBAction func invokeForgotPasswordButton(_ sender: UIButton) {
    }
}
