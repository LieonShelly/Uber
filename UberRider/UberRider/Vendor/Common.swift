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
    static let user = "user"
    static let email = "email"
    static let password = "passwrod"
    static let data = "data"
    static let isRider = "isRider"
    static let uberRequest = "Uber_Request"
    static let uberAccepted = "Uber_Accepted"
    static let name = "name"
    static let latitude = "latitude"
    static let longtitude = "longtitude"
    static let contacts = "contacts"
    static let messages = "messages"
    static let mediaMessages = "media_messages"
    static let imageMessage = "image_message"
    static let videoStorage = "video_storage"
    /// message
    static let text = "text"
    static let senderID = "sender_id"
    static let senderName = "sender_name"
    static let URL = "url"
    static let id = "id"
}

struct StoryboardName {
    static let main = "Main"
    static let chat = "Chat"
}

struct CellID {
    static let contactCellID = "contactCellID"
}

struct NibName {
    static let contactCell = "ContactCell"
}

class UserInfo: NSObject {
    private static var instance: UserInfo = UserInfo()
    static var shared: UserInfo {
        return instance
    }
    var uid: String = ""
}
