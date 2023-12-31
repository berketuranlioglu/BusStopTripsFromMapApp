//
//  MainMapPresenter.swift
//  BusStopTripsFromMapApp
//
//  Created by Berke Turanlıoğlu on 1.11.2023.
//

import MapKit

protocol MainMapViewDelegate {
    // for fetching stations
    func didFetchStations(stations: [StationModel])
    func didFailWithError(error: Error)
    
    // for annotation views
    func displayTripsInfo(annotationView: MKAnnotationView, trips: String)
}

class MainMapPresenter {
    private var mainMapViewDelegate: MainMapViewDelegate?
    var stations: [StationModel] = []
    var selectedStation: StationModel?
    
    func setViewDelegate(as mainMapViewDelegate: MainMapViewDelegate?) {
        self.mainMapViewDelegate = mainMapViewDelegate
    }
    
    func fetchStations() {
        StationManager.shared.fetchStations { stations in
            self.stations = stations
            self.mainMapViewDelegate?.didFetchStations(stations: stations)
        }
    }
    
    func annotationSelected(annotationView: MKAnnotationView) {
        if let annotation = annotationView.annotation {
            if let annotationIndex = stations.firstIndex(where: { $0.id == Int(annotation.subtitle!!) }) {
                self.selectedStation = stations[annotationIndex]
                let tripsCount = stations[annotationIndex].trips.count
                let tripsString = tripsCount == 1 ? "\(tripsCount) Trip" : "\(tripsCount) Trips"
                self.mainMapViewDelegate?.displayTripsInfo(annotationView: annotationView, trips: tripsString)
            } else {
                self.mainMapViewDelegate?.displayTripsInfo(annotationView: annotationView, trips: "No trips information was found")
            }
        } else {
            self.mainMapViewDelegate?.displayTripsInfo(annotationView: annotationView, trips: "No trips information was found")
        }
        
    }
    
    func completedStation(annotationView: MKAnnotation) -> String {
        if let annotationIndex = stations.firstIndex(where: { $0.id == Int(annotationView.subtitle!!) }),
           let completedStations = UserDefaults.standard.array(forKey: Constants.keyBookedStations) as? [Int] {
            if completedStations.contains(where: { $0 == stations[annotationIndex].id }) {
                return Constants.imageCompleted
            }
        }
        return Constants.imagePoint
    }
}
