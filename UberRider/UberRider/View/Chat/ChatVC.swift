//
//  ChatVC.swift
//  UberRider
//
//  Created by lieon on 2017/4/1.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatVC: JSQMessagesViewController {
    
    fileprivate lazy var messages: [JSQMessage] =  [JSQMessage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  super.collectionView(collectionView, cellForItemAt: indexPath) as? JSQMessagesCollectionViewCell else { return UICollectionViewCell() }
        return cell
    }

    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
}


