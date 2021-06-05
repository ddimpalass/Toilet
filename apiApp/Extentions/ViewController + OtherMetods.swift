//
//  9.swift
//  apiApp
//
//  Created by Дмитрий on 17.01.2021.
//

import UIKit

extension ViewController {
    func showOkAlert(title: String?, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }

    func getCurrentDay() -> Int {
        let date = Date()
        let dateFormatter = DateFormatter()
        return dateFormatter.calendar.component(.weekday, from: date)
    }
    
    func getUpdateSupportData(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        supportData.updateDataDay = dateFormatter.string(from: date)
        supportData.waterClosetCount = waterClosetArray.count
        DispatchQueue.main.async {
            self.showOkAlert(title: nil, message: "Данные обновлены")
        }
    }
    
    func updateView(){
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.addPoints()
            self.activityIndicator.stopAnimating()
            self.centerLocation()
        }
    }
}
