//
//  MessageStructures.swift
//  FirebaseChat
//
//  Created by 송 종근 on 16/01/2020.
//  Copyright © 2020 송 종근. All rights reserved.
//


import Firebase
import MessageKit
import FirebaseFirestore

class Image: MediaItem {
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    init(url: URL) {
        self.url = url
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            }
        }
    }
    
    init(image: UIImage) {
        self.image = image
        self.size = CGSize(width: 240, height: 240)
        self.placeholderImage = UIImage()
    }
}
struct Message: MessageType {
    
    
    let id: String?
    let content: String
    let sentDate: Date
    let sender: SenderType
    
    var kind: MessageKind {
        if let image = image {
            return .photo(Image(image: image))
        } else {
            return .text(content)
        }
    }
    
    var messageId: String {
        return id ?? UUID().uuidString
    }
    
    var image: UIImage? = nil
    var downloadURL: URL? = nil
    
    init(user: User, content: String) {
        sender = Sender(id: user.uid, displayName: user.displayName ?? "Anonymous")
        self.content = content
        sentDate = Date()
        id = nil
        
    }
    
    init(user: User, image: UIImage) {
        sender = Sender(id: user.uid, displayName: user.displayName ?? "Anonymous")
        self.image = image
        content = ""
        sentDate = Date()
        id = nil
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let sentDate = (data["created"] as? Timestamp)?.dateValue() else {
            return nil
        }
        guard let senderID = data["senderID"] as? String else {
            return nil
        }
        guard let senderName = data["senderName"] as? String else {
            return nil
        }
        
        id = document.documentID
        
        self.sentDate = sentDate
        sender = Sender(id: senderID, displayName: senderName)
        
        if let content = data["content"] as? String {
            self.content = content
            downloadURL = nil
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
            content = ""
        } else {
            return nil
        }
    }
    
}

extension Message: DatabaseRepresentation {
    
    var representation: [String : Any] {
        var rep: [String : Any] = [
            "created": sentDate,
            "senderID": sender.senderId,
            "senderName": sender.displayName
        ]
        
        if let url = downloadURL {
            rep["url"] = url.absoluteString
        } else {
            rep["content"] = content
        }
        
        return rep
    }
    
}

extension Message: Comparable {
    
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
    
}


