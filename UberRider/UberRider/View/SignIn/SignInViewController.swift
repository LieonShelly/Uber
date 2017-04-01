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
    fileprivate var maxYContainerView: CGFloat = 0.0
    @IBOutlet weak var verticalCons: NSLayoutConstraint!
    fileprivate var originalTopDistance: CGFloat = 0
    @IBOutlet fileprivate weak var emailTextField: UITextField!
    @IBOutlet fileprivate weak var passwordTextField: UITextField!
    fileprivate var signinVM: AuthViewModel = AuthViewModel()
    
    @IBAction func loginAction(_ sender: Any) {
        //FIXME: 去掉测试的自动填入
        emailTextField.text = "lieoncx@gmail.com"
        passwordTextField.text = "123456"
        if  let email = emailTextField.text, let password = passwordTextField.text, email.isValidEmail() {
            signinVM.login(with: email, password: password) { [unowned self] message in
                if let message = message, !message.isEmpty {
                    self.show(title: "Problem in Authentication", message: message)
                } else {
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
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
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    RiderViewModel.riderAccount = email
                    self.showRiderVC()
                }
            }
        } else {
            return self.show(title: "Email or Password required", message: "Please enter email or password in textfield")
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        originalTopDistance = verticalCons.constant
        maxYContainerView = UIScreen.main.bounds.height - self.containerView.frame.maxY
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowAction), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideAction), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        verticalCons.constant = originalTopDistance
        NotificationCenter.default.removeObserver(self)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension SignInViewController {
    static private var distance: CGFloat = 0
    @objc fileprivate func keyboardWillShowAction(noti: Notification) {
        guard let userInfo = noti.userInfo, let keyboardSize = userInfo[UIKeyboardFrameBeginUserInfoKey] as? CGRect else { return }
        let keyboardHeight = keyboardSize.height
        UIView.animate(withDuration: 0.25) {
            self.verticalCons.constant = self.originalTopDistance
            self.verticalCons.constant = self.originalTopDistance - (keyboardHeight - self.maxYContainerView)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc fileprivate func keyboardWillHideAction() {
        UIView.animate(withDuration: 0.25) {
            self.verticalCons.constant = self.originalTopDistance
            self.view.layoutIfNeeded()
        }
    }
    
    fileprivate  func showRiderVC() {
        self.performSegue(withIdentifier: "RiderHome", sender: nil)
    }
}

