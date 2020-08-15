//
//  RectButtonStyle.swift
//  Braviamote
//
//  Created by Marvin Wagner on 17/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import SwiftUI

struct RectColorfulBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S
    let color: ColorType
    var filled = false

    
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
                    .overlay(shape.stroke(LinearGradient(self.getColorStart(), self.getColorEnd()), lineWidth: 2))
                    .shadow(color: Color.darkStart, radius: 10, x: 5, y: 5)
                    .shadow(color: Color.darkEnd, radius: 10, x: -5, y: -5)
            } else if filled {
                shape
                    .fill(LinearGradient(self.getColorStart(), self.getColorEnd()))
                    .overlay(shape.stroke(LinearGradient(self.getColorStart(), self.getColorEnd()), lineWidth: 2))
                    .shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
                    .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
            } else {
                shape
                    .fill(LinearGradient(Color.darkStart, Color.darkEnd))
                    .overlay(shape.stroke(LinearGradient(self.getColorStart(), self.getColorEnd()), lineWidth: 2))
                    .shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
                    .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
            }
        }
    }
}

struct RectButtonStyle: ButtonStyle {
    let color: ColorType
    var filled = false
    var width = CGFloat(70)
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(RoundedRectangle(cornerRadius: 8)).frame(width: width, height: 40)
            .background(
                RectColorfulBackground(isHighlighted: configuration.isPressed, shape: RoundedRectangle(cornerRadius: 8), color: color, filled: filled)
            )
            .animation(nil)
    }
}

struct RectButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TVControllerView().previewDevice("iPhone Xr")
    }
}
