//
//  RoverListViewController.swift
//  Assignment04
//
//  Created by Simon Fong on 10/12/2023.
//

import UIKit

class RoverListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /// # References
    let appModel = (UIApplication.shared.delegate as! AppDelegate).appModel /// A reference to the AppModel
    
    @IBOutlet weak var roverTB: UITableView!
    
    /// # View Controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appModel.rover_list.count        /// return Rovers number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// create dequeueReusableCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = appModel.rover_list[indexPath.row]
        cell.imageView?.image = UIImage(named: appModel.rover_list[indexPath.row])
        return cell
    }
    
    /// function to set height of table
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 80.0;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        roverTB.reloadData()    /// Reload table's data when return to the current view
    }
    
    /// prepare function to pass data
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /// Reference of next view
        guard let roverInfo = segue.destination as? RoverInfoViewController else {
            return
        }
                        
        roverInfo.roverName = appModel.rover_list[roverTB.indexPathForSelectedRow!.row]     /// pass rover name
    }
}
