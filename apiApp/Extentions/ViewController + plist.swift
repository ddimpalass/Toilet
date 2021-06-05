//
//  12.swift
//  apiApp
//
//  Created by Apple on 20.01.2021.
//

import UIKit

extension ViewController {
    func saveSupportingData(){
        self.getUpdateSupportData()
        guard let data = try? PropertyListEncoder().encode(supportData) else { return }
        try? data.write(to: archiveURL!, options: .noFileProtection)
    }
    
    func getSupportingData(){
        guard let data = try? Data(contentsOf: archiveURL!) else { return }
        guard let supportDataDecoder = try? PropertyListDecoder().decode(SupportData.self, from: data) else { return }
        supportData = supportDataDecoder
    }
}
