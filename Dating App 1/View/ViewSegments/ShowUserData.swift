//
//  ShowUserData.swift
//  IDAS
//
//  Created by Karol Jagiełło
//

import SwiftUI

struct ShowUserData: View {
    var type: String
    @Binding var data: String
    var fontSize: Int
    
    var body: some View {
        
        HStack(alignment: .top)
        {
            Text("\(type)")
                .font(.system(size: CGFloat(fontSize), weight: .bold))
                .lineLimit(1)
            Text(data)
                .font(.system(size: CGFloat(fontSize), weight: .regular))
            
        }
        
    }
}


struct prepre: View
{
    var type = "Opis:"
    @State var data = "Opis to opis tutaj lorem ipsum pan tadeusz zapiekanka z ziemniakami oraz makaronem"
    var fontSize = 32
    var body: some View
    {
        ShowUserData(type: type, data: $data, fontSize: fontSize)
    }
}

struct ShowUserData_Previews: PreviewProvider {
    
    static var previews: some View {
        prepre()
    }
}
