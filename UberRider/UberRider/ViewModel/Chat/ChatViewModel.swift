//
//  ChatViewModel.swift
//  UberRider
//
//  Created by lieon on 2017/4/4.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ChatViewModel {
    func sendMessage(senderID: String, senderName: String, toFrend friendName: String, friendID: String, text: String) {
        let message: [String: Any] = [Constants.senderID: senderID,
                                    Constants.senderName: senderName,
                                    Constants.toName: friendName,
                                    Constants.toID: friendID,
                                    Constants.text: text]
        DBProvider.shared.messageRef.child(senderID).childByAutoId().setValue(message)
    }
    
    func observeTextMessage(senderID: String, callback: @escaping (_ message: [String: Any]) -> Void) {
        DBProvider.shared.messageRef.child(senderID).observe(.childAdded, with: {snapshot in
            if let message = snapshot.value as? [String: Any] {
                callback(message)
            }
        })
    }
}
