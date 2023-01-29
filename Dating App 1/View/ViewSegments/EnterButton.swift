//
//  EnterButton.swift
//  Dating App 1
//
//  Created by Karol Jagiełło
//

import SwiftUI

struct EnterButton: ButtonStyle
{
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.all)
                .background(Color.white)
                .foregroundColor(Color.black)
                .clipShape(Capsule())
                .scaleEffect(configuration.isPressed ? 1.2 : 1)
                
    }
}
