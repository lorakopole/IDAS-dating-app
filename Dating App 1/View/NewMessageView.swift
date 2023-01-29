//
//  NewMessageView.swift
//  IDAS
//
//  Created by Karol Jagiełło
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct NewMessageView: View {
    
    @Environment(\.dismiss) var dismiss
    @State var users = [CurrentUser]()
    @State var errorMessage = ""
    init()
    {
        print("zainicjowano newMessage")
    }
    var body: some View {
        
        NavigationView {
            ScrollView
            {
                ForEach(users) { user in
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
                            Text("\(user.name) \(user.surname)")
                            Spacer()
                        }.padding(.horizontal, 10)
                            .foregroundColor(Color(.label))
                    }

                    Divider()
                }
            }.navigationTitle("New Message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                        }

                    }
                }
        }.onAppear{
            print("NewMessage appear")
            fetchLikedUsers()
        }
    }
    private func fetchLikedUsers()
    {
        self.users.removeAll()
        Firestore.firestore().collection("dates")
            .document(Auth.auth().currentUser?.uid ?? "")
            .collection("pickedUsers")
            .getDocuments { documentsSnapshot, error in
                if let error = error
                {
                    self.errorMessage = "failed to fetch: \(error)"
                    print("failed to fetch: \(error)")
                    return
                }
                self.errorMessage = "Fetched Succesfully"
                
                documentsSnapshot?.documents.forEach({ snapshot in
                    let data = snapshot.data()
                    let userId = data["userId"] as? String ?? ""
                    Firestore.firestore().collection("users").document(userId).getDocument { userSnapshot, err in
                        if let err = err
                                {
                                self.errorMessage = "failed to fetch: \(err)"
                                print("failed to fetch: \(err)")
                                return
                                }
                        guard let userData = userSnapshot?.data() else { return }
                        self.users.append(.init(data: userData))
                    }
                })
            }
    }
}

struct NewMessageView_Previews: PreviewProvider {
    static var previews: some View {
        NewMessageView()
    }
}
