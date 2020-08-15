//
//  Extensions.swift
//  Braviamote
//
//  Created by Marvin Wagner on 16/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import SwiftUI

extension Color {
    static let offWhite = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)

    static let darkStart = Color(red: 70 / 255, green: 80 / 255, blue: 90 / 255)
    static let darkEnd = Color(red: 34 / 255, green: 43 / 255, blue: 52 / 255)

    static let blueStart = Color(red: 60 / 255, green: 160 / 255, blue: 240 / 255)
    static let blueEnd = Color(red: 30 / 255, green: 80 / 255, blue: 120 / 255)
    
    static let greenStart = Color(red: 46 / 255, green: 204 / 255, blue: 113 / 255)
    static let greenEnd = Color(red: 39 / 255, green: 174 / 255, blue: 96 / 255)
    
    static let redStart = Color(red: 255 / 255, green: 0 / 255, blue: 33 / 255)
    static let redEnd = Color(red: 170 / 255, green: 1 / 255, blue: 26 / 255)
    
    
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

extension View {
    func `if`<Content: View>(_ conditional: Bool, content: (Self) -> Content) -> some View {
        if conditional {
            return AnyView(content(self))
        } else {
            return AnyView(self)
        }
    }    
}
