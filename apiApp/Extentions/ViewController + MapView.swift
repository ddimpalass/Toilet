//
//  4.swift
//  apiApp
//
//  Created by Apple on 14.01.2021.
//

import UIKit
import MapKit

extension ViewController: MKMapViewDelegate {
    func addPoints(){
        var annotationsArray: [MKAnnotation] = []
        for location in waterClosetArray {
            let annotation = MKPointAnnotation()
            annotation.title = "Tуалет №\(String(location.globalID).replacingOccurrences(of: "ID",with: "", options: .literal, range: nil)), \(location.cells.district.replacingOccurrences(of: "район",with: "р-н", options: .literal, range: nil))"
            annotation.subtitle = "Нажмите чтобы посмотреть часы работы"
            annotation.coordinate = CLLocationCoordinate2D(
                latitude: location.cells.geoData.coordinates[1],
                longitude: location.cells.geoData.coordinates[0])
            annotationsArray.append(annotation)
        }
        mapView.showAnnotations(annotationsArray, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        guard let annotation = view.annotation as? MKPointAnnotation else { return }
        
        annotation.title = "Tуалет №\(String(waterClosetArray[selectedWcIndex ?? 0].globalID).replacingOccurrences(of: "ID",with: "", options: .literal, range: nil)), \(waterClosetArray[selectedWcIndex ?? 0].cells.district.replacingOccurrences(of: "район",with: "р-н", options: .literal, range: nil))"
        annotation.subtitle = "Нажмите чтобы посмотреть часы работы"
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        placeCoordinate = view.annotation?.coordinate
        
        selectedWcIndex = waterClosetArray.firstIndex { (WaterClosetData) -> Bool in
            WaterClosetData.cells.geoData.coordinates[1] == view.annotation?.coordinate.latitude
        }
        
        let indexPath = IndexPath(row: selectedWcIndex ?? 0, section: 0)
        tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        
        var index = 0

        switch currentDayInt {
        case 2:
            index = 0
        case 3:
            index = 1
        case 4:
            index = 2
        case 5:
            index = 3
        case 6:
            index = 4
        case 7:
            index = 5
        case 1:
            index = 6
        default:
            print("error")
        }

        guard let annotation = view.annotation as? MKPointAnnotation else { return }
        
        guard control == view.rightCalloutAccessoryView else { return }
        annotation.title = "Сегодня, \(waterClosetArray[selectedWcIndex ?? 0].cells.workingHours[index].dayOfWeek.capitalized)"
        annotation.subtitle = "Часы работы: \(waterClosetArray[selectedWcIndex ?? 0].cells.workingHours[index].hours)"

    }

}
