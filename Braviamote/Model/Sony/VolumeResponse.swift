//
//  VolumeResponse.swift
//  Braviamote
//
//  Created by Marvin Wagner on 18/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import Foundation

struct VolumeResponse: Decodable {
    let id: Int
    let result: [[VolumeInfoResponse]]

    var speaker: VolumeInfoResponse? {
        if result.count == 0 || result[0].count == 0 {
            return nil
        }
        let volInfo = result[0].filter { (vol) -> Bool in
            vol.target == "speaker"
        }
        if volInfo.count == 0 {
            return nil
        }
        return volInfo[0]
    }
}

struct VolumeInfoResponse: Decodable {
    let volume: Int
    let minVolume: Int
    let mute: Bool
    let maxVolume: Int
    let target: String // speaker
}
