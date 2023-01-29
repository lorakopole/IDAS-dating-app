//
//  ChatView.swift
//  IDAS
//
//  Created by Karol Jagiełło
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct ChatView: View {
    var chatUser: CurrentUser
    
    @Environment(\.dismiss) private var dismiss
    
    @State var messageText = ""
    
    @State var errorMessage: String = ""
    @State var messages = [Message]()
    @State var listener: ListenerRegistration?
    
    var body: some View {
            VStack
            {
                ScrollViewReader
                { value in

                    ScrollView
                    {

                            ForEach(messages) { msg in
                                VStack
                                {
                                    if msg.fromId == Auth.auth().currentUser?.uid
                                    {
                                        ownTextMessageView(text: msg.text)
                                    }
                                    else
                                    {
                                        incomingTextMessageView(text: msg.text)
                                            
                                    }
                                }.id(msg.id)
                                
                            }
                            .onAppear
                            {
                                value.scrollTo(messages.last?.id)
                            }
                            .onChange(of: messages.count) { _ in
                                value.scrollTo(messages.last?.id)
                            }
                            HStack { Spacer() }
                        }
                    }
                    
                    HStack(spacing: 16){
                        TextField("Message", text: $messageText, axis: .vertical)
                            .lineLimit(5)
                        Button {
                            sendMessage(message: messageText, toId: chatUser.uid)
                            messageText = ""
                        } label: {
                            Text("Send")
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal)
                        .padding(.vertical,8)
                        .background(Color.blue)
                        .cornerRadius(8)
                        
                    }.padding()
            }
            .navigationTitle("\(chatUser.name) \(chatUser.surname)")
            .onAppear
            {
                print("fetchowanie wiadomosci dla uzytkownika \(chatUser.name)")
                fetchMessages(toId: chatUser.uid)
            }
            .onDisappear
        {
            listener?.remove()
            print("Removed")
        }
        }
    
    func sendMessage(message: String, toId: String)
    {
        
        if toId == ""
        {
            print("No reciver ID")
            errorMessage = "No reciver ID"
            return
        }
        let fromId = Auth.auth().currentUser?.uid ?? ""
        if fromId == "" { return }
        let data = ["text": message, "fromId": fromId, "toId": toId, "timestamp": Timestamp()] as [String : Any]
        Firestore.firestore().collection("messages")
            .document(fromId)
            .collection(toId)
            .addDocument(data: data)
        { error in
            if let error = error
            {
                print("Error, Couldnt send message: \(error)")
                self.errorMessage = "Error, Couldnt send message: \(error)"
                return
            }
            print("Message Sended #1")
            self.errorMessage = "Message Sended #1"
            
            Firestore.firestore().collection("messages")
                .document(toId)
                .collection(fromId)
                .addDocument(data: data)
            { error in
                if let error = error
                {
                    print("Error, Couldnt send message: \(error)")
                    self.errorMessage = "Error, Couldnt send message: \(error)"
                    return
                }
                print("Message Sended #2")
                self.errorMessage = "Message Sended #2"
                
                
                Firestore.firestore().collection("dates")
                    .document(fromId)
                    .collection("pickedUsers")
                    .document(toId)
                    .updateData(["wasTexted": true, "timestamp": Timestamp(), "lastMessage": message])
                {
                    error in
                    
                    if let error = error
                    {
                        print("Error, Couldnt save timestamp: \(error)")
                        self.errorMessage = "Error, Couldnt save timestamp: \(error)"
                        return
                    }
                    print("Timestamp #1 updated")
                    self.errorMessage = "Timestamp #1 updated"
                    
                    Firestore.firestore().collection("dates")
                        .document(toId)
                        .collection("pickedUsers")
                        .document(fromId)
                        .updateData(["timestamp": Timestamp(), "lastMessage": message])
                    {
                        error in
                        
                        if let error = error
                        {
                            print("Error, Couldnt save timestamp: \(error)")
                            self.errorMessage = "Error, Couldnt save timestamp: \(error)"
                            return
                        }
                        print("Timestamp #2 updated")
                        self.errorMessage = "Timestamp #2 updated"
                    }
                    
                }
                
            }
            
        }
        

    }
    func fetchMessages(toId: String)
    {
        if toId == ""
        {
            print("No reciver ID")
            errorMessage = "No reciver ID"
            return
        }

        let fromId = Auth.auth().currentUser?.uid ?? ""
        if fromId == ""
        {
            return
        }
        listener = Firestore.firestore().collection("messages")
            .document(fromId)
            .collection(toId)
            .order(by: "timestamp", descending: false)
            .addSnapshotListener{ docsSnapshot, error in
                print("Stworzono Messegowy snapshot")
                if let error = error
                {
                    self.errorMessage = "Couldnt fetch messages: \(error)"
                    print("Couldnt fetch messages: \(error)")
                    return
                }
                docsSnapshot?.documentChanges.forEach({ change in
                    if change.type == .added
                    {
                        let data = change.document.data()
                        self.messages.append(.init(data: data))
                    }
                })
            }
    }
    
}
struct chatViewPrev: View
{
    let chatUser = CurrentUser(data: ["uid": "", "email": "", "imageURL": "", "name": "Start", "surname": "Dating", "birthDate": Date.now, "sex": "", "orientation": "", "description": "Press button to start searching for profiles", "university": "", "favoriteArtist": ""])
    var body: some View
    {
        NavigationView {
            ChatView(chatUser: chatUser)
        }
        
    }
}
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        chatViewPrev()
    }
}
