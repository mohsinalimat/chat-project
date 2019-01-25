//
//  loginViewController.swift
//  chat
//
//  Created by chris on 1/23/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import AccountKit

class SignUpViewController: UIViewController, AKFViewControllerDelegate {
    
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var signup: UIButton!
    
    var accountKit: AKFAccountKit!
    var loginOrSignUp = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        if(accountKit == nil){
            self.accountKit = AKFAccountKit(responseType:.accessToken)
        }
        
        //ui design
        login.backgroundColor = UIColor(red:0.96, green:0.72, blue:0.74, alpha:1.0)
        signup.backgroundColor = UIColor(red:0.96, green:0.72, blue:0.74, alpha:1.0)
        self.view.backgroundColor = UIColor(red:0.44, green:0.82, blue:0.82, alpha:1.0)
        
        //delete navigation bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func prepareLoginViewController(_ loginViewController: AKFViewController){
        loginViewController.delegate = self
        loginViewController.setAdvancedUIManager(nil)
        
        //theme customizations
        let theme = AKFTheme.default()
        theme.headerBackgroundColor = UIColor(red:0.54, green:0.76, blue:0.93, alpha:1.0)
        theme.headerTextColor = UIColor.white
        theme.iconColor = UIColor.black
        theme.inputTextColor = UIColor.black
        theme.statusBarStyle = .lightContent
        theme.textColor = UIColor.lightGray
        theme.titleColor = UIColor.lightGray
        loginViewController.setTheme(theme)
    }
    
    //login button function
    @IBAction func login(_ sender: Any) {
        loginOrSignUp = "login"
        
        
        //present phone authentication view
        let inputState = UUID().uuidString
        let viewController = accountKit.viewControllerForPhoneLogin(with: nil, state: inputState) as AKFViewController
        viewController.enableSendToFacebook = true
        self.prepareLoginViewController(viewController)
        self.present(viewController as! UIViewController, animated: true, completion: nil)
    }
    
    //signup button function
    @IBAction func signup(_ sender: Any) {
        loginOrSignUp = "signup"
        
        //present phone authentication view
        let inputState = UUID().uuidString
        let viewController = accountKit.viewControllerForPhoneLogin(with: nil, state: inputState) as AKFViewController
        viewController.enableSendToFacebook = true
        self.prepareLoginViewController(viewController)
        self.present(viewController as! UIViewController, animated: true, completion: nil)
    }
    
    //handle successful login
    func viewController(_ viewController: (UIViewController & AKFViewController)!,
                        didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        if(loginOrSignUp == "login"){
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "navigationViewController") as! UINavigationController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //show window
            appDelegate.window?.rootViewController = view
        }else{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "usernameViewController") as UIViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //show window
            appDelegate.window?.rootViewController = view
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
