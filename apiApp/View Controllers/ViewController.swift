//
//  ViewController.swift
//  apiApp
//
//  Created by Apple on 13.01.2021.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var openTableButton: UIButton!
    @IBOutlet weak var customViewButton: UIView!
    @IBOutlet weak var customView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var buttonStackView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let blurViewTable = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    let vibrancyViewTable = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    let vibrancyEffectTable = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .systemUltraThinMaterial), style: .label)
    
    let blurViewButton = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    let vibrancyViewButton = UIVisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterial))
    let vibrancyEffectButton = UIVibrancyEffect(blurEffect: UIBlurEffect(style: .systemUltraThinMaterial), style: .label)
    
    let annotationIdentifier = "annotationIdentifier"
    
    var waterClosetArray: [WaterClosetData] = []
    var selectedWcIndex: Int?
    var placeCoordinate: CLLocationCoordinate2D?
    
    lazy var currentDayInt = getCurrentDay()
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        return locationManager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addShadow()
        
        getWC()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    func getWC() {
        StorageManager.shared.getWCfromStorage{ [weak self] waterClosetArray in
            guard let self = self else { return }
            self.waterClosetArray = waterClosetArray ?? []
            self.updateView()
        }
        guard waterClosetArray.isEmpty else { return }
        getWCfromNetwork()
    }
    
    func updateView(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.addPoints()
            self.activityIndicator.stopAnimating()
            self.centerLocation()
        }
    }
    
    func getCurrentDay() -> Int {
        let date = Date()
        let dateFormatter = DateFormatter()
        return dateFormatter.calendar.component(.weekday, from: date)
    }
    
    func getWCfromNetwork() {
        activityIndicator.startAnimating()
        NetworkManager.fetchWCfromNetwork { [weak self] waterClosetArray, error in
            guard let self = self else { return }
            if waterClosetArray != nil {
                self.waterClosetArray = waterClosetArray ?? []
                self.updateView()
            } else if error != nil {
                print("\n Failure: \(error!.localizedDescription)")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    @IBAction func centerLocationTapped(_ sender: UIButton) {
        centerLocation()
    }
    
    @IBAction func updateWCfromNetwork(_ sender: UIButton) {
        getWCfromNetwork()
    }
    
    
    @IBAction func openTable(_ sender: UIButton) {
        if self.customView.isHidden {
            animationShow()
            openTableButton.setImage(UIImage(systemName: "multiply.circle"), for: .normal)
        } else {
            animationHide()
            openTableButton.setImage(UIImage(systemName: "line.horizontal.3.circle"), for: .normal)
        }
    }
}

// MARK: UITableView

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

// MARK: UIMapView

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

// MARK: CLLocationManager

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

// MARK: Setup views

extension ViewController {
    func addShadow(){
        customView.layer.shadowColor = UIColor.black.cgColor
        customView.layer.shadowRadius = 4
        customView.layer.shadowOffset = CGSize(width: 1, height: 1)
        customView.layer.shadowOpacity = 0.5
        
        customViewButton.layer.shadowColor = UIColor.black.cgColor
        customViewButton.layer.shadowRadius = 4
        customViewButton.layer.shadowOffset = CGSize(width: 1, height: 1)
        customViewButton.layer.shadowOpacity = 0.5
    }
    
    func setupViews(){
        blurViewTable.clipsToBounds = true
        blurViewTable.layer.cornerRadius = 20
        blurViewTable.translatesAutoresizingMaskIntoConstraints = false
        customView.insertSubview(blurViewTable, at: 0)
        blurViewTable.heightAnchor.constraint(equalTo: customView.heightAnchor).isActive = true
        blurViewTable.widthAnchor.constraint(equalTo: customView.widthAnchor).isActive = true
        
        blurViewButton.clipsToBounds = true
        blurViewButton.layer.cornerRadius = 20
        blurViewButton.translatesAutoresizingMaskIntoConstraints = false
        customViewButton.insertSubview(blurViewButton, at: 0)
        blurViewButton.heightAnchor.constraint(equalTo: customViewButton.heightAnchor).isActive = true
        blurViewButton.widthAnchor.constraint(equalTo: customViewButton.widthAnchor).isActive = true
        
        vibrancyViewTable.effect = vibrancyEffectTable
        vibrancyViewButton.effect = vibrancyEffectButton
        blurViewTable.contentView.addSubview(vibrancyViewTable)
        blurViewButton.contentView.addSubview(vibrancyViewButton)
        
        vibrancyViewTable.translatesAutoresizingMaskIntoConstraints = false
        vibrancyViewTable.heightAnchor.constraint(equalTo: blurViewTable.heightAnchor).isActive = true
        vibrancyViewTable.widthAnchor.constraint(equalTo: blurViewTable.widthAnchor).isActive = true
        
        vibrancyViewButton.translatesAutoresizingMaskIntoConstraints = false
        vibrancyViewButton.heightAnchor.constraint(equalTo: blurViewButton.heightAnchor).isActive = true
        vibrancyViewButton.widthAnchor.constraint(equalTo: blurViewButton.widthAnchor).isActive = true
        
        vibrancyViewTable.contentView.addSubview(tableView)
        vibrancyViewButton.contentView.addSubview(buttonStackView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.heightAnchor.constraint(equalTo: vibrancyViewTable.heightAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: vibrancyViewTable.widthAnchor).isActive = true
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.heightAnchor.constraint(equalTo: vibrancyViewButton.heightAnchor).isActive = true
        buttonStackView.widthAnchor.constraint(equalTo: vibrancyViewButton.widthAnchor).isActive = true
    }
}

// MARK: Animation

extension ViewController {
    func animationShow(){
        customView.isHidden = false
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveLinear,
                       animations: { [weak self] in
                        guard let self = self else { return }
                        
                        self.customView.bounds.origin.y += self.customView.bounds.height
                        self.customView.layoutIfNeeded()
                       })
    }
    
    func animationHide(){
        UIView.animate(withDuration: 0.2,
                       delay: 0,
                       options: .curveEaseIn,
                       animations: { [weak self] in
                        guard let self = self else { return }
                        
                        self.customView.bounds.origin.y -= self.customView.bounds.height
                        self.customView.layoutIfNeeded()
                       }) { _ in
            self.customView.isHidden = true
        }
    }
}





