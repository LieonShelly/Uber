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
    fileprivate var signinVM: SignInViewModel = SignInViewModel()
    
    @IBAction func loginAction(_ sender: Any) {
        
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        signinVM.login(with: email, password: password) { [unowned self] message in
            if let message = message, !message.isEmpty {
                self.show(title: "Problem in Authentication", message: message)
            }
        }
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
