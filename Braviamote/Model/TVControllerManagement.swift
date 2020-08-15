//
//  RemoteManagement.swift
//  Braviamote
//
//  Created by Marvin Wagner on 16/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import Foundation
import Alamofire
    
protocol TVModel {
    func checkDevice(ip: String, perform: @escaping (String)->Void)
}

class TVControllerManagement: ObservableObject {

    @Published var loading: Bool = false
    
    @Published var isMuted = false
    @Published var currentVolume: Int = 0
    @Published var volumeDescription: String = ""
    
    @Published var isTurnedOn = false
    @Published var powerStatus: String = ""
    
    @Published var isConnected = false
    
    
    func validateIp() -> Bool {
        return UserDefaults.standard.string(forKey: "ipAddress") ?? ""  != ""
    }
    
    func turnOn() {
        let computer = Awake.Device(MAC: "3c:77:e6:ad:2f:93", BroadcastAddr: "192.168.15.2", Port: 9)
        if let error = Awake.target(device: computer) {
            print(error.localizedDescription)
        }
    }
    
    func sendCommand(name: String) {
        if validateIp(), let commandCode = commands[name] {
            // Prepare URL
            let url = URL(string: "http://\(UserDefaults.standard.string(forKey: "ipAddress") ?? "")/sony/IRCC")
            guard let requestUrl = url else { fatalError() }
            // Prepare URL Request Object
            var request = URLRequest(url: requestUrl)
            request.httpMethod = "POST"
             
            // HTTP Request Parameters which will be sent in HTTP Request Body
            let body = "<?xml version=\"1.0\"?><s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><s:Body><u:X_SendIRCC xmlns:u=\"urn:schemas-sony-com:service:IRCC:1\"><IRCCCode>\(commandCode)</IRCCCode></u:X_SendIRCC></s:Body></s:Envelope>"
            let postString = body;
            // Set HTTP Request Body
            request.httpBody = postString.data(using: String.Encoding.utf8);
            
            let headers = HTTPHeaders(dictionaryLiteral: ("Content-Type", "text/xml; charset=UTF-8"), ("X-Auth-PSK", "0000"), ("SOAPACTION", "\"urn:schemas-sony-com:service:IRCC:1#X_SendIRCC\""))
            request.headers = headers
            // Perform HTTP Request
            loading = true
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    self.loading = false
                }
                
                // Check for Error
                if let error = error {
                    print("Error took place \(error)")
                    return
                }
         
                DispatchQueue.main.async {
                    self.isConnected = true
                }
            }
            task.resume()
        }
    }

    func checkVolumeInfo() {
        if !validateIp() {
            return
        }

        let baseUrl = "http://\(UserDefaults.standard.string(forKey: "ipAddress") ?? "")/sony/audio"
        let requestUrl = URL(string: baseUrl)!
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let json: [String: Any] = ["method": "getVolumeInformation",
                                    "id": 33,
                                    "params": [],
                                    "version": "1.0"]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        // Set HTTP Request Body
        request.httpBody = jsonData

        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }

            // Convert HTTP Response Data to a String
            if let data = data {
                let result = try! JSONDecoder().decode(VolumeResponse.self, from: data)
                DispatchQueue.main.async {
                    if let speaker = result.speaker {
                        self.isMuted = speaker.mute
                        self.currentVolume = speaker.volume
                        self.volumeDescription = "Vol: \(speaker.volume). \(speaker.mute ? "*Muted*" : "")"
                    }
                    self.isConnected = true
                }
            }
        }
        task.resume()
    }

    func checkPowerStatus() {
        if !validateIp() {
            return
        }
        
        loading = true
        
        let baseUrl = "http://\(UserDefaults.standard.string(forKey: "ipAddress") ?? "")/sony/system"
        let requestUrl = URL(string: baseUrl)!
        // Prepare URL Request Object
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "POST"
         
        // HTTP Request Parameters which will be sent in HTTP Request Body
        let json: [String: Any] = ["method": "getPowerStatus",
                                    "id": 50,
                                    "params": [],
                                    "version": "1.0"]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        // Set HTTP Request Body
        request.httpBody = jsonData

        // Perform HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check for Error
            if let error = error {
                print("Error took place \(error)")
                return
            }

            // Convert HTTP Response Data to a String
            if let data = data {
                let result = try! JSONDecoder().decode(PowerStatusResponse.self, from: data)
                DispatchQueue.main.async {
                    self.loading = false
                    if result.status == .active {
                        self.isTurnedOn = true
                    } else {
                        self.isTurnedOn = false
                    }
                    self.powerStatus = result.statusDesc

                    self.isConnected = true
                }
            }
        }
        task.resume()
    }
    
    private func fetch(url: String, callback: @escaping (Data?, URLResponse?, Error?) -> Void) {
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: callback)
            task.resume()
        }
    }
    
    
    let commands = ["hdmi1": "AAAAAgAAABoAAABaAw==",
    "hdmi2": "AAAAAgAAABoAAABbAw==",
    "hdmi3": "AAAAAgAAABoAAABcAw==",
    "hdmi4": "AAAAAgAAABoAAABdAw==",
    "PowerOff": "AAAAAQAAAAEAAAAvAw==",
    "Input": "AAAAAQAAAAEAAAAlAw==",
    "GGuide": "AAAAAQAAAAEAAAAOAw==",
    "EPG": "AAAAAgAAAKQAAABbAw==",
    "Favorites": "AAAAAgAAAHcAAAB2Aw==",
    "Display": "AAAAAQAAAAEAAAA6Aw==",
    "Home": "AAAAAQAAAAEAAABgAw==",
    "Options": "AAAAAgAAAJcAAAA2Aw==",
    "Return": "AAAAAgAAAJcAAAAjAw==",
    "Up": "AAAAAQAAAAEAAAB0Aw==",
    "Down": "AAAAAQAAAAEAAAB1Aw==",
    "Right": "AAAAAQAAAAEAAAAzAw==",
    "Left": "AAAAAQAAAAEAAAA0Aw==",
    "Confirm": "AAAAAQAAAAEAAABlAw==",
    "Red": "AAAAAgAAAJcAAAAlAw==",
    "Green": "AAAAAgAAAJcAAAAmAw==",
    "Yellow": "AAAAAgAAAJcAAAAnAw==",
    "Blue": "AAAAAgAAAJcAAAAkAw==",
    "Num1": "AAAAAQAAAAEAAAAAAw==",
    "Num2": "AAAAAQAAAAEAAAABAw==",
    "Num3": "AAAAAQAAAAEAAAACAw==",
    "Num4": "AAAAAQAAAAEAAAADAw==",
    "Num5": "AAAAAQAAAAEAAAAEAw==",
    "Num6": "AAAAAQAAAAEAAAAFAw==",
    "Num7": "AAAAAQAAAAEAAAAGAw==",
    "Num8": "AAAAAQAAAAEAAAAHAw==",
    "Num9": "AAAAAQAAAAEAAAAIAw==",
    "Num0": "AAAAAQAAAAEAAAAJAw==",
    "Num11": "AAAAAQAAAAEAAAAKAw==",
    "Num12": "AAAAAQAAAAEAAAALAw==",
    "VolumeUp": "AAAAAQAAAAEAAAASAw==",
    "VolumeDown": "AAAAAQAAAAEAAAATAw==",
    "Mute": "AAAAAQAAAAEAAAAUAw==",
    "ChannelUp": "AAAAAQAAAAEAAAAQAw==",
    "ChannelDown": "AAAAAQAAAAEAAAARAw==",
    "SubTitle": "AAAAAgAAAJcAAAAoAw==",
    "ClosedCaption": "AAAAAgAAAKQAAAAQAw==",
    "Enter": "AAAAAQAAAAEAAAALAw==",
    "DOT": "AAAAAgAAAJcAAAAdAw==",
    "Analog": "AAAAAgAAAHcAAAANAw==",
    "Teletext": "AAAAAQAAAAEAAAA/Aw=",
    "Exit": "AAAAAQAAAAEAAABjAw==",
    "Analog2": "AAAAAQAAAAEAAAA4Aw==",
    "Digital": "AAAAAgAAAJcAAAAyAw==",
    "BS": "AAAAAgAAAJcAAAAsAw==",
    "CS": "AAAAAgAAAJcAAAArAw==",
    "BSCS": "AAAAAgAAAJcAAAAQAw==",
    "Ddata": "AAAAAgAAAJcAAAAVAw==",
    "PicOff": "AAAAAQAAAAEAAAA+Aw=",
    "Tv_Radio": "AAAAAgAAABoAAABXAw==",
    "Theater": "AAAAAgAAAHcAAABgAw==",
    "SEN": "AAAAAgAAABoAAAB9Aw==",
    "InternetWidgets": "AAAAAgAAABoAAAB6Aw==",
    "InternetVideo": "AAAAAgAAABoAAAB5Aw==",
    "Netflix": "AAAAAgAAABoAAAB8Aw==",
    "SceneSelect": "AAAAAgAAABoAAAB4Aw==",
    "Mode3D": "AAAAAgAAAHcAAABNAw==",
    "iManual": "AAAAAgAAABoAAAB7Aw==",
    "Audio": "AAAAAQAAAAEAAAAXAw==",
    "Wide": "AAAAAgAAAKQAAAA9Aw==",
    "Jump": "AAAAAQAAAAEAAAA7Aw==",
    "PAP": "AAAAAgAAAKQAAAB3Aw==",
    "MyEPG": "AAAAAgAAAHcAAABrAw==",
    "ProgramDescription": "AAAAAgAAAJcAAAAWAw==",
    "WriteChapter": "AAAAAgAAAHcAAABsAw==",
    "TrackID": "AAAAAgAAABoAAAB+Aw=",
    "TenKey": "AAAAAgAAAJcAAAAMAw==",
    "AppliCast": "AAAAAgAAABoAAABvAw==",
    "acTVila": "AAAAAgAAABoAAAByAw==",
    "DeleteVideo": "AAAAAgAAAHcAAAAfAw==",
    "PhotoFrame": "AAAAAgAAABoAAABVAw==",
    "TvPause": "AAAAAgAAABoAAABnAw==",
    "KeyPad": "AAAAAgAAABoAAAB1Aw==",
    "Media": "AAAAAgAAAJcAAAA4Aw==",
    "SyncMenu": "AAAAAgAAABoAAABYAw==",
    "Forward": "AAAAAgAAAJcAAAAcAw==",
    "Play": "AAAAAgAAAJcAAAAaAw==",
    "Rewind": "AAAAAgAAAJcAAAAbAw==",
    "Prev": "AAAAAgAAAJcAAAA8Aw==",
    "Stop": "AAAAAgAAAJcAAAAYAw==",
    "Next": "AAAAAgAAAJcAAAA9Aw==",
    "Rec": "AAAAAgAAAJcAAAAgAw==",
    "Pause": "AAAAAgAAAJcAAAAZAw==",
    "Eject": "AAAAAgAAAJcAAABIAw==",
    "FlashPlus": "AAAAAgAAAJcAAAB4Aw==",
    "FlashMinus": "AAAAAgAAAJcAAAB5Aw==",
    "TopMenu": "AAAAAgAAABoAAABgAw==",
    "PopUpMenu": "AAAAAgAAABoAAABhAw==",
    "RakurakuStart": "AAAAAgAAAHcAAABqAw==",
    "OneTouchTimeRec": "AAAAAgAAABoAAABkAw==",
    "OneTouchView": "AAAAAgAAABoAAABlAw==",
    "OneTouchRec": "AAAAAgAAABoAAABiAw==",
    "OneTouchStop": "AAAAAgAAABoAAABjAw="]
    
}
