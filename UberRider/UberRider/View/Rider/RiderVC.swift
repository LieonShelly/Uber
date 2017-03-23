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
    @IBOutlet weak var map: MKMapView!
    private var authVM: AuthViewModel = AuthViewModel()
 
    @IBAction func logout(_ sender: Any) {
        if authVM.isLogout {
           navigationController?.dismiss(animated: true, completion: nil)
        } else {
            show(title: "logout faild", message: "logout faild, please try again")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
