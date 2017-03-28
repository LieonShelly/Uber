//
//  DriverVC.swift
//  UberDriver
//
//  Created by lieon on 2017/3/24.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit
import MapKit

class DriverVC: UIViewController {
    @IBOutlet weak var acceptUberBtn: UIButton!
    @IBOutlet weak var map: MKMapView!
    private var authVM: AuthViewModel = AuthViewModel()
    fileprivate var locationManager: CLLocationManager = CLLocationManager()
    fileprivate var driverVM: DriverViewModel = DriverViewModel()
    fileprivate var acceptedUber: Bool = false
    fileprivate var driverCancleUber: Bool = false
    fileprivate var riderLocation: CLLocationCoordinate2D?
    fileprivate var driverLocation: CLLocationCoordinate2D?
    fileprivate var timer: Timer = Timer()
    
    @IBAction func cancleUberAction(_ sender: Any) {
        if acceptedUber {
            driverCancleUber = true
            acceptUberBtn.isHidden = true
            driverVM.cancleUberForDriver()
            timer.invalidate()
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        if authVM.isLogout {
            if acceptedUber {
                acceptUberBtn.isHidden = true
                driverVM.cancleUberForDriver()
                timer.invalidate()
            }
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            show(title: "logout faild", message: "logout faild, please try again")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        setupDriver()
        updateRiderLocation()
    }
}

extension DriverVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location?.coordinate {
            driverLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            guard let driver = driverLocation else { return  }
            let region = MKCoordinateRegion(center: driver, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            map.setRegion(region, animated: true)
            map.removeAnnotations(map.annotations)
            if let rider = riderLocation {
                if acceptedUber {
                    let riverAnnotation = MKPointAnnotation()
                    riverAnnotation.title = "Rider Annotation"
                    riverAnnotation.coordinate = rider
                    map.addAnnotation(riverAnnotation)
                }
            }
            let annotion = MKPointAnnotation()
            annotion.coordinate = driver
            annotion.title = "Driver Annotation"
            map.addAnnotation(annotion)
         
        }
    }
}


extension DriverVC {
    fileprivate func setupMap() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    fileprivate  func setupDriver() {
        driverVM.observeMessageForDriver { (latitude, longitude) in
            if !self.acceptedUber {
                self.show(title: "Uber Request", message: "You have request for an uber request at this location Lat: \(latitude), long: \(longitude)", confirmAction: { _ in
                    self.acceptedUber = true
                    self.acceptUberBtn.isHidden = false
                    self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.updateDriverLocation), userInfo: nil, repeats: true)
                    self.driverVM.acceptUber(lati: latitude, long: longitude)
                })
            }
        }
        driverVM.riderCancleAction = {
            self.driverVM.cancleUberForDriver()
            self.acceptedUber = false
            self.acceptUberBtn.isHidden = true
            self.show(title: "Uber Cancled", message: "The Uber has cancled ")
        }
        driverVM.driverCancleAction = {
            self.acceptedUber = false
            self.acceptUberBtn.isHidden = true
            self.timer.invalidate()
        }
    }
    
    @objc fileprivate func updateDriverLocation() {
         guard let location = driverLocation else { return  }
        driverVM.updateDriverLocation(lati: location.latitude, long: location.longitude)
    }
    
    fileprivate func updateRiderLocation() {
        driverVM.updateRiderLocation { (lati, long) in
            self.riderLocation = CLLocationCoordinate2D(latitude: lati, longitude: long)
            self.locationManager.startUpdatingLocation()
        }
    }
}
