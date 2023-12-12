//
//  AppModel.swift
//  Assignment04
//
//  Created by Simon Fong on 10/12/2023.
//

import Foundation

import UIKit

class photoModel: Codable{
    var photos:[photosObj]?
    
    class photosObj:Codable{
        var sol: Int
        var img_src:String
        var earth_date:String
        var camera:cameraObj
    }
    
    class cameraObj:Codable{
        var name:String
        var full_name:String
    }
}

class roverModel: Codable{
    var photo_manifest: manifestObj?
    
    class manifestObj:Codable{
        var name:String?
        var landing_date:String?
        var launch_date:String?
        var status:String?
        var max_sol:Int?
        var max_date:String?
        var total_photos:Int?
    }
}

class AppModel{
    
    let cam_list:[String] = ["FHAZ", "RHAZ", "NAVCAM"]
    let rover_list:[String] = ["Curiosity","Opportunity","Spirit"]
    
    /// Function to decode Json into target type
    func decodePhotoJson(data:Data)-> photoModel{
        return try! JSONDecoder().decode(
            photoModel.self,
            from: data
        )
    }
    
    /// Function to decode Json into target type
    func decodeRoverJson(data:Data)-> roverModel{
        return try! JSONDecoder().decode(
            roverModel.self,
            from: data
        )
    }
    
    /// Function to convert data into UIImage
    func toImage(data:Data)-> UIImage?{
        return UIImage(data:data)
    }
}
