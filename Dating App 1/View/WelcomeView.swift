//
//  WelcomeView.swift
//  Dating App 1
//
//  Created by Karol Jagiełło
//

import SwiftUI

struct WelcomeView: View {
    
    let didCompleteAuthProces: () -> ()
    
    
    var body: some View {
        NavigationStack
        {
            ZStack
            {
                Color(red: 0.61, green: 0.35, blue: 0.71, opacity: 1.00).edgesIgnoringSafeArea(.all)
                VStack{
                    Image("idas")
                    Text("IDAS")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("IOS Dating APP using SwiftUI")
                        .font(.subheadline)
                        .fontWeight(/*@START_MENU_TOKEN@*/.light/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.white)
                    NavigationLink
                    {
                        LoginView {
                            didCompleteAuthProces()
                        }
                    } label: {
                        Text("Login to your IDAS account")
                            .fontWeight(.semibold)
                    }
                    .buttonStyle(EnterButton())
                    .padding(.all)
                    NavigationLink {
                        RegisterView(email: "",password: "") {
                            didCompleteAuthProces()
                        }
                    } label: {
                        Text("Create new IDAS account")
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                    }.buttonStyle(EnterButton())
                    
                }
                
            }
            .ignoresSafeArea()
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView {
            
        }
    }
}
