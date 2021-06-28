//
//  NetworkManager.swift
//  apiApp
//
//  Created by Apple on 27.06.2021.
//

import Foundation

class NetworkManager {
    class func fetchWCfromNetwork(completion: @escaping ([WaterClosetData]?, Error?) -> ()) {
        guard let url = URL(string: "https://apidata.mos.ru/v1/datasets/842/rows/?api_key=\(apiKey)") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                guard let data = data,
                      let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode),
                      error == nil else {
                    completion(nil, error)
                    DispatchQueue.main.async {
                        AlertManager.showOkAlert(title: "Ошибка",
                                                 message: "Не удалось получить данные")
                    }
                    return
                }
                let waterClosetArray = try JSONDecoder().decode([WaterClosetData].self, from: data)
                completion(waterClosetArray, nil)
                StorageManager.shared.saveWCfromNetwork(waterClosetArray: waterClosetArray)
            } catch {
                print("\n Failure: \(error.localizedDescription)")
                completion(nil, error)
                DispatchQueue.main.async {
                    AlertManager.showOkAlert(title: "Ошибка",
                                             message: "Не удалось получить данные")
                }
            }
        }.resume()
    }
}
