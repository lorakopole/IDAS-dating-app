//
//  OvalTextFieldStyle.swift
//  Dating App 1
//
//  Created by Karol Jagiełło
//

import SwiftUI

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(Color.white)
            .cornerRadius(20)
    }
}
