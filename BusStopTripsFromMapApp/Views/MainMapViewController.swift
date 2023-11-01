//
//  MainMapViewController.swift
//  BusStopTripsFromMapApp
//
//  Created by Berke Turanlıoğlu on 1.11.2023.
//

import UIKit

class MainMapViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    private let mainMapPresenter = MainMapPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainMapPresenter.setViewDelegate(as: self)
        mainMapPresenter.loadStations()
    }
    
}

// MARK: - MainMapViewDelegate
extension MainMapViewController: MainMapViewDelegate {
    func didFetchStations(stations: [StationModel]) {
        DispatchQueue.main.async {
            self.label.text! = ""
            for st in stations {
                self.label.text! += st.name + "\n"
            }
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
