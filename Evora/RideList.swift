//
//  ContentView.swift
//  Evora
//
//  Created by Vinitha Rao A on 18/04/22.
//

import SwiftUI

struct RidesListView: View {
    
    @StateObject private var rideViewModel = RideListViewModel()
    @State private var selectedIndex: Int = 0
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                Picker("", selection: $selectedIndex, content: {
                    Text("Nearest").tag(0)
                    Text("Upcoming (\(rideViewModel.upcomingRides.count))").tag(1)
                    Text("Past (\(rideViewModel.pastRides.count))").tag(2)
                        })
                .pickerStyle(SegmentedPickerStyle())
                .onAppear(perform: {
                    self.rideViewModel.getData()
                })
                if selectedIndex == 0 {
                    List(rideViewModel.nearestRides, id: \.self) {
                        ride in
                        MapView(rideDetail: ride)
                    }
                } else if selectedIndex == 1 {
                    List(rideViewModel.upcomingRides, id: \.self) {
                        ride in
                        MapView(rideDetail: ride)
                    }
                } else if selectedIndex == 2 {
                    List(rideViewModel.pastRides, id: \.self) {
                        ride in
                        MapView(rideDetail: ride)
                    }
                }
            }
            .navigationBarItems(leading: Text("Edvora").font(.largeTitle), trailing: URLImage(isUserImage: true).frame(width: 60, height: 60, alignment: .center)
                .cornerRadius(30))
        }
    }
}

struct MapView : View {
    
    @State var rideDetail: RideModel = RideModel()

        var body: some View {
            VStack(alignment: .leading) {
                URLImage(isUserImage: false, urlString: rideDetail.mapURL)
                    .frame(width: 350, height: 200, alignment: .center)
                Text("\(rideDetail.id)")
            }
            
        }
}


