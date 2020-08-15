//
//  Unwrap.swift
//  Braviamote
//
//  Created by Marvin Wagner on 27/06/20.
//  Copyright © 2020 Marvin Wagner. All rights reserved.
//

import SwiftUI

struct Unwrap<Value, Content: View>: View {
    private let value: Value?
    private let contentProvider: (Value) -> Content

    init(_ value: Value?,
         @ViewBuilder content: @escaping (Value) -> Content) {
        self.value = value
        self.contentProvider = content
    }

    var body: some View {
        value.map(contentProvider)
    }
}
