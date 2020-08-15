//
//  PowerStatusResponse.swift
//  Braviamote
//
//  Created by Marvin Wagner on 17/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import Foundation

struct PowerStatusResponse: Decodable {
    let id: Int
    let result: [PowerStatusDetailResponse]
    
    var status: PowerStatusType {
        if result.count == 0 {
            return PowerStatusType.error
        }
        if result[0].status == "active" {
            return PowerStatusType.active
        } else if result[0].status == "standby" {
            return PowerStatusType.standBy
        } else {
            return PowerStatusType.error
        }
    }
    
    var statusDesc: String {
        let type = status
        switch type {
        case .active:
            return "Ligada"
        case .standBy:
            return "Desligada"
        default:
            return "Desconectada"
        }
    }
}

struct PowerStatusDetailResponse: Decodable {
    let status: String
}

enum PowerStatusType {
    case active
    case standBy
    case error
}
