//
//  1.swift
//  apiApp
//
//  Created by Apple on 14.01.2021.
//


import UIKit

extension ViewController {
    func fetchWCfromNetwork() {
        guard let url = URL(string: "https://apidata.mos.ru/v1/datasets/842/rows/?api_key=\(apiKey)") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                guard let data = data,
                      let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode),
                      error == nil else {
                    DispatchQueue.main.async {
                        self.activityIndicator.stopAnimating()
                        self.showOkAlert(title: "Ошибка", message: "Не удалось получить данные")
                    }
                    return
                }
                self.waterClosetArray = try JSONDecoder().decode([WaterClosetData].self, from: data)
                self.saveWCinDefaults()
                self.saveSupportingData()
                self.updateView()
            } catch {
                print("\n Failure: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.showOkAlert(title: "Ошибка", message: "Не удалось получить данные")
                }
            }
        }.resume()
    }
}

