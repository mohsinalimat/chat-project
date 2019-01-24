//
//  loginViewController.swift
//  chat
//
//  Created by chris on 1/23/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import AccountKit

class loginViewController: UIViewController, AKFViewControllerDelegate {
    
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var signup: UIButton!
    
    var accountKit: AKFAccountKit!

    override func viewDidLoad() {
        super.viewDidLoad()

        if(accountKit == nil){
            self.accountKit = AKFAccountKit(responseType: .authorizationCode)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if(accountKit.currentAccessToken != nil){
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "showMain", sender: self)
            })
        }
    }
    
    func prepareLoginViewController(_ LoginViewController: AKFViewController){
        LoginViewController.delegate = self
        LoginViewController.setAdvancedUIManager(nil)
        
        //theme customizations
        let theme = AKFTheme.default()
        theme.headerBackgroundColor = UIColor(red:0.54, green:0.76, blue:0.93, alpha:1.0)
        theme.headerTextColor = UIColor.white
        theme.iconColor = UIColor.black
        theme.inputTextColor = UIColor.black
        theme.statusBarStyle = .lightContent
        theme.textColor = UIColor.lightGray
        theme.titleColor = UIColor.lightGray
        LoginViewController.setTheme(theme)
    }
    
    /*func viewController(viewController: UIViewController!, didCompleteLoginWithAccessToken accessToken: AKFAccessToken!, state: String!) {
        print("AAAAAAAAAAAAAAAAAAAAAAAAAAA")
    }
    */
    func viewController(_ viewController: (UIViewController & AKFViewController)!, didCompleteLoginWithAuthorizationCode code: String!, state: String!) {
        self.performSegue(withIdentifier: "showUsername", sender: self)
    }
    
    @IBAction func login(_ sender: Any) {
        
    }
    
    @IBAction func signup(_ sender: Any) {
        let inputState = UUID().uuidString
        let viewController = accountKit.viewControllerForPhoneLogin(with: nil, state: inputState) as AKFViewController
        viewController.enableSendToFacebook = true
        self.prepareLoginViewController(viewController)
        self.present(viewController as! UIViewController, animated: true, completion: nil)
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
