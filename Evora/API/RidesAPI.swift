//
//  RidesAPI.swift
//  Evora
//
//  Created by Vinitha Rao A on 18/04/22.
//

import Foundation

class RidesApi {
    
    class func getRidesAPI(configuration: APIConfigurator, completionHandler: @escaping(_ ridesData: [RideModel]) -> Void) {
        
        APIHandler.performRequest(with: configuration) {
            (data, urlResponse, error) in
            
            if error == nil, let receivedData = data {
                
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: receivedData, options: [.allowFragments]) as! [[String: Any]]
                    var rides: [RideModel] = []
                    for json in jsonResult {
                        let ride = RideModel(withJSON: json)
                        rides.append(ride)
                    }
                    completionHandler(rides)
                }
                
                catch {
                    completionHandler([])
                }
            }
        }
    }
}
