//
//  RegisterTextField.swift
//  IDAS
//
//  Created by Karol Jagiełło
//

import SwiftUI

struct RegisterTextField: View {
    
    var fieldName: String
    @Binding var data: String
    var body: some View {
        HStack
        {
            Text("\(fieldName):")
            TextField("\(fieldName)", text: $data)
                .keyboardType(.namePhonePad)
        }
    }
}

struct prere: View
{
    @State var text: String = "Karol"
    var field = "Name:"
    var body: some View
    {
        RegisterTextField(fieldName: field, data: $text)
    }
}
struct RegisterTextField_Previews: PreviewProvider {
    

    static var previews: some View {
        prere()
    }
}
