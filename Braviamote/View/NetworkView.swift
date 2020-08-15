//
//  NetworkView.swift
//  Braviamote
//
//  Created by Marvin Wagner on 25/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import SwiftUI

struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void = { _ in }

    func makeUIViewController(context: UIViewControllerRepresentableContext<NavigationConfigurator>) -> UIViewController {
        UIViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<NavigationConfigurator>) {
        if let nc = uiViewController.navigationController {
            self.configure(nc)
        }
    }

}

struct NetworkView: View {
    @ObservedObject var network = NetworkPresenter()
    @ObservedObject var tv: TVControllerManagement
    
    @Binding var isPresented: Bool
        
    init(presenting: Binding<Bool>, tv: TVControllerManagement) {
        _isPresented = presenting
        self.tv = tv
        // this is not the same as manipulating the proxy directly
        let appearance = UINavigationBarAppearance()

        // this overrides everything you have set up earlier.
        appearance.configureWithTransparentBackground()

        // this only applies to big titles
        appearance.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]
        // this only applies to small titles
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.white
        ]

        //In the following two lines you make sure that you apply the style for good
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance

        // This property is not present on the UINavigationBarAppearance
        // object for some reason and you have to leave it til the end
        UINavigationBar.appearance().tintColor = .white
        UITableView.appearance().backgroundColor = .clear
        UITableViewCell.appearance().backgroundColor = .clear
        
    }

    private func saveData(ipAddress: String, macAddress: String, tvName: String) {
        let defaults = UserDefaults.standard
        defaults.set(ipAddress, forKey: "ipAddress")
        defaults.set(macAddress, forKey: "macAddress")
        defaults.set(tvName, forKey: "name")
    }
    private func dismissAndReload() {
        self.tv.checkPowerStatus()
        self.tv.checkVolumeInfo()
        self.isPresented = false
    }
    
    private func alert(_ device: Device) {
        let alert = UIAlertController(title: "Additional feature", message: "If you like to be able to turn on/off your tv, inform its MAC address", preferredStyle: .alert)
        alert.addTextField() { textField in
            textField.placeholder = "Enter mac address without colon"
        }
        alert.addAction(UIAlertAction(title: "Continue without feature", style: .cancel) { _ in
            self.saveData(ipAddress: device.ipAddress, macAddress: device.macAddress, tvName: device.tvName)
            
            self.dismissAndReload()
        })
        alert.addAction(UIAlertAction(title: "Confirm", style: .default) { _ in
            
            self.saveData(ipAddress: device.ipAddress, macAddress: alert.textFields?.first?.text ?? "", tvName: device.tvName)
            
            self.dismissAndReload()
        })
        showAlert(alert: alert)
    }

    func showAlert(alert: UIAlertController) {
        if let controller = topMostViewController() {
            controller.present(alert, animated: true)
        }
    }

    private func keyWindow() -> UIWindow? {
        return UIApplication.shared.connectedScenes
        .filter {$0.activationState == .foregroundActive}
        .compactMap {$0 as? UIWindowScene}
        .first?.windows.filter {$0.isKeyWindow}.first
    }

    private func topMostViewController() -> UIViewController? {
        guard let rootController = keyWindow()?.rootViewController else {
            return nil
        }
        return topMostViewController(for: rootController)
    }

    private func topMostViewController(for controller: UIViewController) -> UIViewController {
        if let presentedController = controller.presentedViewController {
            return topMostViewController(for: presentedController)
        } else if let navigationController = controller as? UINavigationController {
            guard let topController = navigationController.topViewController else {
                return navigationController
            }
            return topMostViewController(for: topController)
        } else if let tabController = controller as? UITabBarController {
            guard let topController = tabController.selectedViewController else {
                return tabController
            }
            return topMostViewController(for: topController)
        }
        return controller
    }

    var body: some View {
        
        NavigationView {
            ZStack {
                
                LinearGradient(Color.darkStart, Color.darkEnd).edgesIgnoringSafeArea(.all)
                
                
                List {
                    
                    ProgressBar(visible: $network.isScanRunning, value: $network.progressValue).frame(height: 6)
                   
                    
                    ForEach(self.network.connectedDevices, id: \.self) { device in
                        
                        Button(action: {
                            if device.macAddress.contains("00:00:00") {
                                self.alert(device)
                            } else {
                                self.saveData(ipAddress: device.ipAddress, macAddress: device.macAddress, tvName: device.tvName)
                                
                                self.dismissAndReload()
                            }
                        }) {
                            VStack(alignment: .leading) {
                                Text("\(device.tvName)").font(Font.headline)
                                Text("\(device.ipAddress)").font(Font.subheadline)
                                Text("\(device.macAddress)").font(Font.caption)
                            }
                        }
                    }
                }
            }
            .navigationBarHidden(false)
            .navigationBarTitle("Devices", displayMode: .automatic)

            .navigationBarItems(leading: Button(action: {
                self.isPresented = false
            }, label: {
                Image(systemName: "xmark")
                    .aspectRatio(contentMode: .fit)
                    .font(.title).foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }), trailing: Button(action: {
                self.network.scanButtonClicked()
            }, label: {
                Image(systemName: "magnifyingglass")
                    .aspectRatio(contentMode: .fit)
                    .font(.title).foregroundColor(.white)
                    .frame(width: 44, height: 44)
            }))
        }
            
    }
}

struct ProgressBar: View {
    @Binding var visible: Bool
    @Binding var value: Float
    
    var body: some View {
        if (visible) {
            return AnyView(GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                        .opacity(0.3)
                        .foregroundColor(Color(UIColor.systemTeal))
                    
                    Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                        .foregroundColor(Color(UIColor.systemBlue))
                        .animation(.linear)
                }.cornerRadius(45.0)
            })
        } else {
            return AnyView(EmptyView())
        }
    }
}

#if DEBUG
struct NetworkView_Previews: PreviewProvider {
        
    static var previews: some View {
        NetworkView(presenting: .constant(true), tv: TVControllerManagement())
    }
}
#endif
//Button(action: {
//    self.network.scanButtonClicked()
//}) {
//    Text("Verificar")
//}.padding()
