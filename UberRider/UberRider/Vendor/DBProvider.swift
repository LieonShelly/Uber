//
//  DBProvider.swift
//  UberRider
//
//  Created by lieon on 2017/3/24.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class DBProvider {
    private static let _intance = DBProvider()
    static var shared: DBProvider {
        return _intance
    }
    var dbRef: FIRDatabaseReference {
        return FIRDatabase.database().reference()
    }
    var usersRef: FIRDatabaseReference {
        return dbRef.child(Constants.user)
    }
    var requestRef: FIRDatabaseReference {
        return dbRef.child(Constants.uberRequest)
    }
    var requestAcceptedRef: FIRDatabaseReference {
        return dbRef.child(Constants.uberAccepted)
    }
    var contactRef: FIRDatabaseReference {
        return  dbRef.child(Constants.contacts)
    }
    var messageRef: FIRDatabaseReference {
        return dbRef.child(Constants.messages)
    }
    var mediaMessageRef: FIRDatabaseReference {
        return dbRef.child(Constants.mediaMessages)
    }
    var storageRef: FIRStorageReference {
        return FIRStorage.storage().reference(forURL: "gs://uber-rider-7dafd.appspot.com")
    }
    var imgaeStorageRef: FIRStorageReference {
        return storageRef.child(Constants.imageMessage)
    }
    var videoStorageRef: FIRStorageReference {
        return storageRef.child(Constants.videoStorage)
    }
    
    func saveUser(ID: String, email: String, password: String) {
        let data: [String: Any] = [Constants.email: email,
                                   Constants.password: password,
                                   Constants.isRider: true]
        usersRef.child(ID).child(Constants.data).setValue(data)
    }
}
