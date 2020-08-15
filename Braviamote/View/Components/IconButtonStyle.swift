//
//  IconButtonStyle.swift
//  Braviamote
//
//  Created by Marvin Wagner on 17/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//
import SwiftUI

struct IconButton: View {
    let imageSystemName: String
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.white, .gray]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .mask(Image(systemName: imageSystemName)
            .resizable()
            .aspectRatio(contentMode: .fit)

        ).frame(minWidth: 30, idealWidth: 30, maxWidth: 30, minHeight: 30, idealHeight: 30, maxHeight: 30, alignment: .center)
    }
}

struct IconButtonView_Previews: PreviewProvider {
    static var previews: some View {
        TVControllerView().previewDevice("iPhone Xr")
    }
}
