//
//  RoverPhotoShowViewController.swift
//  Assignment04
//
//  Created by Simon Fong on 10/12/2023.
//

import UIKit

class RoverPhotoShowViewController: UIViewController {
    
    /// # View Controller variables
    let NOTIFICATION_NAME_IMG = "RoverPhotoShow_IMG"
    var img_src:String = ""
    var rover_name:String = ""
    var camera_name:String = ""
    var sol: String = ""
    var earth_date: String = ""
    
    /// # References
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var roverLbl: UILabel!
    @IBOutlet weak var cameraLbl: UILabel!
    @IBOutlet weak var solLbl: UILabel!
    @IBOutlet weak var earthDateLbl: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    /// # View Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator.hidesWhenStopped = true
        /// register notification center
        NotificationCenter.default.addObserver(
            self, // the current vc as observer
            selector: #selector(loadImage), // the function to execute after a post
            name: Notification.Name(NOTIFICATION_NAME_IMG),// the name of notification
            object: nil)
        
        /// if image src is not nil, call api to get image
        if img_src != "" {
            indicator.startAnimating()
            APIManager.shared.fetchData(
                urlStr: img_src, 
                notificationName: NOTIFICATION_NAME_IMG)
        }
        
        /// bind data
        roverLbl.text = "Rover: \(rover_name)"
        cameraLbl.text = "Camera: \(camera_name)"
        solLbl.text = "Sol: \(sol)"
        earthDateLbl.text = "Earth date: \(earth_date)"
    }
    
    /// # Helping function
    /// function to load image
    @objc
    func loadImage (notification: Notification){
        /// if error, show alert
        if let errMsg = notification.userInfo?["error"]{
            /// print("error")
            showAlert(showAlert:"Error", msgStr: errMsg as! String)
        }
        
        /// if success, bind data
        if let data = notification.userInfo?["success"]{
            /// print("success")
            imageV.image = UIImage(data: data as! Data)
        }
        self.indicator.stopAnimating()
    }
    
    /// function to show alert
    func showAlert(showAlert:String, msgStr:String){
        // create the alert
        let alert = UIAlertController(
            title: showAlert,
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
