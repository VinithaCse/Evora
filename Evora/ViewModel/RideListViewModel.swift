//
//  ListViewModel.swift
//  Evora
//
//  Created by Vinitha Rao A on 18/04/22.
//

import Foundation

class RideListViewModel: ObservableObject {
    
    private var ridesList: [RideModel] = []
    @Published var nearestRides: [RideModel] = []
    @Published var upcomingRides: [RideModel] = []
    @Published var pastRides: [RideModel] = []
    private var userViewModel: UserViewModel = UserViewModel()
    private var userStationCode: Int = 0
    private var nearestRide: [RideModel] = []
    
    func getData() {
        
        let apiConfig = APIConfigurator(jsonValue: [:], httpMethod: .get, urlToBeCalled: "http://assessment.api.vweb.app/rides")
        RidesApi.getRidesAPI(configuration: apiConfig, completionHandler: {
            [weak self] rides in
            
            if let self = self {
                self.ridesList = rides
                self.nearestRides = self.determineNearestRide()
                self.determineUpcomingRides()
            }
        })
    }
    
    func determineUpcomingRides() {
        let todayDate = Date()
        
        for ride in self.ridesList {
            if todayDate < ride.tempDate {
                upcomingRides.append(ride)
            } else {
                pastRides.append(ride)
            }
        }
    }
    
    func determineNearestRide() -> [RideModel] {
        
        userViewModel.getData(completionHandler: {
            [weak self] isCompleted in
            
            if let self = self {
                
                if isCompleted {
                    self.userStationCode = self.userViewModel.user.stationCode
                    
                    for ride in self.ridesList {
                        
                        var least = 0
                        for station in ride.stationPath {
                            
                            let diff = station - self.userStationCode
                            if diff < least {
                                least = diff
                            }
                        }
                        
                        ride.leastDist = least
                    }
                    
                    self.ridesList.sort(by: {
                        $0.leastDist < $1.leastDist
                    })
                    
                }
            }
            
        })
        
        return ridesList
    }

}
