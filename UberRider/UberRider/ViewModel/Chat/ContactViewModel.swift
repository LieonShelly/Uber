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
        contacts.forEach({ (key: String, value: Any) in
            guard let value = value as? [String: Any], let model = Mapper<Contact>().map(JSON: value) else { return  }
            self.contacts.append(model)
        })
        finishCallback()
        })
    }
    
    func addConact(email: String) {
        var data: [String: Any] = [String: Any]()
        data[Constants.email] = email
        DBProvider.shared.usersRef.observeSingleEvent(of: .value, with: { snapshot in
            if  let users = snapshot.value as? [String: Any] {
            users.forEach { userSnapshot in
                guard let userJson = userSnapshot.value as? [String: Any] else { return }
                if let userData = userJson[Constants.data] as? [String: Any], let userEmail = userData[Constants.email] as? String {
                    if userEmail == email {
                        let id = userSnapshot.key
                        data[Constants.id] = id
                        DBProvider.shared.usersRef.child(UserInfo.shared.uid).child(Constants.data).child(Constants.contacts).childByAutoId().setValue(data)
                    }
                 }
                }
            }
        })
 
    }
}
