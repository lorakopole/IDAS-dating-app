//
//  LoginView.swift
//  Dating App 1
//
//  Created by Karol Jagiełło
//

import SwiftUI
import FirebaseAuth


struct LoginView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    
    let didCompleteLoginProces: () -> ()
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
            VStack
            {
                    VStack{
                        Spacer()
                        Text("Log in to your IDAS account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.all)
                            .frame(height: 200.0)
                        Spacer()
                        Group{
                            TextField("Email", text: $email).textFieldStyle(OvalTextFieldStyle()).padding(.horizontal)
                            SecureField("Password", text: $password).textFieldStyle(OvalTextFieldStyle()).padding(.horizontal)
                        }.foregroundColor(Color.black)
                        Button(action: {
                            //RegisterAcountView(name: "Karol", surname: "Jagiello", sex: "male", orientation: "female", Description: "cos tam", university: "PWR", favoriteArtist: "The Weeknd")
                            logIn()
                        }, label: {
                                HStack {
                                    Text("Log in")
                                        .fontWeight(.semibold)
                                    Image(systemName: "arrow.right.circle.fill")
                            }
                            }).buttonStyle(EnterButton())
                        Text(self.errorMessage).foregroundColor(Color(.red))
                        Spacer()
                    }
                    .adaptsToKeyboard()
                }
            .background
            {
            Color(red: 0.61, green: 0.35, blue: 0.71, opacity: 1.00).edgesIgnoringSafeArea(.all)
            Image("idas").resizable().aspectRatio(contentMode: .fit).opacity(0.3)
            }
                .ignoresSafeArea()
                    .navigationBarBackButtonHidden(true)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            
                            Text("Back to main View")
                                .foregroundColor(.white)
                                .onTapGesture {
                                    dismiss()
                                }
                        }
                    }
    }
    
    private func logIn()
    {
        Auth.auth().signIn(withEmail: email, password: password)
        {
            result, error in
            if let err = error
            {
                self.errorMessage = "Failed to login user: \(err)"
                return
            }
            
            
            self.errorMessage = "Sukces, login user: \(result?.user.uid ?? "")"
            didCompleteLoginProces()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView {
            
        }
    }
}
