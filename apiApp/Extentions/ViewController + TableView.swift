//
//  3.swift
//  apiApp
//
//  Created by Apple on 14.01.2021.
//

import UIKit
import CoreLocation
import MapKit

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "БЕСПЛАТНЫЕ ОБЩЕСТВЕННЫЕ ТУАЛЕТЫ"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return waterClosetArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ListTableViewCell else { return UITableViewCell() }
        let nameLabel = waterClosetArray[indexPath.row].cells.location
        cell.nameWC.text = nameLabel.replacingOccurrences(of: "город Москва, ", with: "", options: .literal, range: nil)
        let distanceLabel = waterClosetArray[indexPath.row].distance ?? 0
        switch distanceLabel {
        case 0..<1000:
            cell.directionsWC.text = "\(String(format: "%.0f", distanceLabel))м"
        default:
            cell.directionsWC.text = "\(String(format: "%.1f", distanceLabel/1000))км"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        placeCoordinate = CLLocationCoordinate2D(
            latitude: waterClosetArray[indexPath.row].cells.geoData.coordinates[1],
            longitude: waterClosetArray[indexPath.row].cells.geoData.coordinates[0])
        guard let coordinate = placeCoordinate else { return }
        let region = MKCoordinateRegion(center: coordinate,
                                        latitudinalMeters: 1000,
                                        longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        for annotation in mapView.annotations {
            if let annotation = annotation as? MKPointAnnotation,
               annotation.coordinate.latitude == waterClosetArray[indexPath.row].cells.geoData.coordinates[1] {
                mapView.selectAnnotation(annotation, animated: true)
            }
        }
    }
}
