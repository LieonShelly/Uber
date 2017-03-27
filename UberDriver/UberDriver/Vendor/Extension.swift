//
//  Extension.swift
//  UberRider
//
//  Created by lieon on 2017/3/23.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit

extension UIViewController {
    func show(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func show(title: String, message: String, confirmAction: @escaping (UIAlertAction) -> Void) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler:confirmAction)
        let cancle = UIAlertAction(title: "Cancle", style: .default, handler:confirmAction)
        alert.addAction(ok)
        alert.addAction(cancle)
        present(alert, animated: true, completion: nil)
    }
}
