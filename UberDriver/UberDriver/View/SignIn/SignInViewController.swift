//
//  SignInViewController.swift
//  UberRider
//
//  Created by lieon on 2017/3/22.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var verticalCons: NSLayoutConstraint!
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    fileprivate var signinVM: AuthViewModel = AuthViewModel()
    fileprivate var maxYcontainerView: CGFloat = 0
    
    @IBAction func loginAction(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text, email.isValidEmail() {
            signinVM.login(with: email, password: password) { [unowned self] message in
                if let message = message, !message.isEmpty {
                    self.show(title: "Problem in Authentication", message: message)
                } else {
                    DriverViewModel.driverAccount = email
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.showDriverVC()
                }
            }
        } else {
          show(title: "Email or Password required", message: "Please enter email or password in textfield")
         }
        
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        if let email = emailTextField.text, let password = passwordTextField.text, email.isValidEmail() {
            signinVM.signup(with: email, password: password) { [unowned self] message in
                if let message = message, !message.isEmpty {
                    self.show(title: "Problem in Authentication", message: message)
                } else {
                    DriverViewModel.driverAccount = email
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.showDriverVC()
                }
            }
        } else {
            show(title: "Email or Password required", message: "Please enter email or password in textfield")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
          oberserveKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension SignInViewController {
    fileprivate func oberserveKeyboard() {
          maxYcontainerView = containerView.frame.maxY
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowAction(noti:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideAction(noti:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    @objc fileprivate func keyboardWillShowAction(noti: Notification) {
        guard let userInfo = noti.userInfo, let keyboardSize = userInfo[UIKeyboardFrameBeginUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardSize.height
        UIView.animate(withDuration: 0.25) {
            self.verticalCons.constant = 0 - (keyboardHeight - (UIScreen.main.bounds.height - self.maxYcontainerView))
            self.view.layoutIfNeeded()
     }
    }
    
   @objc fileprivate func keyboardWillHideAction(noti: Notification) {
       UIView.animate(withDuration: 0.25) {
            self.verticalCons.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate func showDriverVC() {
        self.performSegue(withIdentifier: "DriverHome", sender: nil)
    }
}
