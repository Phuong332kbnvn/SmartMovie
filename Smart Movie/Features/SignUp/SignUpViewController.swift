//
//  SignUpViewController.swift
//  Smart Movie
//
//  Created by Phuong on 11/04/2022.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        backgroundView.layer.cornerRadius = 30
        
        signUpButton.layer.shadowColor = UIColor.systemBlue.cgColor
        signUpButton.layer.shadowOpacity = 0.5
        signUpButton.layer.shadowOffset = .zero
        signUpButton.layer.shadowRadius = 10
        signUpButton.layer.cornerRadius = 10
    }
    
    @IBAction func invokeSignUpButton(_ sender: UIButton) {
        guard let firstName = firstNameTextField.text else { return }
        guard let lastName = lastNameTextField.text else { return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let confirmPassword = confirmPasswordTextField.text else { return }
        
        if ((password.elementsEqual(confirmPassword)) != true)
        {
            alertMessage(title: "Oops", message: "Please make sure that passwords match")
            return
        }
        
        let user = RegisterModel(name: "\(firstName) \(lastName)", email: email, password: password)
        
        UsersAPIFetcher.share.fetchRegister(user: user) { (isSuccess) in
            if isSuccess {
                self.alertMessage(title: "Success", message: successfulRegistrationMessage)
            } else {
                self.alertMessage(title: "Oops", message: failedRegistrationMessage)
            }
        }
    }
    
    @IBAction func invokeSignInButton(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    private func alertMessage(title: String, message: String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    // Code in this block will trigger when OK button tapped.
                    print("Ok button tapped")
                    DispatchQueue.main.async
                    {
                        self.navigationController?.popViewController(animated: true)
//                        self.dismiss(animated: true, completion: nil)
                    }
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
        }
    }
}
