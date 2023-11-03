//
//  TripListTableViewCell.swift
//  BusStopTripsFromMapApp
//
//  Created by Berke Turanlıoğlu on 2.11.2023.
//

import UIKit

class TripListTableViewCell: UITableViewCell {

    @IBOutlet weak var busNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bookButton: UIButton!
    
    var action: (() -> Void)?
    
    @IBAction func bookButtonTapped(_ sender: Any) {
        action?()
    }
}
