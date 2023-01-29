//
//  ProfileView.swift
//  Dating App 1
//
//  Created by Karol Jagiełło
//

import SwiftUI
import FirebaseAuth
struct OwnProfileView: View {
    
    @Environment(\.dismiss) var dismiss

    @Binding var currentUser: CurrentUser
    
    @State var shouldShowSettings = false
    @State var showDataEdit = false
    let fetchUserAfterUpdate: () -> ()
    let signOutProcess: () -> ()
    
    var body: some View {
        VStack
        {
            HStack
            {
                Spacer()
                Button {
                    shouldShowSettings.toggle()
                } label: {
                    Text("Settings")
                    Image(systemName: "gear")
                    
                    
                }.font(.system(size: 20, weight: .heavy))
                    .padding(3).background(content: {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(K.colors.intensePurple)
                    })
                    .foregroundColor(Color.white)
            }
            ProfileView(user: $currentUser).padding(15)
            }
        .fullScreenCover(isPresented: $showDataEdit) {
            
            VStack {
                HStack
                {
                    Button
                    {
                        showDataEdit = false
                    }
                label:
                    {
                        Text("Cancel")
                    }
                    Spacer()
                }
                .padding(10)
                
                PersonalDataFormView(name: currentUser.name, surname: currentUser.surname, birthDate: DateHandler.StringToDate(date: currentUser.birthDate), sex: currentUser.sex, orientation: currentUser.orientation, description: currentUser.description, university: currentUser.university, favoriteArtist: currentUser.favoriteArtist, didCompleteUploadProces: {
                        fetchUserAfterUpdate()
                        showDataEdit = false
                        
                }, justUpdate: true)
            }
            .background(content: {
                K.colors.MainPurple.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
            })
            
        }.padding(10).background {
            K.colors.MainPurple
                .edgesIgnoringSafeArea([.top,.trailing,.leading])
        }.confirmationDialog("Settings", isPresented: $shouldShowSettings, titleVisibility: .visible) {
            
            Button("Edit Personal Data")
            {
                showDataEdit.toggle()
            }
            Button("Show console data //developer")
            {
                print("\(currentUser.name),  \(currentUser.surname), \(currentUser.age), \(currentUser.birthDate)")
            }
            Button("Sign Out", role: .destructive)
            {
                signOutProcess()
                print("handle sign out")
            }
        }
    }
}



struct BindingPreview: View
{
    @State var currentUser = CurrentUser(data: ["uid": "", "email": "", "imageURL": "", "name": "Start", "surname": "Dating", "birthDate": "", "sex": "", "orientation": "", "description": "Press button to start searching for profiles", "university": "", "favoriteArtist": ""])
    
    var body: some View
    {
        OwnProfileView(currentUser: $currentUser) {
        } signOutProcess:
        {
            
        }
    }
    
    
}

struct OwnProfileView_Previews: PreviewProvider {
    

    static var previews: some View {
        BindingPreview()
            
        }
    }
