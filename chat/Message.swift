//
//  Message.swift
//  chat
//
//  Created by chris on 1/24/19.
//  Copyright © 2019 com. All rights reserved.
//

import Foundation
import UIKit
import MessageKit

struct User{
    let name: String
    let phoneNumber:String
}

struct Messages{
    let user: User
    let text: String
    let messageId: String
}

extension Messages: MessageType {
    
    var sender: Sender {
        return Sender(id: user.name, displayName: user.name)
    }
    
    var sentDate: Date {
        return Date()
    }
    
    var kind: MessageKind {
        return .text(text)
    }
}
