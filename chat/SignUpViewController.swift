//
//  loginViewController.swift
//  chat
//
//  Created by chris on 1/23/19.
//  Copyright © 2019 com. All rights reserved.
//

import UIKit
import AccountKit
import FirebaseDatabase

class SignUpViewController: UIViewController, AKFViewControllerDelegate {
    
    @IBOutlet weak var login: UIButton!
    @IBOutlet weak var signup: UIButton!
    
    var accountKit: AKFAccountKit!
    var loginOrSignUp = String()
    var ref: DatabaseReference?
    var loginTest = Int()
    var signupTest = Int()

    override func viewDidLoad() {
        super.viewDidLoad()

        //saving phonenumber to global variable
        if(accountKit == nil){
            self.accountKit = AKFAccountKit(responseType:.accessToken)
            self.accountKit.requestAccount({ (account, error) in
                if let phoneNumber = account?.phoneNumber{
                    globalVar.number = phoneNumber.stringRepresentation()
                }
            })
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //present alertcontroller if login and signup fails
        if(self.loginTest == 1){
            print("ERROR")
            let alert = UIAlertController(title: "ERROR", message: "Please sign up first!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            signupTest = -1
        }
        
        if(signupTest > 1){
            print("ERROR")
            let alert = UIAlertController(title: "ERROR", message: "Phone number already exists!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if(signupTest == 1){
            //move to username viewcontroller
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let view = storyboard.instantiateViewController(withIdentifier: "usernameViewController") as UIViewController
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = view
        }
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
            loginTest = 1
            //check if the phone number exists in the database if so use the name in the database
            ref = Database.database().reference()
            ref?.child("users").observe(.childAdded, with: { (snapshot) in
                if  let data = snapshot.value as? [String: String],
                    let full_name = data["full_name"],
                    let phoneNum = data["phone_number"]
                {
                    
                    self.accountKit = AKFAccountKit(responseType:.accessToken)
                    self.accountKit.requestAccount({ (account, error) in
                        if let phoneNumber = account?.phoneNumber{
                            globalVar.number = phoneNumber.stringRepresentation()
                        }
                    })
                    
                    if(globalVar.number == phoneNum){
                        self.loginTest+=10
                        globalVar.fullName = full_name
                        //move to navigation viewcontroller
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let view = storyboard.instantiateViewController(withIdentifier: "navigationViewController") as! UINavigationController
                        let appDelegate = UIApplication.shared.delegate as! AppDelegate
                        appDelegate.window?.rootViewController = view
                        
                    }
                }
            })
            signupTest = -1
        }else if(loginOrSignUp == "signup"){
            signupTest = 1
            //check if the phone number exists in the database if so use the name in the database
            ref = Database.database().reference()
            ref?.child("users").observe(.childAdded, with: { (snapshot) in
                if  let data = snapshot.value as? [String: String],
                    let phoneNum = data["phone_number"]
                {
                    self.accountKit = AKFAccountKit(responseType:.accessToken)
                    self.accountKit.requestAccount({ (account, error) in
                        if let phoneNumber = account?.phoneNumber{
                            globalVar.number = phoneNumber.stringRepresentation()
                        }
                    })
                    
                    if(globalVar.number == phoneNum){
                       self.signupTest+=10
                    }
                }
            })
            loginTest = -1
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
