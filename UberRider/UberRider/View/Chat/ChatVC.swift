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
import Kingfisher

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
        chatVM.sendMessage(senderID: senderId, senderName: senderDisplayName, text: text)
        finishSendingMessage()
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        let message = messages[indexPath.item]
        if message.senderId == self.senderId {
            return bubbleFactory?.outgoingMessagesBubbleImage(with: UIColor.blue)
        } else {
            return bubbleFactory?.incomingMessagesBubbleImage(with: UIColor.blue)
        }
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
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage, let imageData = UIImageJPEGRepresentation(image, 0.01), let imageMedia = JSQPhotoMediaItem(image: image) {
            messages.append(JSQMessage(senderId: senderId, displayName: senderDisplayName, media: imageMedia))
            chatVM.sendMediaMessage(senderID: senderId, senderName: senderDisplayName, image: imageData, video: nil)
        }
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL, let video = JSQVideoMediaItem(fileURL: videoUrl, isReadyToPlay: true){
            messages.append(JSQMessage(senderId: self.senderId, displayName: self.senderDisplayName, media: video))
            chatVM.sendMediaMessage(senderID: senderId, senderName: senderDisplayName, image: nil, video: videoUrl)
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
        chatVM.observeTextMessage { message in
            guard let senderID = message[Constants.senderID] as? String, let senderDisplayName = message[Constants.senderName] as? String, let text = message[Constants.text] as? String else { return }
            if senderID != self.senderId || senderID != self.tofriendID {
                return
            }
           self.messages.append(JSQMessage(senderId: senderID, displayName: senderDisplayName, text: text))
            self.collectionView.reloadData()
        }
        chatVM.oberserMediaMessage { message in
            guard let senderID = message[Constants.senderID] as? String, let senderDisplayName = message[Constants.senderName] as? String, let urlStr = message[Constants.URL] as? String, let url = URL(string: urlStr) else { return }
            if senderID != self.senderId || senderID != self.tofriendID {
                return
            }
            KingfisherManager.shared.downloader.downloadImage(with: url, options: nil, progressBlock: nil, completionHandler: { (image, error, _, _) in
                if let image = image, let message = JSQMessage(senderId: senderID, displayName: senderDisplayName, media: JSQPhotoMediaItem(image: image)) {
                    self.messages.append(message)
                } else {
                    guard let video = JSQVideoMediaItem(fileURL: url, isReadyToPlay: true), let message = JSQMessage(senderId: senderID, displayName: senderDisplayName, media: video) else { return }
                    self.messages.append(message)
                }
                self.collectionView.reloadData()
            })
        }
    }
}

