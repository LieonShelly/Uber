//
//  DBProvider.swift
//  UberRider
//
//  Created by lieon on 2017/3/24.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBProvider {
    private static let _intance = DBProvider()
    static var shared: DBProvider {
        return _intance
    }
    var dbRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    var driverRef: FIRDatabaseReference {
        return dbRef.child(Constants.driver)
    }
    
    var requestRef: FIRDatabaseReference {
        return dbRef.child(Constants.uberRequest)
    }
    var requestAcceptedRef: FIRDatabaseReference {
        return dbRef.child(Constants.uberAccepted)
    }
    
    func saveUser(ID: String, email: String, password: String) {
        let data: [String: Any] = [Constants.email: email,
                                   Constants.password: password,
                                   Constants.isRider: false]
        driverRef.child(ID).child(Constants.data).setValue(data)
    }
}
