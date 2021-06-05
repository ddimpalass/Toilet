//
//  11.swift
//  apiApp
//
//  Created by Apple on 20.01.2021.
//

import UIKit

extension ViewController {
    func saveWCinDefaults(){
        var index = 0
        for wc in waterClosetArray {
            if let encoded = try? JSONEncoder().encode(wc) {
                self.defaults.set(encoded, forKey: "SavedWC\(index)")
            }
            index += 1
        }
    }
    
    func getWCfromDefaults(){
        waterClosetArray.removeAll()
        for index in 0..<supportData.waterClosetCount{
            if let savedWC = defaults.object(forKey: "SavedWC\(index)") as? Data {
                if let loadedWC = try? JSONDecoder().decode(WaterClosetData.self, from: savedWC) {
                    waterClosetArray.append(loadedWC)
                }
            }
        }
        guard !waterClosetArray.isEmpty else { return }
        DispatchQueue.main.async {
            self.showOkAlert(title: nil, message: "Последний раз данные обновлялись: \(self.supportData.updateDataDay)")
        }
        updateView()
    }
}
