//
//  TripListViewController.swift
//  BusStopTripsFromMapApp
//
//  Created by Berke Turanlıoğlu on 2.11.2023.
//

import UIKit

class TripListViewController: UIViewController {
    
    @IBOutlet weak var tripsHeaderLabel: UILabel!
    @IBOutlet weak var tripsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tripsTableView.delegate = self
        tripsTableView.dataSource = self
    }
}

extension TripListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tripCell", for: indexPath)
        
        return cell
    }
    
    
}
