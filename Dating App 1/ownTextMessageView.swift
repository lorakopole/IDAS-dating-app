//
//  ownTextMessageView.swift
//  IDAS
//
//  Created by Karol Jagiełło
//

import SwiftUI

struct ownTextMessageView: View {
    
    @State var text = ""
    var body: some View {
        HStack {
            Spacer()
            HStack {
                Text(text)
                    .foregroundColor(.white)
            }
            .padding()
            .background(K.colors.intensePurple)
            .cornerRadius(16)
        }
        .padding(.horizontal)
        .padding(.top, 4)
    }
}

struct ownTextMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ownTextMessageView()
    }
}
