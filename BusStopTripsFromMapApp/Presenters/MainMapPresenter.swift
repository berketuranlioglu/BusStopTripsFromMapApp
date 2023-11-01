//
//  MainMapPresenter.swift
//  BusStopTripsFromMapApp
//
//  Created by Berke Turanlıoğlu on 1.11.2023.
//

protocol MainMapViewDelegate {
    func didFetchStations(stations: [StationModel])
    func didFailWithError(error: Error)
}

class MainMapPresenter {
    private var mainMapViewDelegate: MainMapViewDelegate?
    
    func setViewDelegate(as mainMapViewDelegate: MainMapViewDelegate?) {
        self.mainMapViewDelegate = mainMapViewDelegate
    }
    
    func fetchStations() {
        StationManager.shared.fetchStations { stations in
            self.mainMapViewDelegate?.didFetchStations(stations: stations)
        }
    }
}
