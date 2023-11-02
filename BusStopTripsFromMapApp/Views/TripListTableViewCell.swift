//
//  TripListTableViewCell.swift
//  BusStopTripsFromMapApp
//
//  Created by Berke Turanlıoğlu on 2.11.2023.
//

import UIKit

class TripListTableViewCell: UITableViewCell {

    @IBOutlet weak var stationLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var bookButton: UIButton!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func bookButtonTapped(_ sender: Any) {
        
    }
}
