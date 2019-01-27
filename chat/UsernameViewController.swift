//
//  UsernameViewController.swift
//  chat
//
//  Created by chris on 1/24/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import MessageKit
import AccountKit

class UsernameViewController: UIViewController {
    
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var `continue`: UIButton!
    var accountKit: AKFAccountKit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if accountKit == nil {
            //specify AKFResponseType.AccessToken
            self.accountKit = AKFAccountKit(responseType: AKFResponseType.accessToken)
            accountKit.requestAccount {
                (account, error) -> Void in
                if let phoneNumber = account?.phoneNumber{
                    globalVar.number = phoneNumber.stringRepresentation()
                }
            }
        }
        
        `continue`.backgroundColor = UIColor(red:0.96, green:0.72, blue:0.74, alpha:1.0)
        self.view.backgroundColor = UIColor(red:0.44, green:0.82, blue:0.82, alpha:1.0)
    }
    
    //saves full name in global fullname variable
    @IBAction func `continue`(_ sender: Any) {
        globalVar.fullName = fullName.text!
        if((fullName.text?.isEmpty)!){
            let alert = UIAlertController(title: "ERROR", message: "Please enter a name!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            //saving user info to database
            let ref = Constants.refs.databaseUsers.childByAutoId()
            let userData = ["full_name": globalVar.fullName, "phone_number": globalVar.number]
            ref.setValue(userData)
            
        }
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
