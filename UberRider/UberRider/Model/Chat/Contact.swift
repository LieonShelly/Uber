//
//  Contact.swift
//  UberRider
//
//  Created by lieon on 2017/3/31.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

class Contact: Model {
    var name: String?
    var id: String?
    
    override func mapping(map: Map) {
        name <- map[Constants.email]
        id <- map
    }
}
