//
//  TripListPresenter.swift
//  BusStopTripsFromMapApp
//
//  Created by Berke Turanlıoğlu on 3.11.2023.
//

import Foundation

protocol TripListViewDelegate {
    func didRequestFailWithError(error: Error)
    func handleResponse(isSuccess: Bool)
}

class TripListPresenter {
    private var tripListViewDelegate: TripListViewDelegate?
    
    func setViewDelegate(as tripListViewDelegate: TripListViewDelegate?) {
        self.tripListViewDelegate = tripListViewDelegate
    }
    
    func sendTripRequest(stationId: Int, tripId: Int) {
        StationManager.shared.sendTripRequest(stationId: stationId, tripId: tripId) { responseStatus in
            if responseStatus < 400 {
                var bookedStations = UserDefaults.standard.array(forKey: Constants.keyBookedStations) ?? []
                bookedStations.append(stationId)
                UserDefaults.standard.set(bookedStations, forKey: Constants.keyBookedStations)
                self.tripListViewDelegate?.handleResponse(isSuccess: true)
            } else {
                self.tripListViewDelegate?.handleResponse(isSuccess: false)
            }
        }
    }
}
