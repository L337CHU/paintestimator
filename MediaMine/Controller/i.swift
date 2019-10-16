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

class PaintCalculatorViewController: UIViewController {

    @IBOutlet weak var lengthInput: UITextField!
    @IBOutlet weak var widthInput: UITextField!
    @IBOutlet weak var totalData: UILabel!
    @IBOutlet weak var totalGallons: UILabel!
    @IBOutlet weak var calcButton: UIButton!
    
    var thisWall : [OurWall] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calcButton.layer.cornerRadius = 20.0
    }
    
    
    @IBAction func calcButton(_ sender: Any) {
        
        //get length dimensions
        guard let length = Double(lengthInput.text!) else{
            return
        }
        
        //get width dimensions
        guard let width = Double(widthInput.text!) else{
            return
        }
        
        //get total sqft and get gallons
        let total = length * width
        let projectedGallon = total / 400
        print(total)
        print(projectedGallon)
        
        let succinctTotal = Int(total)
        
        totalData.text = "\(succinctTotal)sqft."
        totalGallons.text = "\(projectedGallon) gallons per coat"
    }
    
    //MARK: Send Measurements to database
    //send wall dimension measurements and calculations to our database
    
    @IBAction func saveMeasurements(_ sender: Any) {
        
        //make sure all necessary textfields are inputted by users
        guard let coco = lengthInput.text where coco.characters.count > 0 else{
            print("har")
            return
        }
        
        
        
        //end editing
        lengthInput.endEditing(true)
        widthInput.endEditing(true)
        
        lengthInput.isEnabled = false
        widthInput.isEnabled = false
        
        calcButton.isEnabled = false
        
        //check to see if user is loggined in : auth?
        //if user is not loggined in, go to
        
        
        //child method to create a new child database inside main database
        let measurementsDB = Database.database().reference().child("Dimensions")
        
        //save user dimensions as dictionary
        let dimsDictionary = ["Sender": Auth.auth().currentUser?.email, "Length": lengthInput.text, "Width": widthInput.text , "Total": totalData.text , "Gallons": totalGallons.text]
        
        //method by firebase called childbyautoid
        //creates custom random key for dimensions
        //so dimensions can be saved by their own unique identifier
        
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
                //self.totalGallons.text = ""
                
            }
        }
        
    
        
    }
    

}
