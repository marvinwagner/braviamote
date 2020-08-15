//
//  SonyModel.swift
//  Braviamote
//
//  Created by Marvin Wagner on 25/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import Foundation
import Alamofire

struct Sony: TVModel {
    
    func checkDevice(ip: String, perform: @escaping (String)->Void) {
        let url = "http://\(ip)/sony/system"
        let requestUrl = URL(string: url)!

        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"

        let json: [String: Any] = ["method": "getInterfaceInformation",
                                    "id": 33,
                                    "params": [],
                                    "version": "1.0"]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error took place \(error.localizedDescription)")
                return
            }

            if let data = data {
                if let response = try? JSONDecoder().decode(SystemResponse.self, from: data) {
                    DispatchQueue.main.async {
                        perform(response.modelName)
                    }
                }
            }
        }
        
        task.resume()
    }
}
