//
//  SettingsViewController.swift
//  chat
//
//  Created by chris on 1/24/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()
                
        fullName.text = "My name: \(user.name)"
        phoneNumber.text = "My number is: \(user.phoneNumber)"
        self.view.backgroundColor = UIColor(red:0.44, green:0.82, blue:0.82, alpha:1.0)
    }
    
    @IBAction func backButton(_ sender: Any) {
        //move to navigation viewcontroller
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view = storyboard.instantiateViewController(withIdentifier: "navigationViewController") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = view
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
