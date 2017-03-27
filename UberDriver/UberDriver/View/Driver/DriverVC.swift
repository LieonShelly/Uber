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
    fileprivate var driverVM: DriverViewModel = DriverViewModel()
    fileprivate var acceptedUber: Bool = false
    fileprivate var driverCancleUber: Bool = false
    @IBAction func cancleUberAction(_ sender: Any) {
        if acceptedUber {
            driverCancleUber = true
            acceptUberBtn.isHidden = true
            driverVM.cancleUberForDriver()

        }
    }
    
    @IBAction func logout(_ sender: Any) {
        if authVM.isLogout {
            navigationController?.dismiss(animated: true, completion: nil)
        } else {
            show(title: "logout faild", message: "logout faild, please try again")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       setupDriver()
    }
}

extension DriverVC {
    fileprivate  func setupDriver() {
        driverVM.observeMessageForDriver { (latitude, longitude) in
            if !self.acceptedUber {
                self.show(title: "Uber Request", message: "You have request for an uber request at this location Lat: \(latitude), long: \(longitude)", confirmAction: { _ in
                    self.acceptedUber = true
                    self.acceptUberBtn.isHidden = false
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
        }
    }
}
