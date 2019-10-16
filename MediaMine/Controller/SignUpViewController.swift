//
//  SignUpViewController.swift
//  MediaMine
//
//  Created by Christopher Chu on 9/3/19.
//  Copyright © 2019 NoOrg. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var userPasswordConfirmation: UITextField!
    @IBOutlet weak var registerAcc: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //round out button for
        registerAcc.layer.cornerRadius = 20.0
    }
    
    // MARK: - Register User
    //Create user with email and password
    @IBAction func createUser(_ sender: Any) {
        //make sure user enters email
        guard let email = userEmail.text else{
            displayAlert(msg: ("Enter Email"))
            return
        }
        //make sure user enters password
        guard let password = userPassword.text else{
            displayAlert(msg: "Enter password")
            return
        }
        guard let passwordTwo = userPasswordConfirmation.text else{
            displayAlert(msg: "Confirm password")
            return
        }
        //password does not match
        if password != passwordTwo{
            displayAlert(msg: ("Passwords do not match"))
        }
        
       
        //register user w/ email and password
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            
            if error != nil{
                
                print("begin")
//                print(errorMsg)
                if let errorCode = AuthErrorCode(rawValue: error!._code){
                    switch errorCode{
                    case .emailAlreadyInUse:
                        self.displayAlert(msg: "This email is already in use")
                    case .userNotFound:
                        self.displayAlert(msg: "Account not found. Please check and try again")
                    case .invalidEmail:
                        self.displayAlert(msg: "Please enter valid email")
                    case .wrongPassword:
                        self.displayAlert(msg: "Wrong password")
                    case .tooManyRequests:
                        self.displayAlert(msg: "Try again later")
                    case .weakPassword:
                        self.displayAlert(msg: "Password is too weak. Password must be 6 characters long or more")
                    default:
                        self.displayAlert(msg: "We're working on it")
                    }
                }
 
                
            }
            else{
                print("success")
                self.performSegue(withIdentifier: "goToCalc", sender: self)
                
                
            }
            
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
    
    
    // MARK: - uialerts
    func displayAlert(msg: String){
        let alert = UIAlertController(title: "Hey Look", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func leftButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
