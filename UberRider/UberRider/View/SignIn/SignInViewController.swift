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
        guard let email = emailTextField.text, let password = passwordTextField.text else { return self.show(title: "Email or Password required", message: "Please enter email or password in textfield") }
        signinVM.login(with: email, password: password) { [unowned self] message in
            if let message = message, !message.isEmpty {
                self.show(title: "Problem in Authentication", message: message)
            } else {
                RiderViewModel.riderAccount = email
                self.showRiderVC()
            }
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return self.show(title: "Email or Password required", message: "Please enter email or password in textfield") }
        signinVM.signup(with: email, password: password) { [unowned self] message in
            if let message = message, !message.isEmpty {
                self.show(title: "Problem in Authentication", message: message)
            } else {
                 RiderViewModel.riderAccount = email
                self.showRiderVC()
            }
        }
    }
    
    private func showRiderVC() {
        self.performSegue(withIdentifier: "RiderHome", sender: nil)
    }
}
