//
//  ErrorPopupViewController.swift
//  BusStopTripsFromMapApp
//
//  Created by Berke Turanlıoğlu on 4.11.2023.
//

import UIKit

class ErrorPopupViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var popupHeaderLabel: UILabel!
    @IBOutlet weak var popupDetailLabel: UILabel!
    @IBOutlet weak var selectTripButton: UIButton!
    
    var popupHeaderText: String?
    var popupDetailText: String?
    var selectTripButtonText: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
    }

    func setViews() {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        popupView.layer.cornerRadius = 12
        
        popupHeaderLabel.text = popupHeaderText ?? "The trip you selected is full."
        popupDetailLabel.text = popupDetailText ?? "Please select another one."
        
        selectTripButton.setTitle(selectTripButtonText ?? "Select a Trip", for: .normal)
        selectTripButton.setTitleColor(.white, for: .normal)
        selectTripButton.backgroundColor = UIColor(named: Constants.colorPrimaryBlue)
        selectTripButton.layer.cornerRadius = selectTripButton.bounds.height / 2
    }
    
    @IBAction func selectTripButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}
