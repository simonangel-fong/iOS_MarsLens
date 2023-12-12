//
//  APIManager.swift
//  Assignment04
//
//  Created by Simon Fong on 10/12/2023.
//

import Foundation

class APIManager{
    
    static var shared: APIManager = APIManager()
    
    /// A function to post data to main thread
    func postNotificationCenter(notificationName:String,data:[String:Any]){
        DispatchQueue.main.async {
            NotificationCenter.default.post(
                name: Notification.Name(notificationName),
                object: nil,
                userInfo: data)
        }
    }
    
    // fetch and pass data by notificationCenter
    func fetchData(urlStr:String, notificationName:String){
        do{
            let urlObj = URL(string: urlStr)
            
            let task = URLSession.shared.dataTask(with: urlObj!){data, response, error in
                
                // if error
                if error != nil {
                    print("error nil")
                    self.postNotificationCenter(
                        notificationName: notificationName,
                        data: ["error":"\(error!.localizedDescription)" as Any] )
                }
                
                // if status failure
                if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode){
                    self.postNotificationCenter(
                        notificationName: notificationName,
                        data: ["error":"response code \(httpResponse.statusCode)" as Any] )
                }
                
                // if good data
                if let googData = data{
                    // when data is good, then post a notification to main thread.
                    self.postNotificationCenter(
                        notificationName: notificationName,
                        data: ["success":googData as Any] )
                }
            }
            task.resume()
        }
    }
}
