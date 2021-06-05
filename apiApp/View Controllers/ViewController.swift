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

    let defaults = UserDefaults.standard
    var supportData: SupportData = SupportData(updateDataDay: "-", waterClosetCount: 0)
    
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    var archiveURL: URL?
    
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
        setupBlurViews()
        vibrancyViewTable.effect = vibrancyEffectTable
        vibrancyViewButton.effect = vibrancyEffectButton
        blurViewTable.contentView.addSubview(vibrancyViewTable)
        blurViewButton.contentView.addSubview(vibrancyViewButton)
        setupVibrancyViews()
        vibrancyViewTable.contentView.addSubview(tableView)
        vibrancyViewButton.contentView.addSubview(buttonStackView)
        setupViews()
        
        addShadow()

        tableView.delegate = self
        tableView.dataSource = self
        
        mapView.delegate = self
        
        archiveURL = documentDirectory?.appendingPathComponent("SupportingData").appendingPathExtension("plist")
        
        getSupportingData()
        getWCfromDefaults()
        if waterClosetArray.isEmpty {
            fetchWCfromNetwork()
        }
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func centerLocationTapped(_ sender: UIButton) {
        centerLocation()
    }
    
    @IBAction func updateWCfromNetwork(_ sender: UIButton) {
        activityIndicator.startAnimating()
        fetchWCfromNetwork()
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



