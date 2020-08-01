//
//  ViewController.swift
//  FirebaseChat
//
//  Created by 송 종근 on 15/01/2020.
//  Copyright © 2020 송 종근. All rights reserved.
//

import UIKit
import Photos
import MessageKit
import InputBarAccessoryView
import FirebaseAuth

import FirebaseFirestore // 대화내용 저장
import FirebaseStorage // 파일 저장

class ChatViewController: MessagesViewController {
    private var isSendingPhoto = false {
        didSet {
            DispatchQueue.main.async {
                (self.messageInputBar.leftStackViewItems as! [InputBarButtonItem]).forEach { item in
                    item.isEnabled = !self.isSendingPhoto
                }
            }
        }
    }
    
    var sender:SenderType!
    var messages: [Message] = []
    var user:FirebaseAuth.User!
    
    var channel: Channel!
    
    private let db = Firestore.firestore()
    
    private var channelReference: CollectionReference {
        return db.collection("channels")
    }
    private var reference: CollectionReference?
    private let storage = Storage.storage().reference()
    private var messageListener: ListenerRegistration?
    
    deinit {
        messageListener?.remove()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        maintainPositionOnKeyboardFrameChanged = true
        
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        messageInputBar.inputTextView.tintColor = .primary
        messageInputBar.sendButton.setTitleColor(.primary, for: .normal)
        messageInputBar.delegate = self
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.outgoingMessageBottomLabelAlignment = LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(right: 0))
        }
        
        title = channel.name
        reference = db.collection(["channels", channel.id!, "thread"].joined(separator: "/"))
        user = Auth.auth().currentUser
        sender = Sender(senderId: user.uid, displayName: user.displayName ?? "")
        let cameraItem = InputBarButtonItem(type: .system)
        cameraItem.tintColor = .primary
        cameraItem.image = #imageLiteral(resourceName: "camera")
        
        cameraItem.addTarget(
            self,
            action: #selector(cameraButtonPressed),
            for: .primaryActionTriggered
        )
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
        
        messageListener = reference?.addSnapshotListener { querySnapshot, error in
            NSLog("listener added")
            guard let snapshot = querySnapshot else {
                print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                return
            }
            
            snapshot.documentChanges.forEach { change in
                NSLog("change document")
                self.handleDocumentChange(change)
            }
        }
    }
    
    private func insertNewMessage(_ message: Message) {
        guard !messages.contains(message) else {
            return
        }
        
        messages.append(message)
        messages.sort()
        
        let isLatestMessage = messages.index(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    private func createChannel(_ channelName:String) {
        
        self.channel = Channel(name: channelName)
        
        channelReference.addDocument(data: channel.representation) { error in
            if let e = error {
                print("Error saving channel: \(e.localizedDescription)")
                
            }
        }
    }
}

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(id: user.uid, displayName: user.displayName ?? "Anonymous")
    }
    
    func isFromCurrentSender(message: MessageType) -> Bool {
        return self.user.uid == message.sender.senderId
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
//    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
//        let name = "user name"//message.sender.displayName
//        NSLog("aertasdf")
//        return NSAttributedString(
//            string: name,
//            attributes: [
//                .font: UIFont.preferredFont(forTextStyle: .caption1),
//                .foregroundColor: UIColor(white: 0.3, alpha: 1)
//            ]
//        )
//    }
//    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return UIFont.preferredFont(forTextStyle: .caption1).capHeight
//    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isFromCurrentSender(message: message) {
            return 0
        }
        return UIFont.preferredFont(forTextStyle: .caption1).pointSize * 1.5
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return UIFont.preferredFont(forTextStyle: .caption1).pointSize * 1.5
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let date_formatter = DateFormatter()
        let calendar = Calendar.current
        if calendar.isDateInToday(message.sentDate) {
            date_formatter.dateFormat = "hh:mm a"
        } else {
            date_formatter.dateFormat = "yy-MM-dd hh:mm a"
        }
        let date = date_formatter.string(from: message.sentDate)
        return NSAttributedString(string: date, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    private func save(_ message: Message) {
        
        reference?.addDocument(data: message.representation) { error in
            
            if let e = error {
                print("Error sending message: \(e.localizedDescription)")
                return
            }
            
            self.messagesCollectionView.scrollToBottom()
        }
        
    }
    
    
    private func handleDocumentChange(_ change: DocumentChange) {
        
        guard var message = Message(document: change.document) else {
            return
        }
        
        switch change.type {
        case .added:
            if let url = message.downloadURL {
                downloadImage(at: url) { [weak self] image in
                    guard let `self` = self else {
                        return
                    }
                    guard let image = image else {
                        return
                    }
                    
                    message.image = image
                    self.insertNewMessage(message)
                }
            } else {
                insertNewMessage(message)
            }
            
        default:
            break
        }
    }
}

