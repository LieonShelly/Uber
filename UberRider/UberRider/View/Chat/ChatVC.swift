//
//  ChatVC.swift
//  UberRider
//
//  Created by lieon on 2017/4/1.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import MobileCoreServices
import AVKit

class ChatVC: JSQMessagesViewController {
    var tofriendName: String?
    var tofriendID: String?
    fileprivate var chatVM: ChatViewModel = ChatViewModel()
    fileprivate lazy var messages: [JSQMessage] =  [JSQMessage]()
    fileprivate  var picker: UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
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
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        if let toid = tofriendID, let toname = tofriendName {
            chatVM.sendMessage(senderID: senderId, senderName: senderDisplayName, toFrend: toname, friendID: toid, text: text)
        }
        finishSendingMessage()
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.blue)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(with: UIImage(named: "sender_Icon"), diameter: 30)
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        let actionsheetVC = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let imageAction = UIAlertAction(title: "Photo", style: .default) { _ in
            self.openMedia(mediaType: kUTTypeImage)
        }
        let carmeraAction = UIAlertAction(title: "Carmera", style: .default) { _ in
            self.openMedia(mediaType: kUTTypeVideo)
        }
        let cancleAction = UIAlertAction(title: "Cancle", style: .cancel, handler: nil)
        actionsheetVC.addAction(imageAction)
        actionsheetVC.addAction(carmeraAction)
        actionsheetVC.addAction(cancleAction)
        present(actionsheetVC, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, didTapMessageBubbleAt indexPath: IndexPath!) {
        let message = messages[indexPath.item]
        if message.isMediaMessage, let videoMedia = message.media as? JSQVideoMediaItem {
            let playerVC = AVPlayerViewController()
            playerVC.player = AVPlayer(url: videoMedia.fileURL)
            present(playerVC, animated: true, completion: nil)
        }
    }
    
    private func openMedia(mediaType: CFString) {
        picker.sourceType = .photoLibrary
         guard let type = UIImagePickerController.availableMediaTypes(for: .photoLibrary) else { return  }
        picker.mediaTypes = type
        present(picker, animated: true, completion: nil)
    }
}

extension ChatVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage, let img = JSQPhotoMediaItem(image: image){
            messages.append(JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: img))
        }
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL, let video = JSQVideoMediaItem(fileURL: videoUrl, isReadyToPlay: true){
            messages.append(JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: video))
        }
        picker.dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
}

extension ChatVC {
    fileprivate  func setupUI() {
        picker.delegate = self
        senderId = UserInfo.shared.uid
        senderDisplayName = UserInfo.shared.userName
    }
    
    fileprivate  func loadData() {
        chatVM.observeTextMessage(senderID: senderId) { message in
            guard let senderID = message[Constants.senderID] as? String, let senderDisplayName = message[Constants.senderName] as? String, let toFriendName = message[Constants.toName] as? String, let toID = message[Constants.toID] as? String, let text = message[Constants.text] as? String else { return }
            if self.senderId == senderID {
                self.messages.append(JSQMessage(senderId: self.senderId, displayName: senderDisplayName, text: text))
            } else {
                self.messages.append(JSQMessage(senderId: toID, displayName: toFriendName, text: text))
            }
            self.collectionView.reloadData()
        }
    }
}

