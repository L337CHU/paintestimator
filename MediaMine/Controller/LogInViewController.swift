//
//  ViewController.swift
//  MediaMine
//
//  Created by Christopher Chu on 8/29/19.
//  Copyright © 2019 NoOrg. All rights reserved.
//

import UIKit
import Firebase


class LogInViewController: UIViewController {

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        logInButton.layer.cornerRadius = 20.0
        
        
    }
    
    

    @IBAction func loginTapped(_ sender: Any) {
        
        guard let email = userEmail.text, let password = userPassword.text else{
                print("user entry error")
            return
        }
        //check if fields are empty
        if email.isEmpty || password.isEmpty {
            self.displayAlert(msg: "Complete empty fields")
        
        }
        //sign in
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            
            if error != nil{
                print("test")
                if let errorCode = AuthErrorCode(rawValue: error!._code){
                    switch errorCode{
                    
                    case .userNotFound:
                        self.displayAlert(msg: "Account not found for the specified user. Please check and try again.")
                    case .userDisabled:
                        self.displayAlert(msg: "Your account has been disabled. Please contact support.")
                    case .invalidEmail, .invalidSender, .invalidRecipientEmail:
                        self.displayAlert(msg: "Please enter a valid email.")
                    case .networkError:
                        self.displayAlert(msg:"Network error. Please try again.")
                    case .wrongPassword:
                        self.displayAlert(msg: "Your password is incorrect. Please try again.")
                    default:
                        self.displayAlert(msg: "Unknown error occurred")
                    }
                }
            }
            else{
                print("success")
                self.performSegue(withIdentifier: "goToCalc", sender: self)
            }
        }

    }
    
    @IBAction func leftButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - uialerts
    func displayAlert(msg: String){
        let alert = UIAlertController(title: "Hey Look", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}




