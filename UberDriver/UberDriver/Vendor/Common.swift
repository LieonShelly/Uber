//
//  Common.swift
//  UberRider
//
//  Created by lieon on 2017/3/23.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation

struct LoginErrorCode {
    static let invalidEmail = "invalid email"
    static let wrongPassword = "wrongPassword"
    static let connectProlem = "connectProlem"
    static let userNotFound = "userNotFound"
    static let emailReadyInUse = "emailReadyInUse"
    static let weakPassword = "weakPassword"
}

class Constants {
    static let driver = "driver"
    static let email = "email"
    static let password = "passwrod"
    static let data = "data"
    static let isRider = "isRider"
    static let uberRequest = "Uber_Request"
    static let uberAccepted = "Uber_Accepted"
    static let name = "name"
    static let latitude = "latitude"
    static let longtitude = "longtitude"
}
