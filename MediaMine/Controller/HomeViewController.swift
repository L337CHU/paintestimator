//
//  HomeViewController.swift
//  MediaMine
//
//  Created by Christopher Chu on 9/3/19.
//  Copyright © 2019 NoOrg. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    let myColor : UIColor = UIColor(red: 45/255, green: 64/255, blue: 89/255, alpha: 1)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        logInButton.layer.cornerRadius = 20.0
        signUpButton.layer.cornerRadius = 20.0
        signUpButton.layer.borderColor = myColor.cgColor
        signUpButton.layer.borderWidth = 1
    
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
