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
        annotationView?.image = UIImage(named: Constants.imagePoint)
        
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
        view.image = UIImage(named: Constants.imagePoint)
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
            
            annotationView.image = UIImage(named: Constants.imagePoint)!.noir
            annotationView.canShowCallout = true
            annotationView.detailCalloutAccessoryView = tripsBubble
            self.listTripsButton.isHidden = false
        }
    }
}

// MARK: - UIImage
// new version to prevent using selected point image
extension UIImage {
    var noir: UIImage {
        let context = CIContext(options: nil)
        let currentFilter = CIFilter(name: "CIPhotoEffectNoir")!
        currentFilter.setValue(CIImage(image: self), forKey: kCIInputImageKey)
        let output = currentFilter.outputImage!
        let cgImage = context.createCGImage(output, from: output.extent)!
        let processedImage = UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)

        return processedImage
    }
}

