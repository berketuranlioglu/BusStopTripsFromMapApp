//
//  StationManager.swift
//  BusStopTripsFromMapApp
//
//  Created by Berke Turanlıoğlu on 1.11.2023.
//

import Foundation

class StationManager {
    
    static let shared = StationManager()
    
    let mainUrl = "https://demo.voltlines.com/case-study/6/stations"
    var delegate: MainMapViewDelegate?
    
    func fetchStations(handler: @escaping (([StationModel]) -> Void)) {
        // null safety for url
        guard let url = URL(string: mainUrl) else { return }
        
        // URLSession and the rest
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            
            // return if error
            if error != nil {
                self.delegate?.didFailWithError(error: error!)
                return
            }
            
            if let safeData = data {
                if let stations = self.parseData(of: safeData) {
                    handler(stations)
                }
            }
        }
        
        // start the fetching task
        task.resume()
    }
    
    private func parseData(of stationsData: Data) -> [StationModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([StationModel].self, from: stationsData)
            return decodedData
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func sendTripRequest() {
        
    }
}
