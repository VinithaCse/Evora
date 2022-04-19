//
//  RideModel.swift
//  Evora
//
//  Created by Vinitha Rao A on 18/04/22.
//

import Foundation

class RideModel: NSObject {
    
    var id: Int = 0
    var originStationCode: Int = 0
    var stationPath: [Int] = []
    var destinationStationCode: Int = 0
    var date: String = ""
    var formattedDate: String = ""
    var mapURL: String = ""
    var state: String = ""
    var city: String = ""
    var leastDist: Int = 0
    var tempDate: Date = Date()
        
    override init() {
        super.init()
    }
    
    init(withJSON toDoDict: [String: Any]) {
        
        super.init()
        self.extractDetail(detailDict: toDoDict)
    }
    
    private func extractDetail(detailDict: Dictionary<String, Any>) {
        
        self.id = detailDict["id"] as? Int ?? 0
        self.originStationCode = detailDict["origin_station_code"] as? Int ?? 0
        self.stationPath = detailDict["station_path"] as? [Int] ?? []
        self.destinationStationCode = detailDict["destination_station_code"] as? Int ?? 0
        self.date = detailDict["date"] as? String ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd.yyyy h:mm a"
        dateFormatter.locale = NSLocale.current
        tempDate = dateFormatter.date(from: self.date)!
        let stringDateFormatter = DateFormatter()
        stringDateFormatter.dateFormat = "dd MMM"
        self.formattedDate = stringDateFormatter.string(from: tempDate)
        self.mapURL = detailDict["map_url"] as? String ?? ""
        self.state = detailDict["state"] as? String ?? ""
        self.city = detailDict["city"] as? String ?? ""
    }
    
}

