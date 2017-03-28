//
//  RiderVC.swift
//  UberRider
//
//  Created by lieon on 2017/3/24.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit
import MapKit

class RiderVC: UIViewController {
  
    @IBOutlet weak var callUberBtn: UIButton!
    
    @IBOutlet fileprivate weak var map: MKMapView!
    private var authVM: AuthViewModel = AuthViewModel()
    fileprivate var locationManager: CLLocationManager = CLLocationManager()
    fileprivate var riderLocation: CLLocationCoordinate2D?
    fileprivate var driverLocation: CLLocationCoordinate2D?
    fileprivate lazy var riderVM: RiderViewModel = RiderViewModel()
    fileprivate var canCallUber: Bool = true
     fileprivate var riderCancledRequest: Bool = false
    fileprivate var timer = Timer()
    @IBAction func logout(_ sender: Any) {
        if authVM.isLogout {
            if !canCallUber {
                riderVM.cancleUber()
                timer.invalidate()
            }
           navigationController?.dismiss(animated: true, completion: nil)
        } else {
            show(title: "logout faild", message: "logout faild, please try again")
        }
    }

    @IBAction func callDriverAction(_ sender: Any) {
        if let location = riderLocation {
            if canCallUber {
                riderVM.requestUber(latitude: location.latitude, longitude: location.longitude)
                timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.updateRiderLocation), userInfo: nil, repeats: true)
            } else {
                riderCancledRequest = true
                riderVM.cancleUber()
                timer.invalidate()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
        observeRider()
        updateDriverLocation()
    }

}

extension RiderVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = manager.location?.coordinate {
            riderLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
             guard let rider = riderLocation else { return  }
            let region = MKCoordinateRegion(center: rider, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            map.setRegion(region, animated: true)
            map.removeAnnotations(map.annotations)
            if let driver = driverLocation  {
                if !canCallUber {
                    let driverAnnotation = MKPointAnnotation()
                    driverAnnotation.coordinate = driver
                    driverAnnotation.title = "Driver An"
                    map.addAnnotation(driverAnnotation)
                }
            }
            let annotion = MKPointAnnotation()
            annotion.coordinate = rider
            annotion.title = "Rider Annotation"
            map.addAnnotation(annotion)
        }
    }
}

extension RiderVC {
    fileprivate func setupMap() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        map.setUserTrackingMode(.none, animated: true)
    }
    
    fileprivate func observeRider() {
        riderVM.oberveMessageForRider { flag in
            if flag == true {
                self.callUberBtn.setTitle("Cancle Uber", for: .normal)
                self.canCallUber = false
            } else {
                self.callUberBtn.setTitle("Call Uber", for: .normal)
                self.canCallUber = true
            }
        }
        riderVM.driverAcceptAction = { (isAccepted, driverName) in
            if !self.riderCancledRequest {
                if isAccepted {
                    self.show(title: "Uber acceped", message: "\(driverName) accepted your request")
                } else {
                    self.riderVM.cancleUber()
                    self.timer.invalidate()
                    self.show(title: "Uber cancled", message: "\(driverName) cancled Uber request")
                }
            }
            self.riderCancledRequest = false 
        }
    }
    
    fileprivate func updateDriverLocation() {
        riderVM.updateDriverLocation { (lati, long) in
            self.driverLocation = CLLocationCoordinate2D(latitude: lati, longitude: long)
            self.locationManager.startUpdatingLocation()
        }
    }
    
   @objc fileprivate func updateRiderLocation() {
        if let location = riderLocation {
            riderVM.updateRiderLocation(lati: location.latitude, long: location.longitude)
        }
    }
}
