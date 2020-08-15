//
//  DeviceCell.swift
//  Braviamote
//
//  Created by Marvin Wagner on 25/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import Foundation

struct Device: Hashable {
    let tvName: String
    let macAddress: String
    let ipAddress: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ipAddress)
    }
}
