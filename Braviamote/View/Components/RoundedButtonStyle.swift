//
//  ButtonStyle.swift
//  Braviamote
//
//  Created by Marvin Wagner on 16/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import SwiftUI

struct ColorfulBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S
    let color: ColorType
    var filled = false
    var showLightShadow: Bool

    func getColorStart() -> Color {
        switch color {
        case .green:
            return Color.greenStart
        case .red:
            return Color.redStart
        default:
            return Color.blueStart
        }
    }
    
    func getColorEnd() -> Color {
        switch color {
        case .green:
            return Color.greenEnd
        case .red:
            return Color.redEnd
        default:
            return Color.blueEnd
        }
    }
    
    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(self.getColorEnd(), self.getColorStart()))
                    .overlay(shape.stroke(LinearGradient(self.getColorStart(), self.getColorEnd()), lineWidth: 4))
                    
                    .shadow(color: Color.darkEnd, radius: 10, x: -5, y: -5)
                    .if(showLightShadow){
                          $0.shadow(color: Color.darkStart, radius: 10, x: 5, y: 5)
                    }
            } else if filled {
                shape
                    .fill(LinearGradient(self.getColorStart(), self.getColorEnd()))
                    .overlay(shape.stroke(LinearGradient(self.getColorStart(), self.getColorEnd()), lineWidth: 4))
                    .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
                    .if(showLightShadow){
                          $0.shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
                    }
            } else {
                shape
                    .fill(LinearGradient(Color.darkStart, Color.darkEnd))
                    .overlay(shape.stroke(LinearGradient(self.getColorStart(), self.getColorEnd()), lineWidth: 4))
                    .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
                    .if(showLightShadow){
                          $0.shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
                    }
            }
        }
    }
}

enum ColorType {
    case blue
    case green
    case red
}

struct RoundedColorButtonStyle: ButtonStyle {
    let color: ColorType
    var filled = false
    var showLightShadow = true
    var padding: CGFloat = 30
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(padding)
            .contentShape(Circle())
            .background(
                ColorfulBackground(isHighlighted: configuration.isPressed, shape: Circle(), color: color, filled: filled, showLightShadow: showLightShadow)
            )
            .animation(nil)
    }
}

struct RoundButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TVControllerView().previewDevice("iPhone Xr")
    }
}
