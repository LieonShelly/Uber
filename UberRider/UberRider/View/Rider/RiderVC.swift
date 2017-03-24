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
    @IBOutlet fileprivate weak var map: MKMapView!
    private var authVM: AuthViewModel = AuthViewModel()
    fileprivate var locationManager: CLLocationManager = CLLocationManager()
    fileprivate var riderLocation: CLLocationCoordinate2D?
    fileprivate lazy var riderVM: RiderViewModel = RiderViewModel()
    @IBAction func logout(_ sender: Any) {
        if authVM.isLogout {
           navigationController?.dismiss(animated: true, completion: nil)
        } else {
            show(title: "logout faild", message: "logout faild, please try again")
        }
    }

    @IBAction func callDriverAction(_ sender: Any) {
        if let location = riderLocation {
            riderVM.requestUber(latitude: location.latitude, longitude: location.longitude)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap()
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
    }
}
