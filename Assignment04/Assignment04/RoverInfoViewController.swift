//
//  RoverInfoViewController.swift
//  Assignment04
//
//  Created by Simon Fong on 10/12/2023.
//

import UIKit

class RoverInfoViewController: UIViewController {
    
    /// # ViewController Variables
    let NOTIFICATION_NAME_JSON = "RoverInfo_JSON"
    
    var roverName:String?   /// rover name
    
    var roverData:roverModel?   /// info data of rover
        
    /// # References
    ///  The reference of the AppModel
    let appModel = (UIApplication.shared.delegate as! AppDelegate).appModel
  
    @IBOutlet weak var navigation: UINavigationItem!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var statusLbl: UILabel!
    
    @IBOutlet weak var launchLbl: UILabel!
    
    @IBOutlet weak var landingLbl: UILabel!
    
    @IBOutlet weak var solLbl: UILabel!
    
    @IBOutlet weak var dateLbl: UILabel!
    
    @IBOutlet weak var totalLbl: UILabel!
    
    /// # ViewController Functions

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // if rover name successful pass
        if let missionName:String = roverName {
            
            imgView.image = UIImage(named: missionName) /// load image
            navigation.title = roverName        /// update tile
            
            /// register an observer to call getJson function
            NotificationCenter.default.addObserver(
                self, // the current vc as observer
                selector: #selector(getJson), // the function to execute after a post
                name: Notification.Name(NOTIFICATION_NAME_JSON),// the name of notification
                object: nil
            )
            
            /// call api manager to fetch data from api
            APIManager.shared.fetchData(
                urlStr: "https://api.nasa.gov/mars-photos/api/v1/manifests/\(roverName!)?api_key=5C08Y7HRRUzGstgdgPG8V1w9AjTuBn1PJFz6p0kP", notificationName: NOTIFICATION_NAME_JSON)
        }
    }
    
    /// prepare function to pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! RoverPhotoListViewController
        destination.roverData = self.roverData
    }
    
    
    /// # Helping functions
    
    /// Get json based on the notification post
    @objc
    func getJson(notification: Notification){
        /// if error, show alert.
        if let errMsg = notification.userInfo?["error"]{
            showAlert(
                titleStr: "Error",
                msgStr: (errMsg as! String)
            )
        }
        
        /// if success, bind data.
        if let data = notification.userInfo?["success"]{
            // print("success")
            self.roverData = appModel.decodeRoverJson(data: data as! Data)
            self.statusLbl.text = "Status:   \(roverData!.photo_manifest!.status!)"
            self.launchLbl.text = "Launch Date:   \(roverData!.photo_manifest!.launch_date!)"
            self.landingLbl.text = "Landing Date:   \(roverData!.photo_manifest!.landing_date!)"
            self.solLbl.text = "Max Sol:   \(roverData!.photo_manifest!.max_sol!.description)"
            self.dateLbl.text = "Max Date:   \(roverData!.photo_manifest!.max_date!)"
            self.totalLbl.text = "Total Photos:   \(roverData!.photo_manifest!.total_photos!)"
        }
    }
    
    /// Show alert
    func showAlert(titleStr: String, msgStr:String){
        // create the alert
        let alert = UIAlertController(
            title: titleStr,
            message: msgStr,
            preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(
            UIAlertAction(
                title: "OK",
                style: UIAlertAction.Style.default,
                handler: nil)
        )
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}

