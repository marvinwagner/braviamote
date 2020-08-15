//
//  ContentView.swift
//  Braviamote
//
//  Created by Marvin Wagner on 16/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import SwiftUI

struct RemoteView: View {
    var tv = RemoteManagement()

    var body: some View {
        ZStack {
            LinearGradient(Color.darkStart, Color.darkEnd)

            VStack(spacing: 40) {
                Button(action: {
                    self.tv.sendCommand(name: "Home")
                }) {
                    Image(systemName: "house.fill")
                        .foregroundColor(.white)
                }
                .buttonStyle(ColorfulButtonStyle(color: .blue))
                
                Button(action: {
                    self.tv.sendCommand(name: "Up")
                }) {
                    Image(systemName: "chevron.up")
                        .foregroundColor(.white)
                }
                .buttonStyle(ColorfulButtonStyle(color: .blue))
                
                HStack {
                    Button(action: {
                        self.tv.sendCommand(name: "Left")
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(ColorfulButtonStyle(color: .blue))
                    
                    Button(action: {
                        self.tv.sendCommand(name: "Confirm")
                    }) {
                        Image(systemName: "checkmark")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(ColorfulButtonStyle(color: .blue))
                    
                    Button(action: {
                        self.tv.sendCommand(name: "Right")
                    }) {
                        Image(systemName: "chevron.right")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(ColorfulButtonStyle(color: .blue))
                }
                
                Button(action: {
                    self.tv.sendCommand(name: "Down")
                }) {
                    Image(systemName: "chevron.down")
                        .foregroundColor(.white)
                }
                .buttonStyle(ColorfulButtonStyle(color: .blue))
                
                
                HStack {
                    Button(action: {
                        self.tv.sendCommand(name: "VolumeUp")
                    }) {
                        Image(systemName: "speaker.1.fill")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(ColorfulButtonStyle(color: .blue))
                    
                    Button(action: {
                        self.tv.sendCommand(name: "VolumeDown")
                    }) {
                        Image(systemName: "speaker.3.fill")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(ColorfulButtonStyle(color: .blue))
                }
                
                
                Button(action: {
                    self.tv.sendCommand(name: "Home")
                }) {
                    Image(systemName: "speaker.slash.fill")
                        .foregroundColor(.white)
                }
                .buttonStyle(ColorfulButtonStyle(color: .blue))
                
                Button(action: {
                    
                }) {
                    Image(systemName: "power")
                        .foregroundColor(.white)
                }
                .buttonStyle(ColorfulButtonStyle(color: .green, filled: true))
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteView().previewDevice("iPhone Xr")
    }
}
