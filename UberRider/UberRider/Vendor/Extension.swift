//
//  Extension.swift
//  UberRider
//
//  Created by lieon on 2017/3/23.
//  Copyright © 2017年 ChangHongCloudTechService. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func findVC<T: UIViewController>(storyboardName name: String, identifier storyboardID: String? = nil) -> T  {
        if storyboardID == nil {
            guard let destVC = UIStoryboard(name: name, bundle: nil).instantiateInitialViewController() as? T else {  fatalError("No named: \(name) storyboard") }
            return destVC
        }
         guard let id = storyboardID, let destVC = UIStoryboard(name: name, bundle: nil).instantiateViewController(withIdentifier: id) as? T else {  fatalError("No named: \(name) storyboard") }
        return destVC
    }
}

extension UIViewController {
    func show(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController: VCNameReusable {}

extension UIView: ViewNameReusable {}

extension String {
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
}

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(for indexPath: IndexPath) -> T where T: ViewNameReusable {
         guard let cell = dequeueReusableCell(withIdentifier: T.identifier, for: indexPath) as? T else { fatalError("No named:\(T.identifier) cell find") }
        return cell
    }
}
