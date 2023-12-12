//
//  RoverPhotoListViewController.swift
//  Assignment04
//
//  Created by Simon Fong on 10/12/2023.
//

import UIKit

class RoverPhotoListViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    /// # View Controller variables
    let NOTIFICATION_NAME_JSON = "RoverPhotoList_JSON"   ///  notification name for json
    var roverData:roverModel?   /// data of rover
    var photoData:photoModel?   /// data of photos
    
    /// # References
    let appModel = (UIApplication.shared.delegate as! AppDelegate).appModel     /// AppModel
    @IBOutlet weak var navigation: UINavigationItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var camPck: UIPickerView!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var photoTB: UITableView!
    
    /// # View Controller Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        // register an observer to call getJson function
        NotificationCenter.default.addObserver(
            self, // the current vc as observer
            selector: #selector(getJson), // the function to execute after a post
            name: Notification.Name(NOTIFICATION_NAME_JSON),// the name of notification
            object: nil)
        
        /// update title if rover data loaded
        if let rover = roverData {
            navigation.title = "\(rover.photo_manifest!.name!)'s photos"
        }
    }
    
    /// ## Picker functions
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return appModel.cam_list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return appModel.cam_list[row]
    }
    
    /// ## Table functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // print("number of rows")
        if let photo_list = self.photoData?.photos, photo_list.count > 0{
            return photo_list.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! PhotoTableCell
        if let photo_list = photoData!.photos, photo_list.count > 0{
            cell.solLbl.text = "Sol: \(photo_list[indexPath.row].sol)"
            cell.earthDateLbl.text = "Earth Date: \(photo_list[indexPath.row].earth_date)"
            cell.cameraLbl.text = "Camera: \(photo_list[indexPath.row].camera.name)"
            cell.indicator.startAnimating()
            /// call function to load image
            loadImg(
                urlStr: photo_list[indexPath.row].img_src,
                imgV: cell.cellImgV,
                indicator:cell.indicator
            )
        }
        return cell
    }
    
    /// function to set height of table
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100.0;
    }
    
    /// ## SearchBar function
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        let allowedCharacterSet = CharacterSet(charactersIn: "0123456789")  //  CharacterSet
        let replacementTextCharacterSet = CharacterSet(charactersIn: text)
        let isNumeric = allowedCharacterSet.isSuperset(of: replacementTextCharacterSet)
        
        // Allow the change only if it's a numeric character or the text is empty (backspace)
        return isNumeric || text.isEmpty
    }
    
    /// Action to request data when the button is clicked.
    @IBAction func searchBtn(_ sender: Any) {
        let sol = searchBar.text!
        /// if input in search bar is empty
        guard sol.count > 0 else{
            showAlert(title: "Warning", msgStr: "Sol is required.")
            return
        }
        
        let cam = appModel.cam_list[camPck.selectedRow(inComponent: 0)]
        if let rover_name = self.roverData?.photo_manifest!.name {
            ///print(rover_name)
            let url = "https://api.nasa.gov/mars-photos/api/v1/rovers/\(rover_name)/photos?api_key=5C08Y7HRRUzGstgdgPG8V1w9AjTuBn1PJFz6p0kP&sol=\(sol)&camera=\(cam)"
            
            /// Call api manager function to load json data
            APIManager.shared.fetchData(
                urlStr: url,
                notificationName: NOTIFICATION_NAME_JSON
            )
        }
        photoTB.reloadData()
    }
    
    ///  prepare function to pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let dest = segue.destination as! RoverPhotoShowViewController
        
        dest.rover_name = self.roverData!.photo_manifest!.name!
        dest.img_src = self.photoData!.photos![self.photoTB.indexPathForSelectedRow!.row].img_src
        dest.camera_name = self.photoData!.photos![self.photoTB.indexPathForSelectedRow!.row].camera.full_name
        dest.sol = self.photoData!.photos![self.photoTB.indexPathForSelectedRow!.row].sol.description
        dest.earth_date = self.photoData!.photos![self.photoTB.indexPathForSelectedRow!.row].earth_date
    }
    
    /// # Helping functions
    ///  function to get json data.
    @objc
    func getJson(notification: Notification){
        /// when error, show alert
        if let errMsg = notification.userInfo?["error"]{
            /// print("error")
            showAlert(title: "Error", msgStr: errMsg as! String)
        }
        
        /// when success, bind data
        if let data = notification.userInfo?["success"]{
            print("success")
            
            let jsonData =  appModel.decodePhotoJson(data: data as! Data)
            self.photoData = jsonData
            if self.photoData!.photos!.count == 0 {
                showAlert(title: "Info", msgStr: "No photo on current Sol.")
            }
            self.photoTB.reloadData()   /// reload table data
        }
    }
    
    /// function to load image
    func loadImg (urlStr:String, imgV:UIImageView, indicator: UIActivityIndicatorView){
        let queue = DispatchQueue.init(label: "myQ")
        queue.async {
            do{
                let urlObj = URL(string:urlStr)
                // download data from the url, which taks time
                let imageData = try Data(contentsOf: urlObj!)
                
                /// access items and send data back to the main thread after the bg thread finished
                DispatchQueue.main.async {
                    imgV.image = UIImage(data:imageData)
                    indicator.stopAnimating()   /// stop animation when success
                }
            }catch{
                DispatchQueue.main.async {
                    self.showAlert(title: "Error", msgStr: error.localizedDescription)
                }
            }
        }
    }
    
    /// Function to show alert
    func showAlert(title:String,msgStr:String){
        // create the alert
        let alert = UIAlertController(
            title: title,
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
