//
//  ProfileViewController.swift
//  Smart Movie
//
//  Created by Phuong on 26/04/2022.
//

import UIKit
import Alamofire

class ProfileViewController: UIViewController {

    @IBOutlet private weak var firstNameTextField: UITextField!
    @IBOutlet private weak var lastNameTextField: UITextField!
    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var oldPasswordTextField: UITextField!
    @IBOutlet private weak var newPasswordTextField: UITextField!
    @IBOutlet private weak var confirmPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
    }
    
    private func setupData() {
        let fullName: String = UserDefaults.standard.string(forKey: fullnameUser) ?? ""
        let email: String = UserDefaults.standard.string(forKey: emailUser) ?? ""
        firstNameTextField.text = split(fullName: fullName).firstName
        lastNameTextField.text = split(fullName: fullName).lastName
        emailTextField.text = email
    }
    
    private func split(fullName: String) -> (firstName: String, lastName: String) {
        let string = fullName.components(separatedBy: " ")
        return (string[0], string[1])
    }
    
    @IBAction func invokeBackButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func invokeSavePasswordButton(_ sender: UIButton) {
        guard let oldPassword = oldPasswordTextField.text else { return }
        guard let newPassword = newPasswordTextField.text else { return }
        guard let confirmPassword = confirmPasswordTextField.text else { return }
        
        if ((oldPassword.elementsEqual(newPassword)) == true)
        {
            alertMessage(title: "Oops", message: "Please replace it with a new password")
            return
        }
        
        if ((newPassword.elementsEqual(confirmPassword)) != true)
        {
            alertMessage(title: "Oops", message: "Please make sure that passwords match")
            return
        }
        
        let user = ChangePassword(oldPassword: oldPassword, newPassword: newPassword)
        
        UsersAPIFetcher.share.fetchChangePassword(user: user) { isSuccess in
            if isSuccess {
                self.alertMessage(title: "Success", message: successfulChangePasswordMessage)
            } else {
                self.alertMessage(title: "Oops", message: failedChangePasawordMessage)
            }
        }
    }
    
    private func alertMessage(title: String, message: String) -> Void {
        DispatchQueue.main.async
            {
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                    self.oldPasswordTextField.text = ""
                    self.newPasswordTextField.text = ""
                    self.confirmPasswordTextField.text = ""
                }
                alertController.addAction(OKAction)
                self.present(alertController, animated: true, completion:nil)
        }
    }
}
