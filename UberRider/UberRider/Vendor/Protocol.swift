//
//  Protocol.swift
//  UberRider
//
//  Created by lieon on 2017/3/31.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import UIKit

protocol VCNameReusable { }

protocol ViewNameReusable { }

extension VCNameReusable where Self: UIViewController {
    static  var identifier: String {
        return String(describing: self)
    }
}

extension ViewNameReusable where Self: UIView {
    static  var identifier: String {
        return String(describing: self)
    }
}
