//
//  MatchesView.swift
//  Dating App 1
//
//  Created by Karol Jagiełło
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

struct MessagesView: View {
    
    @State var shouldShowNewMessageScreen = false
    
    @State var errorMessage = ""
    @Binding var users : [CurrentUser]
    @Binding var lastMessages : [String: String]
    
    //@StateObject var mv: MessagesViewModel
    @State var shouldShowChat = false
    @State var pickedUser = CurrentUser(data: ["name": "Name"])
    var body: some View {
            ScrollView
        {
            ForEach(users) { user in
                VStack {
                    NavigationLink{
                        ChatView(chatUser: user)
                    } label: {
                        HStack
                        {
                            AsyncImage(url: URL(string: user.imageURL)) { image in
                                image.resizable()
                            } placeholder: {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 64))
                            }
                            .scaledToFill()
                            .frame(width: 64, height: 64)
                            .cornerRadius(64)
                            .overlay(RoundedRectangle(cornerRadius: 64)
                                .stroke(Color(.white), lineWidth: 2))
                            .foregroundColor(Color(.label))
                            VStack(alignment: .leading) {
                                Text("\(user.name) \(user.surname)")
                                    .font(.system(size: 22, weight: .bold))
                                Text("\(lastMessages[user.uid] ?? "")")
                                    .font(.system(size: 15, weight: .thin))
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }.padding(.horizontal, 10)
                            .foregroundColor(Color(.label))
                        
                }
                    Divider()
                }
                
            }
            

        }.overlay(newMessageButton ,alignment: .bottom)
    }
    private var newMessageButton: some View{
        Button {
            shouldShowNewMessageScreen.toggle()
        } label: {
            HStack
            {
                Spacer()
                Text("+ New Message")
                    .font(.system(size: 16, weight: .bold))
                    .lineLimit(1)
                    .frame(minWidth: 270)
                Spacer()
            }.foregroundColor(.white)
                .padding(.vertical)
                .background(K.colors.intensePurple)
                .cornerRadius(32)
                .padding(.horizontal)
                .shadow(radius: 15)
        }
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen)
        {
            NewMessageView()
        }
    }

    
}

struct MatchesView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            //MessagesView()
        }
        
    }
}
