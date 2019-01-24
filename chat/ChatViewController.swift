//
//  ViewController.swift
//  chat
//
//  Created by chris on 1/23/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import AccountKit
import FirebaseFirestore
import MessageKit

class ChatViewController: MessagesViewController {
    
    var accountKit: AKFAccountKit!

    override func viewDidLoad() {
        super.viewDidLoad()

        if(accountKit == nil){
            self.accountKit = AKFAccountKit(responseType: .accessToken)
        }
    }

    @IBAction func signout(_ sender: Any) {
        accountKit.logOut()
        dismiss(animated: true, completion: nil)
    }
    
}

