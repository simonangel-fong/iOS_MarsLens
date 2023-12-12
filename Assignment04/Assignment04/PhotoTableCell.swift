//
//  PhotoTableCell.swift
//  Assignment04
//
//  Created by Simon Fong on 10/12/2023.
//
import UIKit
import Foundation

class PhotoTableCell: UITableViewCell {
    
    @IBOutlet weak var cellImgV: UIImageView!
    @IBOutlet weak var solLbl: UILabel!
    @IBOutlet weak var earthDateLbl: UILabel!
    @IBOutlet weak var cameraLbl: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.indicator.hidesWhenStopped = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
