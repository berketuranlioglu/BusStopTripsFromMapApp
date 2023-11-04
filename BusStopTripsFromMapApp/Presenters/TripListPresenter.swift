//
//  TripListPresenter.swift
//  BusStopTripsFromMapApp
//
//  Created by Berke Turanlıoğlu on 3.11.2023.
//

protocol TripListViewDelegate {
    func sendTripRequest()
    func didRequestFailWithError(error: Error)
}

class TripListPresenter {
    private var tripListViewDelegate: TripListViewDelegate?
    
    func setViewDelegate(as tripListViewDelegate: TripListViewDelegate?) {
        self.tripListViewDelegate = tripListViewDelegate
    }
    
    func sendTripRequest(stationId: Int, tripId: Int) {
        StationManager.shared.sendTripRequest(stationId: stationId, tripId: tripId)
    }
}
