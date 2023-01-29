//
//  incomingTextMessageView.swift
//  IDAS
//
//  Created by Karol Jagiełło
//

import SwiftUI

struct incomingTextMessageView: View {
    @State var text = ""
    var body: some View {
        HStack {
            HStack {
                Text(text)
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.gray.opacity(0.30))
            .cornerRadius(16)
            Spacer()
        }
        .padding(.horizontal)
        .padding(.top, 4)
    }
}

struct incomingTextMessageView_Previews: PreviewProvider {
    static var previews: some View {
        incomingTextMessageView()
    }
}
