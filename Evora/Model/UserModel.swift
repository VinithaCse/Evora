//
//  UserModel.swift
//  Evora
//
//  Created by Vinitha Rao A on 18/04/22.
//

import Foundation

class UserModel: NSObject {
    
    var stationCode: Int = 0
    var name: String = ""
    var profileKey: String = ""
        
    override init() {
        super.init()
    }
    
    init(withJSON toDoDict: [String: Any]) {
        
        super.init()
        self.extractDetail(detailDict: toDoDict)
    }
    
    private func extractDetail(detailDict: Dictionary<String, Any>) {
        
        self.stationCode = detailDict["station_code"] as? Int ?? 0
        self.profileKey = detailDict["url"] as? String ?? ""
        self.name = detailDict["name"] as? String ?? ""
    }
    
}