extension ChatViewController:MessagesLayoutDelegate {
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = isFromCurrentSender(message: message) ? true : false
        
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath,
                        in messagesCollectionView: MessagesCollectionView) -> CGSize {
        
        return CGSize(width: 0, height: 8)
    }
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath,
                           with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
}

extension ChatViewController:MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor.primary : UIColor.incomingMessage
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let corner:MessageStyle.TailCorner = isFromCurrentSender(message: message) ? MessageStyle.TailCorner.bottomRight : MessageStyle.TailCorner.bottomLeft
        switch(message.kind) {
        case .photo(_), .video(_), .location(_), .emoji(_), .audio(_), .contact(_):
            return MessageStyle.bubble
        @unknown default:
            break
        }
        return MessageStyle.bubbleTail(corner, .curved)
    }
}

extension ChatViewController:InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(user: user, content: text)
        save(message)
        inputBar.inputTextView.text = ""
    }
}

extension ChatViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc private func cameraButtonPressed() {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let asset = info[.phAsset] as? PHAsset {
            let size = CGSize(width: 500, height: 500)
            PHImageManager.default().requestImage(
                for: asset,
                targetSize: size,
                contentMode: .aspectFit,
                options: nil) { result, info in
                    
                    guard let image = result else {
                        return
                    }
                    
                    self.sendPhoto(image)
            }
        } else if let image = info[.originalImage] as? UIImage {
            sendPhoto(image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    private func uploadImage(_ image: UIImage, to channel: Channel, completion: @escaping (URL?) -> Void) {
        
        guard let channelID = channel.id else {
            completion(nil)
            return
        }
        
        
        guard let scaledImage = image.scaledToSafeUploadSize, let data = scaledImage.jpegData(compressionQuality: 0.4) else {
            completion(nil)
            return
        }
        
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let imageName = [UUID().uuidString, String(Date().timeIntervalSince1970)].joined()
        let data_ref = storage.child(channelID).child(imageName)
        data_ref.putData(data, metadata: metadata) { meta, error in
            if let error = error {
                NSLog(error.localizedDescription)
            }
            data_ref.downloadURL { (url, error) in
                guard let url = url else {return}
                completion(url)
            }
            
        }
    }
    
    private func sendPhoto(_ image: UIImage) {
        isSendingPhoto = true
        NSLog("photo go")
        uploadImage(image, to: channel) { [weak self] url in
            NSLog("photo1")
            guard let `self` = self else {
                return
            }
            NSLog("photo2")
            self.isSendingPhoto = false
            NSLog("photo3")
            guard let url = url else {
                return
            }
            NSLog("photo4")
            var message = Message(user: self.user, image: image)
            message.downloadURL = url
            NSLog("photo5")
            self.save(message)
            self.messagesCollectionView.scrollToBottom()
        }
    }
    
    private func downloadImage(at url: URL, completion: @escaping (UIImage?) -> Void) {
        let ref = Storage.storage().reference(forURL: url.absoluteString)
        let megaByte = Int64(1 * 1024 * 1024)
        
        ref.getData(maxSize: megaByte) { data, error in
            guard let imageData = data else {
                completion(nil)
                return
            }
            completion(UIImage(data: imageData))
        }
    }
    
}

fileprivate extension UIEdgeInsets {
    init(top: CGFloat = 0, bottom: CGFloat = 0, left: CGFloat = 0, right: CGFloat = 0) {
        self.init(top: top, left: left, bottom: bottom, right: right)
    }
}
