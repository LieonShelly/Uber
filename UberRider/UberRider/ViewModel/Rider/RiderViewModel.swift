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
    
    func requestUber(latitude: Double, longitude: Double) {
        let data: [String: Any] = [Constants.name: RiderViewModel.riderAccount,
                                   Constants.latitude: latitude,
                                   Constants.longtitude: longitude]
        DBProvider.shared.requestRef.childByAutoId().setValue(data)
    }
}
