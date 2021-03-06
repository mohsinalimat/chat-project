//
//  ViewController.swift
//  chat
//
//  Created by chris on 1/23/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import AccountKit
import MessageKit
import MessageInputBar

class ChatViewController: MessagesViewController{
    
    var accountKit: AKFAccountKit!
    var messages: [Messages] = []
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.user = User(name: globalVar.fullName, phoneNumber: globalVar.number)
        
        if(accountKit == nil){
            self.accountKit = AKFAccountKit(responseType: .accessToken)
        }
        
        //delete avatar view
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.setMessageIncomingAvatarSize(.zero)
            layout.setMessageOutgoingAvatarSize(.zero)
        }

        //get last 1000 messages and load those messages
        let query = Constants.refs.databaseChats.queryLimited(toLast: 1000)
        
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            
            if  let data = snapshot.value as? [String: String],
                let name = data["name"],
                let phoneNum = data["phone_number"],
                let text = data["text"],
                let id = data["message_id"],
                !text.isEmpty
            {
                //let newMessage = Message(user: user, text:text, messageId: UUID().uuidString)
                let newUser = User(name: name, phoneNumber: phoneNum)
                let newMessage = Messages(user: newUser, text:text, messageId:id)
                self?.insertNewMessage(newMessage)
            }
        })
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
    }
    
    func insertNewMessage(_ message: Messages) {
        messages.append(message)
        messagesCollectionView.reloadData()
    }
    
    //pass the user data to SettingsViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsSegue" {
            let settingsViewController = segue.destination as! SettingsViewController
            settingsViewController.user = self.user
        }
    }

    //logout
    @IBAction func signout(_ sender: Any) {
        accountKit.logOut()
    }
}


//customize message and inputbar
extension ChatViewController: MessagesDataSource {
    func numberOfSections(
        in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> Sender {
        return Sender(id: user.name, displayName: user.name)
    }
    
    func messageForItem(
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    func messageTopLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 15
    }
    
    func messageTopLabelAttributedText(
        for message: MessageType,
        at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(
            string: message.sender.displayName,
            attributes: [.font: UIFont.systemFont(ofSize: 10)])
    }
}

extension ChatViewController: MessagesLayoutDelegate {
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
}

extension ChatViewController: MessagesDisplayDelegate {
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
}

extension ChatViewController: MessageInputBarDelegate {
    func messageInputBar(
        _ inputBar: MessageInputBar,
        didPressSendButtonWith text: String) {
                
        inputBar.inputTextView.text = ""
        messagesCollectionView.scrollToBottom(animated: true)
        
        let ref = Constants.refs.databaseChats.childByAutoId()
        
        let message = ["name": user.name, "phone_number": user.phoneNumber, "text": text, "message_id": UUID().uuidString]

        ref.setValue(message)

    }
}
