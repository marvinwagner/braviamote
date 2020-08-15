//
//  ContentView.swift
//  Braviamote
//
//  Created by Marvin Wagner on 16/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import SwiftUI

class UserDefaultsManager: ObservableObject {
    @Published var name: String = UserDefaults.standard.string(forKey: "name") ?? "" {
        didSet { UserDefaults.standard.set(self.name, forKey: "name") }
    }
    
    @Published var ipAddress: String = UserDefaults.standard.string(forKey: "ipAddress") ?? "" {
        didSet { UserDefaults.standard.set(self.ipAddress, forKey: "ipAddress") }
    }
    
    @Published var macAddress: String = UserDefaults.standard.string(forKey: "macAddress") ?? "" {
        didSet { UserDefaults.standard.set(self.macAddress, forKey: "macAddress") }
    }
}
//isConnected
struct StatusLight: View {
    var color: Color
    
    var body: some View {
        Circle()
            .fill(color)
            .shadow(color: color, radius: 5, x: 0, y: 0)
            .frame(width: 10, height: 10)
    }
}

struct Visor: View {
    @ObservedObject var tv : TVControllerManagement
    @ObservedObject var userDefaultsManager = UserDefaultsManager()
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                if (userDefaultsManager.name != "") {
                    Text(userDefaultsManager.name).font(.subheadline)
                } else {
                    Text("No TV selected")
                }
                if (tv.isConnected) {
                    StatusLight(color: Color.green)
                } else {
                    StatusLight(color: Color.red)
                }
                
            }
            Text(self.tv.volumeDescription)
           
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.gray).frame(width: 230)
                .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
                .shadow(color: Color.gray.opacity(0.3), radius: 10, x: -10, y: -10)
            
        )
        .onAppear {
            self.tv.checkPowerStatus()
            self.tv.checkVolumeInfo()
        }
    }
}

struct TVControllerView: View {
    @State var showingNetwork = false
    
    @ObservedObject var tv = TVControllerManagement()

