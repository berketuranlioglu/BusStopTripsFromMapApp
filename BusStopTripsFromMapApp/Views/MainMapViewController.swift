//
//  MainMapViewController.swift
//  BusStopTripsFromMapApp
//
//  Created by Berke Turanlıoğlu on 1.11.2023.
//

import UIKit
import MapKit

class MainMapViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    private let mainMapPresenter = MainMapPresenter()
    private var isLoading: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mainMapPresenter.setViewDelegate(as: self)
        mainMapPresenter.fetchStations()
        
        setInitialMapView()
    }
    
    func setInitialMapView() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        // initial view is shown on below coordinates
        let location = CLLocation(latitude: 41.04, longitude: 29)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.showsUserLocation = true
    }
}

// MARK: - MKMapViewDelegate
extension MainMapViewController: MKMapViewDelegate {
    
}

// MARK: - MainMapViewDelegate (for Presenter)
extension MainMapViewController: MainMapViewDelegate {
    func didFetchStations(stations: [StationModel]) {
        DispatchQueue.main.async {
            for station in stations {
                let lat_long = station.center_coordinates.components(separatedBy: ",")
                let pin = MKPointAnnotation()
                pin.coordinate = CLLocationCoordinate2D(latitude: Double(lat_long[0])!, longitude: Double(lat_long[1])!)
                self.mapView.addAnnotation(pin)
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
