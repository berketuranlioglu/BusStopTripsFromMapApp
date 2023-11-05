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
        tripsHeaderLabel.font = UIFont(name: Fonts.montserratSemibold, size: 16)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Fonts.montserratSemibold, size: 16) as Any,
            .foregroundColor: UIColor(named: Constants.colorPrimaryBlue) as Any,
        ]
        backButton.setAttributedTitle(NSAttributedString(string: "Back", attributes: attributes), for: .normal)
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
        cell.busNameLabel.font = UIFont(name: Fonts.montserratSemibold, size: 16)
        cell.timeLabel.text = detailedInfo.time
        cell.timeLabel.font = UIFont(name: Fonts.montserratSemibold, size: 14)
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: Fonts.montserratSemibold, size: 14) as Any,
            .foregroundColor: UIColor.white,
        ]
        cell.bookButton.setAttributedTitle(NSAttributedString(string: "Book", attributes: attributes), for: .normal)
        
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
    func handleResponse(isSuccess: Bool) {
        if isSuccess {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        } else {
            DispatchQueue.main.async {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                if let vc = sb.instantiateViewController(withIdentifier: "ErrorPopupViewController") as? ErrorPopupViewController {
                    vc.popupHeaderText = "The trip you selected is full."
                    vc.popupDetailText = "Please select another one."
                    vc.selectTripButtonText = "Select a Trip"
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    self.present(vc, animated: true)
                }
            }
        }
    }
    
    func didRequestFailWithError(error: Error) {
        print(error)
    }
}
