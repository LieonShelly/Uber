//
//  SignInViewModel.swift
//  UberRider
//
//  Created by lieon on 2017/3/22.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import Firebase

class SignInViewModel {
    func login(with email: String, password: String, completion: @escaping (_ msg: String?) -> Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
              return  self.handle(error: error as? NSError, completion: completion)
            }
            return completion(nil)
        })
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
