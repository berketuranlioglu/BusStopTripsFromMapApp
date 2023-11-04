//
//  StationModel.swift
//  BusStopTripsFromMapApp
//
//  Created by Berke Turanlıoğlu on 1.11.2023.
//

import Foundation

struct StationModel: Identifiable, Codable {
    let id: Int
    let center_coordinates: String
    let name: String
    let trips: [TripModel]
    let trips_count: Int
    
    init(id: Int, center_coordinates: String, name: String, trips: [TripModel], trips_count: Int) {
        self.id = id
        self.center_coordinates = center_coordinates
        self.name = name
        self.trips = trips
        self.trips_count = trips_count
    }
}

struct TripModel: Identifiable, Codable {
    let bus_name: String
    let id: Int
    let time: String
    
    init(bus_name: String, id: Int, time: String) {
        self.bus_name = bus_name
        self.id = id
        self.time = time
    }
}
