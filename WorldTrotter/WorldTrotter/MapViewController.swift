//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by HaroldDavidson on 12/13/19.
//  Copyright © 2019 HaroldDavidson. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let regionInMeters : Double = 10000
    
    // when a view controller is created, view property is nil. Then loadView() runs
    override func loadView() {
        // create a map view
        mapView = MKMapView()
        // set map view at "the" view of this view controller
        view = mapView
        
        // creating a new segmented control and adding it
        let standardString = NSLocalizedString("Standard", comment: "Standard map view")
        let satelliteString = NSLocalizedString("Satellite", comment: "Satellite map view")
        let hybridString = NSLocalizedString("Hybrid", comment: "Hybrid map view")
        let segmentedControl = UISegmentedControl(items: [standardString, satelliteString, hybridString])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        // auto resizing masks come standard to auto size for different screen sizes
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingConstraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        topConstraint.isActive = true
        leadingConstraint.isActive = true
        trailingConstraint.isActive = true
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        // adding centering button
        let centerButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width / 2 - 100, y: 75, width: 50, height: 50))
        centerButton.backgroundColor = .orange
        centerButton.tintColor = .white
        //centerButton.setTitle("Center", for: .normal)
        centerButton.setBackgroundImage(UIImage(named: "target.png"), for: .normal)
        centerButton.addTarget(self, action: #selector(centerViewOnUserLocation), for: .touchUpInside)
        centerButton.layer.cornerRadius = 10
        centerButton.clipsToBounds = true
        self.mapView.addSubview(centerButton)
        
        // adding location cycling button
        let cyclingButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width / 2 + 50, y: 75, width: 50, height: 50))
        cyclingButton.setBackgroundImage(UIImage(named: "pin.jpeg"), for: .normal)
        cyclingButton.backgroundColor = .white
        cyclingButton.layer.cornerRadius = 10
        cyclingButton.clipsToBounds = true
        cyclingButton.addTarget(self, action: #selector(cycleLocations), for: .touchUpInside)
        self.mapView.addSubview(cyclingButton)
    } // end of loadVie
    
    let locations: [CLLocationCoordinate2D] = [CLLocationCoordinate2D(latitude: 45.5051, longitude: 122.6750), CLLocationCoordinate2D(latitude: 39.1200, longitude: 88.5434), CLLocationCoordinate2D(latitude: 40.7128, longitude: 74.0060)]
    let descriptions = [(city: "Portland, OR", desc: "Where I live."), (city: "Effingham, IL", desc: "Where I used to live."), (city: "New York City, NY", desc: "Biggest city in the US")]
    var locationIndex = 0
    
    @objc func cycleLocations() {
        let otherPinRegion = MKCoordinateRegion(center: locations[locationIndex], span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
        self.mapView.setRegion(otherPinRegion, animated: true)
        let pin = customPin(pinTitle: descriptions[locationIndex].0, pinSubtitle: descriptions[locationIndex].1, location: locations[locationIndex])
        
        self.mapView.addAnnotation(pin)
        if(locationIndex == locations.count - 1) {
            locationIndex = 0
        } else {
            locationIndex += 1
        }
        
    }
    
    @objc func mapTypeChanged(_ segControl: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self as? MKMapViewDelegate
        checkLocationServices()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
            turnOnLocationAccessAlert()
        }
    }
    
    // MARK: checking permissions
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .denied:
            turnOnLocationAccessAlert()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            // this is for something like parental controls
            turnOnLocationAccessAlert()
            break
        case .authorizedAlways:
            // not using this option since we don't want this access
            break
        default:
            break
        }
    }
    
    @objc func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func turnOnLocationAccessAlert() {
        // show alert to user to turn on location services
        let alert = UIAlertController(title: "Location Services", message: "Location Services are not turned on or are restricted. Please turn on Location Services on your device or see your device administrator.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
} // end of View Controller

extension MapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

class customPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(pinTitle: String, pinSubtitle: String, location: CLLocationCoordinate2D) {
        self.title = pinTitle
        self.subtitle = pinTitle
        self.coordinate = location
    }
}
