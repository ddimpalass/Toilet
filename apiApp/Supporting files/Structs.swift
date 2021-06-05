//
//  Structs.swift
//  apiApp
//
//  Created by Apple on 20.01.2021.
//

struct SupportData: Codable {
    var updateDataDay: String
    var waterClosetCount: Int
    
    init(updateDataDay: String, waterClosetCount: Int) {
        self.updateDataDay = updateDataDay
        self.waterClosetCount = waterClosetCount
    }
}
