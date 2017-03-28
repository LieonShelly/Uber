//
//  SignInViewController.swift
//  UberRider
//
//  Created by lieon on 2017/3/22.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {

    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    fileprivate var signinVM: AuthViewModel = AuthViewModel()
    
    @IBAction func loginAction(_ sender: Any) {
        if  let email = emailTextField.text, let password = passwordTextField.text, email.isValidEmail() {
            signinVM.login(with: email, password: password) { [unowned self] message in
                if let message = message, !message.isEmpty {
                    self.show(title: "Problem in Authentication", message: message)
                } else {
                    RiderViewModel.riderAccount = email
                    self.showRiderVC()
                }
            }
        } else {
           self.show(title: "Email or Password required", message: "Please enter correct email or password in textfield")
        }
        
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text, email.isValidEmail() {
            signinVM.signup(with: email, password: password) { [unowned self] message in
                if let message = message, !message.isEmpty {
                    self.show(title: "Problem in Authentication", message: message)
                } else {
                    RiderViewModel.riderAccount = email
                    self.showRiderVC()
                }
            }
        } else {
            return self.show(title: "Email or Password required", message: "Please enter email or password in textfield")
        }
        
    }
    
    private func showRiderVC() {
        self.performSegue(withIdentifier: "RiderHome", sender: nil)
    }
}
