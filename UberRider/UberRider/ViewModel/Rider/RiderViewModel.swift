//
//  RiderViewModel.swift
//  UberRider
//
//  Created by lieon on 2017/3/24.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import FirebaseDatabase

class RiderViewModel {
   static var riderAccount: String = ""
    var driver: String = ""
    var riderID: String = ""
    var driverAcceptAction: ((_ accepted: Bool, _ driverName: String) -> Void)?
    
    func oberveMessageForRider(handler: @escaping (_ flag: Bool) -> Void)  {
        DBProvider.shared.requestRef.observe(FIRDataEventType.childAdded, with: { snapshot in
            if let data = snapshot.value as? [String: Any], let name = data[Constants.name] as? String {
                if name == RiderViewModel.riderAccount {
                    self.riderID = snapshot.key
                    print("riderID is: \(self.riderID )")
                    handler(true)
                }
            }
        })
        
        DBProvider.shared.requestRef.observe(FIRDataEventType.childRemoved, with: { snapshot in
            if let data = snapshot.value as? [String: Any], let name = data[Constants.name] as? String {
                if name == RiderViewModel.riderAccount {
                    handler(false)
                }
            }
        })
        
        DBProvider.shared.requestAcceptedRef.observe(.childAdded, with: { snapshot in
            if let data = snapshot.value as? [String: Any], let name = data[Constants.name] as? String {
                if self.driver.isEmpty {
                    self.driver = name
                    self.driverAcceptAction?(true, self.driver)
                } else {
                    self.driverAcceptAction?(false, self.driver)
                }
            }
        })
        
        DBProvider.shared.requestAcceptedRef.observe(.childRemoved, with: { snapshot in
            if let data = snapshot.value as? [String: Any], let name = data[Constants.name] as? String {
                if name == self.driver {
                    self.driver = ""
                    self.driverAcceptAction?(false, name)
                }
            }
        })
    }
    
    func requestUber(latitude: Double, longitude: Double) {
        let data: [String: Any] = [Constants.name: RiderViewModel.riderAccount,
                                   Constants.latitude: latitude,
                                   Constants.longtitude: longitude]
        DBProvider.shared.requestRef.childByAutoId().setValue(data)
    }
    
    func cancleUber() {
        DBProvider.shared.requestRef.child(riderID).removeValue()
    }
    
    func updateDriverLocation(driverUpdateLocationAction: ((_ lati: Double, _ long: Double) -> Void)?){
        DBProvider.shared.requestAcceptedRef.observe(.childChanged, with: { snapshot in
            if let data = snapshot.value as? [String: Any], let name = data[Constants.name] as? String {
                if name == self.driver {
                    if let lati = data[Constants.latitude] as? Double, let long = data[Constants.longtitude] as? Double {
                        driverUpdateLocationAction?(lati, long)
                    }
                }
            }
        })
    }
    
    func updateRiderLocation(lati: Double, long: Double) {
        DBProvider.shared.requestRef.child(riderID).updateChildValues([Constants.latitude : lati, Constants.longtitude: long])
    }
}
