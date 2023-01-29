//
//  showProfileView.swift
//  IDAS
//
//  Created by Karol Jagiełło
//


import SwiftUI

struct ShowProfileView: View {
    
    @State var user: CurrentUser
    
    var body: some View {
            ScrollView {
                AsyncImage(url: URL(string: user.imageURL ))
                {
                    image in
                    image.resizable()
                }
            placeholder:
                {
                    Image(systemName: "person.fill")
                        .font(.system(size: 150))
                }
                .scaledToFill()
                .frame(width: 200, height: 200)
                .cornerRadius(64)
                .overlay(RoundedRectangle(cornerRadius: 64)
                    .stroke(Color(.white), lineWidth: 2))
                .foregroundColor(Color.white)
                .padding(.top, 4)
                Group
                {
                    Text("\(user.name) \(user.surname)")
                        .font(.system(size: 28, weight: .bold))
                    ShowUserData(type: "Age:", data: $user.age, fontSize: 24)
                    ShowUserData(type: "Sex:", data: $user.sex, fontSize: 22)
                    ShowUserData(type: "Orientation:", data: $user.orientation, fontSize: 22)
                    ShowUserData(type: "University:", data: $user.university, fontSize: 22)
                    ShowUserData(type: "Fav. Artist:", data: $user.favoriteArtist, fontSize: 22)
                        .padding(.bottom, 10)
                    Text("\(user.description)").font(.system(size: 20, weight: .regular, design: .monospaced))
                }.padding([.bottom,.trailing],8).foregroundColor(Color.white)
            }.padding(20)
                .background {
                    RoundedRectangle(cornerRadius: 20)
                        .frame(minWidth: 350)
                        .foregroundColor(K.colors.intensePurple)
                        .shadow(color: .black, radius: 5)
                }
    }
}

    struct BindingPreview3: View
    {
        @State var currentUser = CurrentUser(data: ["uid": "", "email": "", "imageURL": "", "name": "Start", "surname": "Dating", "birthDate": Date.now, "sex": "", "orientation": "", "description": "Press button to start searching for profiles", "university": "", "favoriteArtist": ""])
        
        var body: some View
        {
            ShowProfileView(user: currentUser)
        }
        
        
    }
    
struct ShowProfileView_Previews: PreviewProvider {
    static var previews: some View {
        BindingPreview1()
    }
}

