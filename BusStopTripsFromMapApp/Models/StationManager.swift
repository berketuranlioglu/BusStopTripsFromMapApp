//
//  StationManager.swift
//  BusStopTripsFromMapApp
//
//  Created by Berke Turanlıoğlu on 1.11.2023.
//

import Foundation

class StationManager {
    
    // Singleton class
    static let shared = StationManager()
    
    let mainUrl = "https://demo.voltlines.com/case-study/6/stations"
    var mainMapViewDelegate: MainMapViewDelegate?
    var tripListViewDelegate: TripListViewDelegate?
    
    func fetchStations(handler: @escaping (([StationModel]) -> Void)) {
        // null safety for url
        guard let url = URL(string: mainUrl) else { return }
        
        // URLSession and the rest
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { (data, response, error) in
            
            // return if error
            if error != nil {
                self.mainMapViewDelegate?.didFailWithError(error: error!)
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
            mainMapViewDelegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func sendTripRequest(stationId: Int, tripId: Int, handler: @escaping ((Int) -> Void)) {
        let requestUrl = self.mainUrl + "/\(stationId)/trips/\(tripId)"
        
        // null safety for url
        guard let url = URL(string: requestUrl) else { return }
        
        // URLSession and the rest
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: url)
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            // return if error
            if error != nil {
                self.tripListViewDelegate?.didRequestFailWithError(error: error!)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                handler(httpResponse.statusCode)
            } else {
                handler(400)
            }
        }
        
        // start the fetching task
        task.resume()
    }
}
