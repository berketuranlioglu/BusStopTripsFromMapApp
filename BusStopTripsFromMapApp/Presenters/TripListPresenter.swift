//
//  TripListPresenter.swift
//  BusStopTripsFromMapApp
//
//  Created by Berke Turanlıoğlu on 3.11.2023.
//

protocol TripListViewDelegate {
    func sendTripRequest()
}

class TripListPresenter {
    private var tripListViewDelegate: TripListViewDelegate?
    
    func setViewDelegate(as tripListViewDelegate: TripListViewDelegate?) {
        self.tripListViewDelegate = tripListViewDelegate
    }
    
    func sendTripRequest() {
        StationManager.shared.sendTripRequest()
    }
}
