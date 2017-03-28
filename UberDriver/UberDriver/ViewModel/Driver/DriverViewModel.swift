//
//  DriverViewModel.swift
//  UberDriver
//
//  Created by lieon on 2017/3/24.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DriverViewModel {
    static var driverAccount: String = ""
    var rider: String = ""
    var driverID: String = ""
    var riderCancleAction: (() -> Void)?
    var driverCancleAction: (() -> Void)?
    func observeMessageForDriver(hasRiderAction: ((_ latitude: Double, _ longitude: Double) -> Void)?) {
        DBProvider.shared.requestRef.observe(.childAdded) { (snapshot, _) in
            if let data = snapshot.value as? [String: Any], let latitude = data[Constants.latitude] as? Double,  let longitude = data[Constants.longtitude] as? Double, let name = data[Constants.name] as? String {
                hasRiderAction?(latitude, longitude)
                self.rider = name
            }
        }
        
        DBProvider.shared.requestRef.observe(.childRemoved) { (snapshot, _) in
            if let data = snapshot.value as? [String: Any], let name = data[Constants.name] as? String {
                if self.rider == name {
                    self.rider = ""
                    self.riderCancleAction?()
                }
            }
        }
        
        DBProvider.shared.requestAcceptedRef.observe(.childAdded, with: { snapshot in
            if let data = snapshot.value as? [String: Any], let name = data[Constants.name] as? String {
                if name == DriverViewModel.driverAccount {
                    self.driverID = snapshot.key
                }
            }
        })
        DBProvider.shared.requestAcceptedRef.observe(.childRemoved, with: { snapshot in
            if let data = snapshot.value as? [String: Any], let name = data[Constants.name] as? String {
                if name == DriverViewModel.driverAccount {
                    self.driverCancleAction?()
                }
            }
        })
    }

    func acceptUber(lati: Double, long: Double) {
        let data: [String: Any] = [Constants.name: DriverViewModel.driverAccount,
                                   Constants.latitude: lati,
                                    Constants.longtitude: long]
        DBProvider.shared.requestAcceptedRef.childByAutoId().setValue(data)
    
    }
    
    func cancleUberForDriver() {
        DBProvider.shared.requestAcceptedRef.child(driverID).removeValue()
    }
    
    func updateDriverLocation(lati: Double, long: Double) {
        DBProvider.shared.requestAcceptedRef.child(driverID).updateChildValues([Constants.latitude: lati, Constants.longtitude: long])
    }
    
    func updateRiderLocation(action: @escaping (_ lati: Double, _ long: Double) -> Void) {
        DBProvider.shared.requestRef.observe(.childChanged, with: { snapshot in
            if let data = snapshot.value as? [String: Any], let lati = data[Constants.latitude] as? Double, let long = data[Constants.longtitude] as? Double {
                action(lati, long)
            }
        })
    }
}
