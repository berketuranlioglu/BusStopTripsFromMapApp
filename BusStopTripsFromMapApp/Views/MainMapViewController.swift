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
    @IBOutlet weak var listTripsButton: UIButton!
    let locationManager = CLLocationManager()
    private let mainMapPresenter = MainMapPresenter()
    var selectedAnnotationView: MKAnnotationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mainMapPresenter.setViewDelegate(as: self)
        mainMapPresenter.fetchStations()
        
        setButtonToDown()
        setInitialMapView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        mainMapPresenter.fetchStations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        mapView.removeAnnotations(mapView.annotations)
    }
    
    // Setting up view
    func setButtonToDown() {
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Fonts.montserratSemibold, size: 18) as Any,
            .foregroundColor: UIColor.white,
        ]
        listTripsButton.setAttributedTitle(NSAttributedString(string: "List Trips", attributes: attributes), for: .normal)
        listTripsButton.backgroundColor = UIColor(named: Constants.colorPrimaryBlue)
        listTripsButton.layer.cornerRadius = listTripsButton.bounds.height / 2
        listTripsButton.isHidden = true
    }
    
    func setInitialMapView() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
        // initial view is shown on below coordinates
        let location = CLLocation(latitude: 41.04, longitude: 29.02)
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 20000, longitudinalMeters: 20000)
        
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.showsUserLocation = true
    }
    
    // IBActions
    @IBAction func listTripsButtonTapped(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        if let vc = sb.instantiateViewController(withIdentifier: "TripListViewController") as? TripListViewController {
            vc.trips = mainMapPresenter.selectedStation!.trips
            vc.selectedStation = mainMapPresenter.selectedStation
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }
    }
}

// MARK: - MKMapViewDelegate
extension MainMapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
            } else {
                annotationView?.annotation = annotation
            }
        let imageString = self.mainMapPresenter.completedStation(annotationView: annotation)
        annotationView?.image = UIImage(named: imageString)
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
           return
        }
        self.selectedAnnotationView = view
        mainMapPresenter.annotationSelected(annotationView: view)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.annotation is MKUserLocation {
           return
        }
        self.selectedAnnotationView = nil
        let imageString = self.mainMapPresenter.completedStation(annotationView: view.annotation!)
        view.image = UIImage(named: imageString)
        self.listTripsButton.isHidden = true
    }
}

// MARK: - MainMapViewDelegate (for Presenter)
extension MainMapViewController: MainMapViewDelegate {
    func didFetchStations(stations: [StationModel]) {
        DispatchQueue.main.async {
            for station in stations {
                let lat_long = station.center_coordinates.components(separatedBy: ",")
                let pin = MKPointAnnotation()
                pin.coordinate = CLLocationCoordinate2D(latitude: Double(lat_long[0])!, longitude: Double(lat_long[1])!)
                pin.subtitle = String(station.id)
                self.mapView.addAnnotation(pin)
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    func displayTripsInfo(annotationView: MKAnnotationView, trips: String) {
        DispatchQueue.main.async {
            let tripsBubble = UILabel()
            tripsBubble.text = trips
            tripsBubble.font = UIFont(name: Fonts.montserratRegular, size: 14)
            
            annotationView.image = UIImage(named: Constants.imageSelectedPoint)
            annotationView.canShowCallout = true
            annotationView.detailCalloutAccessoryView = tripsBubble
            self.listTripsButton.isHidden = false
        }
    }
}
