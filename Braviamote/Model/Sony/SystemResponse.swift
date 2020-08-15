//
//  SystemResponse.swift
//  Braviamote
//
//  Created by Marvin Wagner on 25/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import Foundation

struct SystemResponse: Decodable {
    let id: Int
    let result: [SystemInfoResponse]
    
    var modelName: String {
        return "\(result.first?.productName ?? "Sony") \(result.first?.modelName ?? "???")"
    }
}

struct SystemInfoResponse: Decodable {
    let modelName: String
    let productName: String
}
