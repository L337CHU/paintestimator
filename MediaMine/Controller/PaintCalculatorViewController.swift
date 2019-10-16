//
//  PaintCalculatorViewController.swift
//  MediaMine
//
//  Created by Christopher Chu on 9/11/19.
//  Copyright © 2019 NoOrg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class PaintCalculatorViewController: UIViewController {

    @IBOutlet weak var lengthInput: UITextField!
    @IBOutlet weak var widthInput: UITextField!
    @IBOutlet weak var totalData: UILabel!
    @IBOutlet weak var totalGallons: UILabel!
    @IBOutlet weak var calcButton: UIButton!
    
    @IBOutlet weak var displayList: UIButton!
    
    
    var thisWall : [OurWall] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calcButton.layer.cornerRadius = 20.0
       
    }
    
    @IBAction func goToList(_ sender: Any) {
        //if user is not loggined in, go to
        guard (Auth.auth().currentUser?.uid) != nil else{
            print("no user is logged in")
            displayAlert(msg: "User is not logged in")
            self.performSegue(withIdentifier: "goToFirst", sender: self)
            
            return
        }
    }
    
    
    @IBAction func calcButton(_ sender: Any) {
        
        
        //make sure all necessary textfields are inputted by users
        guard let checkLength = lengthInput.text, !checkLength.isEmpty, let _ = Int(checkLength) else{
            displayAlert(msg: "Please enter valid inputs")
            return
        }
        
        guard let checkWidth = widthInput.text, !checkWidth.isEmpty, let _ = Int(checkWidth) else{
            displayAlert(msg: "Please enter valid inputs")
            return
        }
        
        
        //get length dimensions
        guard let length = Double(lengthInput.text!) else{
            return
        }
        
        //get width dimensions
        guard let width = Double(widthInput.text!) else{
            return
        }
        //
        if length > 100000 || width > 100000{
            displayAlert(msg: "Inputs are too high")
            return
            
        }
        
        //get total sqft and get gallons
        let total = length * width
        let projectedGallon = Double(total / 400)
        
        print(total)
        print(projectedGallon)
        
        let succinctTotal = Int(total)
        
        totalData.text = "\(succinctTotal) sqft"
        totalGallons.text = "\(projectedGallon) gallons per coat"
        
    }
    //
    //
    //MARK: Send Measurements to database
    //send wall dimension measurements and calculations to our database
    //
    @IBAction func saveMeasurements(_ sender: Any) {
        
        guard let checkGallons = totalGallons.text, !checkGallons.isEmpty else{
            displayAlert(msg: "Please calculate results")
            return
        }
    
        //verify that user has calculated measurements
        guard let checkLength = lengthInput.text, !checkLength.isEmpty, let _ = Int(checkLength) else{
            displayAlert(msg: "Please enter valid inputs")
            return
        }
        
        guard let checkWidth = widthInput.text, !checkWidth.isEmpty, let _ = Int(checkWidth) else{
            displayAlert(msg: "Please enter valid inputs")
            return
        }
       
       
        
        //if user is not loggined in, go to
        guard let userID = Auth.auth().currentUser?.uid else{
            print("no user is logged in")
            displayAlert(msg: "User is not logged in")
            self.performSegue(withIdentifier: "goToFirst", sender: self)
            
            return
        }
        
       
        
        //child method to create a new child database inside main database
        let measurementsDB = Database.database().reference().child("Users/\(userID)")
        
        
        
        //end editing
        lengthInput.endEditing(true)
        widthInput.endEditing(true)
        
        lengthInput.isEnabled = false
        widthInput.isEnabled = false
        
        calcButton.isEnabled = false
        //save user dimensions as dictionary
        let dimsDictionary = ["Sender": Auth.auth().currentUser?.email, "Length": lengthInput.text, "Width": widthInput.text , "Total": totalData.text , "Gallons": totalGallons.text]
        
        //method by firebase called childbyautoid
        //creates custom random key for dimensions
        //so dimensions can be saved by their own unique identifier
        //measurementsDB.
        //measurementsDB.setValue(dimsDictionary){

        measurementsDB.childByAutoId().setValue(dimsDictionary){
            (error, reference) in
            if error != nil{
                print(error!)
            }else{
                print("Dims saved successfully")
                self.lengthInput.isEnabled = true
                self.widthInput.isEnabled = true
                self.calcButton.isEnabled = true
                
                //clear
                self.lengthInput.text = ""
                self.widthInput.text = ""
                self.totalData.text = ""
                self.totalGallons.text = ""
                
            }
        }
        
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        SVProgressHUD.showSuccess(withStatus: "Saved!")
        
    
        
    }
    

    func displayAlert(msg: String){
        let alert = UIAlertController(title: "Wait", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}


extension PaintCalculatorViewController : GetCalcDelegate{
    func userEnteredDimensions(length: String, width: String) {
        //convert dimensions to Int, then back to String
        let incomingLength = (length as NSString).integerValue
        let finalLength = String(incomingLength)
        //print(finalLength)
        lengthInput.text = finalLength
        
        let incomingWidth = (width as NSString).integerValue
        let finalWidth = String(incomingWidth)
       // print(finalWidth)
        widthInput.text = finalWidth
        
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToAR" {
            let destViewController = segue.destination as! RulerViewController
            destViewController.delegate = self
        }
    }
}
