//
//  ToggleRoundButton.swift
//  Braviamote
//
//  Created by Marvin Wagner on 17/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import SwiftUI

struct RoundToggleStyle: ToggleStyle {
    var color: ColorType = .blue
    var size: CGFloat = 0
    let perform: (() -> Void)
    let filled: Bool = false
    
    func makeBody(configuration: Self.Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
            self.perform()
        }) {
            configuration.label
                .padding(25)
                .contentShape(Circle())
                .if(size > 0){
                    $0.frame(width: size, height: size)
                }
        }
        .background(
            ColorfulBackground(isHighlighted: configuration.isOn, shape: Circle(), color: color, filled: false, showLightShadow: true)
        )
    }
}
