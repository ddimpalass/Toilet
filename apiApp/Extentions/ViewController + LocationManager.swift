//
//  5.swift
//  apiApp
//
//  Created by Apple on 14.01.2021.
//

import UIKit
import CoreLocation
import MapKit

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        for index in 0..<waterClosetArray.count{
            var distance: Double {
                get {
                    return CLLocation(latitude: waterClosetArray[index].cells.geoData.coordinates[1],
                                      longitude: waterClosetArray[index].cells.geoData.coordinates[0])
                        .distance(from: location)
                }
            }
            waterClosetArray[index].distance = distance
        }
        waterClosetArray.sort(by: {$0.distance ?? 100000 < $1.distance ?? 100000})
        tableView.reloadData()
    }
    
    func centerLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion(center: location,
                                            latitudinalMeters: 1000,
                                            longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
}
