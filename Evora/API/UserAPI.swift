//
//  UserAPI.swift
//  Evora
//
//  Created by Vinitha Rao A on 18/04/22.
//

import Foundation

class UserApi {
    
    class func getUserAPI(configuration: APIConfigurator, completionHandler: @escaping(_ ridesData: UserModel) -> Void) {
        
        APIHandler.performRequest(with: configuration) {
            (data, urlResponse, error) in
            
            if error == nil, let receivedData = data {
                
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: receivedData, options: [.allowFragments]) as! [String: Any]
                    
                    var user: UserModel = UserModel()
                    user = UserModel(withJSON: jsonResult)
                    
                    completionHandler(user)
                }
                catch {
                    completionHandler(UserModel())
                }
            }
        }
    }
}