    var body: some View {
        ZStack {
            LinearGradient(Color.darkStart, Color.darkEnd)

            VStack(spacing: 20) {
                HStack(spacing: 20) {

                    Visor(tv: tv).frame(width: 230)
                    
//                    Spacer(minLength: 20)
                    
                    
                    Toggle(isOn: $tv.isTurnedOn) {
                        Image(systemName: "power")
                            .foregroundColor(.white)
                    }
                    .toggleStyle(RoundToggleStyle(color: .green, size: 80, perform: {
                        let wantToTurnOn = self.tv.isTurnedOn // pega o valor já atribuido
                        if (wantToTurnOn) {
                            self.tv.turnOn()
                            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (timer) in
                                self.tv.checkPowerStatus()
                            }
                        } else {
                            self.tv.loading = true
                            self.tv.sendCommand(name: "PowerOff")
                            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { (timer) in
                                self.tv.checkPowerStatus()
                            }
                        }
                    }))

                }
                .padding(.horizontal, 40)

                HStack(spacing: 20) {
                    Button(action: {
                        self.tv.sendCommand(name: "Return")
                    }) {
                        Image(systemName: "return")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(RectButtonStyle(color: .blue, width: 100))

                    
                    Button(action: {
                        self.tv.sendCommand(name: "Home")
                    }) {
                        Image(systemName: "house")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(RectButtonStyle(color: .blue, width: 100))

                    Button(action: {
                        self.tv.sendCommand(name: "Options")
                    }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(RectButtonStyle(color: .blue, width: 100))
                    
                    
                }
                .padding(.horizontal, 40)

                HStack(spacing: 20) {
                                        
                    Button(action: {
                        self.tv.sendCommand(name: "Input")
                    }) {
                        Image(systemName: "square.and.arrow.down")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(RectButtonStyle(color: .blue, width: 100))

                    Button(action: {
                        self.tv.sendCommand(name: "Netflix")
                    }) {
                        Image("netflix")
                            .resizable()
                            .scaledToFill()
                        .frame(width: 25, height: 25)
                    }
                    .buttonStyle(RectButtonStyle(color: .red, width: 100))
                    
                    Button(action: {
                        self.showingNetwork.toggle()
                    }) {
                        Image(systemName: "tv")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(RectButtonStyle(color: .blue, width: 100))
                    .sheet(isPresented: $showingNetwork) {
                        NetworkView(presenting: self.$showingNetwork, tv: self.tv)
                    }
                }
                .padding(.horizontal, 40)

                ZStack {
                    Circle()
                        .fill(LinearGradient(Color.darkEnd, Color.darkStart))
                        .frame(minWidth: 200, idealWidth: 200, maxWidth: 200, minHeight: 200, idealHeight: 200, maxHeight: 200, alignment: .center)


                    VStack(spacing: 25) {
                        Button(action: {
                            self.tv.sendCommand(name: "Up")
                        }) {
                            IconButton(imageSystemName: "chevron.up")
                        }

                        HStack(spacing: 25) {
                            Spacer()
                            Button(action: {
                                self.tv.sendCommand(name: "Left")
                            }) {
                                IconButton(imageSystemName: "chevron.left")
                            }

                            Button(action: {
                                self.tv.sendCommand(name: "Confirm")
                            }) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            }
                            .buttonStyle(RoundedColorButtonStyle(color: .blue, padding: 20))
                            
                            Button(action: {
                                self.tv.sendCommand(name: "Right")
                            }) {
                                IconButton(imageSystemName: "chevron.right")
                            }
                            Spacer()
                        }


                        Button(action: {
                            self.tv.sendCommand(name: "Down")
                        }) {
                            IconButton(imageSystemName: "chevron.down")
                        }
                    }.padding()
                }.frame(alignment: .center)

                HStack(spacing: 20) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 95)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.darkEnd, Color.darkStart]), startPoint: .leading, endPoint: .trailing))
                            .frame(width: 70, height: 190)


                        VStack(spacing: 15) {
                            Button(action: {
                                self.tv.sendCommand(name: "VolumeUp")
                                self.tv.checkVolumeInfo()
                            }) {
                                Image(systemName: "speaker.3.fill")
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(RoundedColorButtonStyle(color: .blue, showLightShadow: false, padding: 25))

                            Text("Vol")
                                .foregroundColor(.offWhite)
                                .font(.system(size: 24))

                            Button(action: {
                                self.tv.sendCommand(name: "VolumeDown")
                                self.tv.checkVolumeInfo()
                            }) {
                                Image(systemName: "speaker.1.fill")
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(RoundedColorButtonStyle(color: .blue, showLightShadow: false, padding: 25))
                        }
                    }

                    VStack(spacing: 20) {
                        HStack(spacing: 20) {
                            Button(action: {
                                self.tv.sendCommand(name: "Play")
                            }) {
                                Image(systemName: "play")
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(RectButtonStyle(color: .blue))

                            Button(action: {
                                self.tv.sendCommand(name: "Pause")
                            }) {
                                Image(systemName: "pause")
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(RectButtonStyle(color: .blue))
                        }
                        
                        HStack(spacing: 20) {
                            Button(action: {
                                self.tv.sendCommand(name: "Rewind")
                            }) {
                                Image(systemName: "backward")
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(RectButtonStyle(color: .blue))

                            Button(action: {
                                self.tv.sendCommand(name: "Forward")
                            }) {
                                Image(systemName: "forward")
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(RectButtonStyle(color: .blue))
                        }
                        
                        Toggle(isOn: $tv.isMuted) {
                            Image(systemName: "speaker.slash.fill")
                                .foregroundColor(.white)
                        }
                        .toggleStyle(RoundToggleStyle(perform: {
                            self.tv.sendCommand(name: "Mute")
                            self.tv.checkVolumeInfo()
                        }))
                    }

                    ZStack {
                        RoundedRectangle(cornerRadius: 95)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.darkEnd, Color.darkStart]), startPoint: .leading, endPoint: .trailing))
                            .frame(width: 70, height: 190)

                        VStack(alignment: .center, spacing: 15) {
                            Button(action: {
                                self.tv.sendCommand(name: "ChannelUp")
                            }) {
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(RoundedColorButtonStyle(color: .blue, showLightShadow: false, padding: 25))

                            Text("Ch")
                                .foregroundColor(.offWhite)
                                .font(.system(size: 24))

                            Button(action: {
                                self.tv.sendCommand(name: "ChannelDown")
                            }) {
                                Image(systemName: "minus")
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(RoundedColorButtonStyle(color: .blue, showLightShadow: false, padding: 25))
                                
                        }
                    }
                }
                .padding(.horizontal, 40)
            }
            .padding(EdgeInsets(top: 40, leading: 0, bottom: 50, trailing: 0))
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TVControllerView().previewDevice("iPhone 7")
//        TVControllerView().previewDevice("iPhone Xr")
//        TVControllerView().previewDevice("iPad Pro (10.5-inch)")
    }
}
