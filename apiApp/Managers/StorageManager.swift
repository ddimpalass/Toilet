//
//  StorageManager.swift
//  apiApp
//
//  Created by Apple on 27.06.2021.
//

import Foundation

class StorageManager {
    static var shared = StorageManager()
    
    var waterClosetArray: [WaterClosetData] = []
    
    let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    lazy var archiveURL: URL? = documentDirectory?
        .appendingPathComponent("SupportingData")
        .appendingPathExtension("plist")
    let defaults = UserDefaults.standard
    var supportData: SupportData = SupportData(updateDataDay: "-", waterClosetCount: 0)
    
    func saveWCinDefaults(){
        var index = 0
        for wc in waterClosetArray {
            if let encoded = try? JSONEncoder().encode(wc) {
                self.defaults.set(encoded, forKey: "SavedWC\(index)")
            }
            index += 1
        }
    }
    
    func getUpdateSupportData(){
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.YYYY"
        supportData.updateDataDay = dateFormatter.string(from: date)
        supportData.waterClosetCount = waterClosetArray.count
    }
    
    func saveSupportingDataInPlist(){
        guard let data = try? PropertyListEncoder().encode(supportData) else { return }
        guard let archiveURL = archiveURL else { return }
        try? data.write(to: archiveURL, options: .noFileProtection)
    }
    
    func getWCfromDefaults(){
        waterClosetArray.removeAll()
        for index in 0..<supportData.waterClosetCount {
            if let savedWC = defaults.object(forKey: "SavedWC\(index)") as? Data {
                if let loadedWC = try? JSONDecoder().decode(WaterClosetData.self, from: savedWC) {
                    waterClosetArray.append(loadedWC)
                }
            }
        }
        guard !waterClosetArray.isEmpty else { return }
        DispatchQueue.main.async {
            AlertManager.showOkAlert(title: nil,
                                     message: "Последний раз данные обновлялись: \(self.supportData.updateDataDay)")
        }
    }
    
    func getSupportingDataFromPlist(){
        guard let archiveURL = archiveURL else { return }
        guard let data = try? Data(contentsOf: archiveURL) else { return }
        guard let supportDataDecoder = try? PropertyListDecoder().decode(SupportData.self, from: data) else { return }
        supportData = supportDataDecoder
    }
    
    func getWCfromStorage(completion: @escaping ([WaterClosetData]?) -> ()) {
        getSupportingDataFromPlist()
        getWCfromDefaults()
        completion(waterClosetArray)
    }
    
    func saveWCfromNetwork(waterClosetArray: [WaterClosetData]) {
        self.waterClosetArray = waterClosetArray
        saveWCinDefaults()
        getUpdateSupportData()
        saveSupportingDataInPlist()
        DispatchQueue.main.async {
            AlertManager.showOkAlert(title: nil, message: "Данные обновлены")
        }
    }
    
    private init(){}
}
