//
//  TripListPresenter.swift
//  BusStopTripsFromMapApp
//
//  Created by Berke Turanlıoğlu on 3.11.2023.
//

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
            self.tripListViewDelegate?.handleResponse(isSuccess: responseStatus < 400)
        }
    }
}
