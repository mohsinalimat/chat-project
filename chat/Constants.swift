//
//  Constants.swift
//  chat
//
//  Created by chris on 1/24/19.
//  Copyright © 2019 com. All rights reserved.
//

import Firebase

struct Constants
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databaseChats = databaseRoot.child("chats")
        static let databaseUsers = databaseRoot.child("users")
    }
    
    
}
