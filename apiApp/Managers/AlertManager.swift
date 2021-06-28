//
//  AlertManager.swift
//  apiApp
//
//  Created by Apple on 27.06.2021.
//

import UIKit

class AlertManager {
    class func showOkAlert(title: String?, message: String) {
        let rootViewController = UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        rootViewController?.present(alert, animated: true)
    }
}
