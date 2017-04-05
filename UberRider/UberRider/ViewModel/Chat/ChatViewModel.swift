//
//  ChatViewModel.swift
//  UberRider
//
//  Created by lieon on 2017/4/4.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class ChatViewModel {
    func sendMessage(senderID: String, senderName: String, text: String) {
        let message: [String: Any] = [Constants.senderID: senderID,
                                    Constants.senderName: senderName,
                                    Constants.text: text]
        DBProvider.shared.messageRef.childByAutoId().setValue(message)
    }
    
    func sendMediaMessage(senderID: String, senderName: String, image: Data?, video: URL?) {
        if let imageData = image {
            DBProvider.shared.imgaeStorageRef.put(imageData, metadata: nil, completion: { (metaData: FIRStorageMetadata?, error: Error?) in
                if let error = error {
                    print("upload image failed:\(error.localizedDescription)")
                    return
                }
                if let metaData = metaData, let downloadURL = metaData.downloadURL() {
                    let data: [String: Any] = [Constants.senderID: senderID, Constants.senderName: senderName, Constants.URL: String(describing: downloadURL)]
                    DBProvider.shared.mediaMessageRef.childByAutoId().setValue(data)
                }
             })
        }
        if let video = video {
            DBProvider.shared.videoStorageRef.putFile(video, metadata: nil, completion: { (metaData: FIRStorageMetadata?, error: Error?) in
                if let error = error {
                    print("upload video failed:\(error.localizedDescription)")
                    return
                }
                if let metaData = metaData, let downloadURL = metaData.downloadURL() {
                    let data: [String: Any] = [Constants.senderID: senderID, Constants.senderName: senderName, Constants.URL: "\(String(describing: downloadURL))"]
                    DBProvider.shared.mediaMessageRef.childByAutoId().setValue(data)
                }
            })
        }
    }
    
    func observeTextMessage(callback: @escaping (_ message: [String: Any]) -> Void) {
        DBProvider.shared.messageRef.observe(.childAdded, with: {snapshot in
            if let message = snapshot.value as? [String: Any] {
                callback(message)
            }
        })
    }
    
    func oberserMediaMessage(callback: @escaping(_ message: [String: Any]) -> Void) {
        DBProvider.shared.mediaMessageRef.observe(.childAdded, with: { snapshot in
            if let message = snapshot.value as? [String: Any] {
                callback(message)
            }
        })
    }
}
