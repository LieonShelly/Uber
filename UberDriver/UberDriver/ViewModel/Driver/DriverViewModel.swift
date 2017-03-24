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
    var driver: String = ""
    var driverID: String = ""
    
    func observeMessageForDriver() {
        DBProvider.shared.requestRef.observe(.childAdded) { (snapshot, _) in
            if let data = snapshot.value as? [String: Any], let latitude = data[Constants.latitude] as? Double,  let longitude = data[Constants.latitude] as? Double {
                
            }
        }
    }

}
