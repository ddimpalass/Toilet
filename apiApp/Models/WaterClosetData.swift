//
//  wcData.swift
//  apiApp
//
//  Created by Apple on 12.01.2021.
//

import Foundation

// MARK: - WaterCloset
struct WaterClosetData: Codable {
    let globalID, number: Int
    let cells: Cells
    var distance: Double?

    enum CodingKeys: String, CodingKey {
        case globalID = "global_id"
        case number = "Number"
        case cells = "Cells"
    }
}

// MARK: - Cells
struct Cells: Codable {
    let globalID: Int
    let balanceHolderName, name, admArea, district: String
    let location: String
    let workingHours: [WorkingHour]
    let geoData: GeoData

    enum CodingKeys: String, CodingKey {
        case globalID = "global_id"
        case balanceHolderName = "BalanceHolderName"
        case name = "Name"
        case admArea = "AdmArea"
        case district = "District"
        case location = "Location"
        case workingHours = "WorkingHours"
        case geoData
    }
    
}

// MARK: - GeoData
struct GeoData: Codable {
    let type: String
    let coordinates: [Double]
}

// MARK: - WorkingHour
struct WorkingHour: Codable {
    let hours, dayOfWeek: String

    enum CodingKeys: String, CodingKey {
        case hours = "Hours"
        case dayOfWeek = "DayOfWeek"
    }
}

