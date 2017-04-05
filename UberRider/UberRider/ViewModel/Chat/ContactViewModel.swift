//
//  ContactViewModel.swift
//  UberRider
//
//  Created by lieon on 2017/3/31.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import ObjectMapper

class ContactViewModel {
    var currentUserID: String = ""
    lazy var contacts: [Contact] =  [Contact]()
    func getContacts(finishCallback: @escaping () -> Void) {
    DBProvider.shared.usersRef.child(UserInfo.shared.uid).child(Constants.data).child(Constants.contacts).observe(.value, with: { snapshot in
        guard let contacts = snapshot.value as? [String: Any] else { return  }
        self.contacts.removeAll()
        contacts.forEach({ (key: String, value: Any) in
            guard let value = value as? [String: Any], let model = Mapper<Contact>().map(JSON: value) else { return  }
            self.contacts.append(model)
        })
        finishCallback()
        })
    }
    
    func addConact(email: String, callback: @escaping (_ message: String) -> Void) {
        var data: [String: Any] = [String: Any]()
        if !email.isValidEmail() {
            callback("Please enter a valid email")
            return
        }
        let group = DispatchGroup()
        group.enter()
        var isSame = false
    DBProvider.shared.usersRef.child(UserInfo.shared.uid).child(Constants.data).observeSingleEvent(of: .value, with: { snapshot in
            guard let dataJson = snapshot.value as? [String: Any] else { return }
            if let contactsJson = dataJson[Constants.contacts] as? [String: Any] {
                for (_, value) in contactsJson {
                    if let value = value as? [String: String], let friendEmail = value[Constants.email], email == friendEmail {
                        isSame = true
                        break
                    }
                }
            }
            group.leave()
            if isSame {
               callback("repeat add")
            }
        })
        group.notify(queue: .main) {
        if isSame {
            return
        }
        data[Constants.email] = email
        var emailArray: [String] = [String]()
        DBProvider.shared.usersRef.observeSingleEvent(of: .value, with: { snapshot in
            guard let users = snapshot.value as? [String: Any] else { return }
        
            for (key, _) in users {
                 group.enter()
                DBProvider.shared.usersRef.child(key).child(Constants.data).child(Constants.email).observe(.value, with: { dataSnapshot in
                    if let value = dataSnapshot.value as? String {
                        emailArray.append(value)
                    } else {
                        callback("do not get it")
                    }
                    group.leave()
                })
            }
            group.notify(queue: DispatchQueue.main, execute: { 
                if !emailArray.contains(email) {
                    callback("fail:\(email) do not exist")
                } else {
                    DBProvider.shared.usersRef.observeSingleEvent(of: .value, with: {
                        snapshot in
                        guard let users = snapshot.value as? [String: Any] else { return }
                        for (key, value) in users {
                            if let value = value as? [String: Any], let dataJson = value[Constants.data] as? [String: Any], let currentEmail = dataJson[Constants.email] as? String {
                                if currentEmail == email {
                                    data[Constants.id] = key
                                    DBProvider.shared.usersRef.child(UserInfo.shared.uid).child(Constants.data).child(Constants.contacts).childByAutoId().setValue(data, withCompletionBlock: { (error, _) in
                                        if let error = error {
                                            callback("The email:\(email) add failedly:\(error.localizedDescription)")
                                        } else {
                                            callback("Add Success")
                                        }
                                    })
                                }
                            }
                        }
                    })
                    
                }
            })
           
     })
        }
    }
}
