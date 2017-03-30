//
//  AuthViewModel.swift
//  UberRider
//
//  Created by lieon on 2017/3/23.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import Firebase

class AuthViewModel {
    func login(with email: String, password: String, completion: @escaping (_ msg: String?) -> Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                return  self.handle(error: error as NSError?, completion: completion)
            }
            return completion(nil)
        })
    }
    
    func signup(with email: String, password: String, completion: @escaping (_ msg: String? ) -> Void)  {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                return  self.handle(error: error as NSError?, completion: completion)
            }
            if let uid = user?.uid, !uid.isEmpty {
                 DBProvider.shared.saveUser(ID: uid, email: email, password: password)
                self.login(with: email, password: password, completion: completion)
            }
        })
    }
    
    var isLogout: Bool {
        if FIRAuth.auth()?.currentUser != nil {
            do {
                try FIRAuth.auth()?.signOut()
                return true
            } catch {
                return false
            }
        }
        return true
    }
    
    private func handle(error: NSError?, completion: (_ msg: String) -> Void) {
        if let error = error, let errCode = FIRAuthErrorCode(rawValue: error.code) {
            switch errCode {
            case .errorCodeWrongPassword:
                completion(LoginErrorCode.wrongPassword)
            case .errorCodeWeakPassword:
                completion(LoginErrorCode.weakPassword)
            case .errorCodeInvalidEmail:
                completion(LoginErrorCode.invalidEmail)
            case .errorCodeUserNotFound:
                completion(LoginErrorCode.userNotFound)
            case .errorCodeEmailAlreadyInUse:
                completion(LoginErrorCode.emailReadyInUse)
            default:
                completion(LoginErrorCode.connectProlem)
            }
        }
        
    }

}
