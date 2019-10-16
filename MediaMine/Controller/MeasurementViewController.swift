//
//  MeasurementViewController.swift
//  MediaMine
//
//  Created by Christopher Chu on 9/9/19.
//  Copyright © 2019 NoOrg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

class MeasurementViewController: UIViewController {

    var ref:DatabaseReference?
    var keyArray: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //create instance
    var myWallArray = [OurWall]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        // Do any additional setup after loading the view.
        
        //set yourself as delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
        
       
        //register your customcell.xib file
        tableView.register(UINib(nibName: "labelCell", bundle: nil), forCellReuseIdentifier: "myDimsCell")
        
        
        retrieveDims()
    
        
        
    }
    
    //retrieve db data from firebase
    func retrieveDims() {
        let userID = Auth.auth().currentUser?.uid
        
        //start progress
        SVProgressHUD.show()
        
        let dimsDB = Database.database().reference().child("Users/\(userID!)")
        dimsDB.observe(DataEventType.childAdded) { (snapshot) in
            let snapshotValue = snapshot.value as! Dictionary<String,String>
            let length = snapshotValue["Length"]!
            let width = snapshotValue["Width"]!
            let total = snapshotValue["Total"]!
            let gallons = snapshotValue["Gallons"]!
//            print(length)
//            print(width)
//            print(total)
//            print(gallons)
            let dims = OurWall(length: length, width: width, total: total, gallons: gallons)
            self.myWallArray.append(dims)
            self.tableView.reloadData()
        

        }
        //end progress
        SVProgressHUD.dismiss()

        
    }
    
    
}
extension MeasurementViewController: UITableViewDelegate, UITableViewDataSource{
    
    /////////////////////////////////////////
    
    //Mark: -Tableview datasource methods
    
    /////////////////////////////////////////
    
    //Declare cellforrowatatindexpath
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myDimsCell", for: indexPath) as! CustomDimsCell
        
        
       // cell.length.text = myWallArray[indexPath.row].length
        cell.length.text = "L: \(myWallArray[indexPath.row].length) ft"
        cell.width.text = "W: \(myWallArray[indexPath.row].width) ft"
        cell.totalDims.text = "Total: \(myWallArray[indexPath.row].total)"
        //cell.gallonsTotal.text = myWallArray[indexPath.row].gallons
        
        
        //border
//        cell.layer.borderColor = UIColor(red: 0.18, green: 0.25, blue: 0.35, alpha: 1.0).cgColor
//        cell.layer.borderWidth = 2
//        cell.layer.cornerRadius = 5
//        cell.clipsToBounds = true
//        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myWallArray.count
    }
    
   
    
//    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 10.0
//    }
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let view: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.bounds.size.width, height: 10))
//        return view
//
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            //return UITableView.automaticDimension
            return UITableView.automaticDimension
        }
        else{
            return 90
        }
    }
    //remove "delete" cell
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete{
            //if user is not loggined in, go to
            guard let userID = Auth.auth().currentUser?.uid else{
                print("no user is logged in")
                self.performSegue(withIdentifier: "goToFirst", sender: self)
                return
            }

            getAllKeys()
            let when = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline: when) {
                self.ref?.child("Users/\(userID)").child(self.keyArray[indexPath.row]).removeValue()
                self.myWallArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.keyArray = []
                self.tableView.reloadData()
            }
            //self.myWallArray.remove(at: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .fade)
            
            //remove it from database
         
           
            
         }
         
     }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func getAllKeys(){
        guard let userID = Auth.auth().currentUser?.uid else{
                      return
        }
        ref?.child("Users/\(userID)").observeSingleEvent(of: .value, with: { (snapshot) in
            for child in snapshot.children{
                let snap = child as! DataSnapshot
                let key = snap.key
                self.keyArray.append(key)
            }
        })
    }
}

