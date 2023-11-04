//
//  TripListViewController.swift
//  BusStopTripsFromMapApp
//
//  Created by Berke Turanlıoğlu on 2.11.2023.
//

import UIKit

class TripListViewController: UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tripsHeaderLabel: UILabel!
    @IBOutlet weak var tripsTableView: UITableView!
    
    private let tripListPresenter = TripListPresenter()
    var trips: [TripModel] = []
    var selectedStation: StationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripListPresenter.setViewDelegate(as: self)
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
        setViews()
    }
    
    func setViews() {
        tripsHeaderLabel.text = "Trips"
        backButton.setTitle("Back", for: .normal)
    }
    
    // IBActions
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
}

// MARK: - UITableView Delegates
extension TripListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.trips.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath) as! TripListTableViewCell
        let detailedInfo = self.trips[indexPath.row]
        cell.busNameLabel.text = detailedInfo.bus_name
        cell.timeLabel.text = detailedInfo.time
        
        cell.bookButton.setTitle("Book", for: .normal)
        cell.bookButton.setTitleColor(.white, for: .normal)
        cell.bookButton.backgroundColor = UIColor(named: Constants.colorPrimaryBlue)
        cell.bookButton.layer.cornerRadius = cell.bookButton.bounds.height / 2
        
        cell.bookButtonAction = {
            self.tripListPresenter.sendTripRequest(stationId: self.selectedStation!.id, tripId: detailedInfo.id)
        }
        
        return cell
    }
}

// MARK: - TripListViewDelegate
extension TripListViewController: TripListViewDelegate {
    func didRequestFailWithError(error: Error) {
        print(error)
    }
    
    func sendTripRequest() {
        
    }
}
