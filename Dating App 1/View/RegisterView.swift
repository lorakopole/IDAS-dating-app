//
//  RegisterView.swift
//  Dating App 1
//
//  Created by Karol Jagiełło
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignInSwift
import GoogleSignIn

struct RegisterView: View {
    
    @State var email: String
    @State var password: String
    @State var errorMessage: String = ""
    
    let didCompleteRegisterProces: () -> ()
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
                VStack
                {
                    VStack{
                        Spacer()
                        Text("Create new IDAS account")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.all)
                            .frame(height: 200.0)
                        Spacer()
                        Group{
                            TextField("Email", text: $email).textFieldStyle(OvalTextFieldStyle()).padding(.horizontal).keyboardType(.emailAddress)
                            SecureField("Password", text: $password).textFieldStyle(OvalTextFieldStyle()).padding(.horizontal)
                        }.foregroundColor(Color.black)
                        Button(action: {
                            CreateNewAccount()
                        }, label: {
                                HStack {
                                    Text("Create new account")
                                        .fontWeight(.semibold)
                                    Image(systemName: "arrow.right.circle.fill")
                            }
                            }).buttonStyle(EnterButton())
                        Text(self.errorMessage).foregroundColor(Color(.red))
                        Spacer()
                    }.adaptsToKeyboard()
                    
                }.background
        {
            
            Color(red: 0.61, green: 0.35, blue: 0.71, opacity: 1.00).edgesIgnoringSafeArea(.all)
            Image("idas").resizable().aspectRatio(contentMode: .fit).opacity(0.3)
        }.ignoresSafeArea()
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
    
    private func CreateNewAccount()
    {
        Auth.auth().createUser(withEmail: email, password: password){
            result, error in
            if let err = error
            {
                self.errorMessage = "Failed to create user: \(err)"
                return
            }
            
            self.errorMessage = "Sukces, created user: \(result?.user.uid ?? "")"
            didCompleteRegisterProces()

        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(email: "123456@student.pwr.edu.pl", password: "123456") {
            
        }
    }
}
