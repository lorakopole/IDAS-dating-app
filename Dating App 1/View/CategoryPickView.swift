//
//  CategoryPickView.swift
//  IDAS
//
//  Created by Karol Jagiełło
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth
struct CategoryPickView: View {
    @State var partyModeOn = false
    @State var errorMessage = ""
    @State var partyUsers = [CurrentUser]()
    @State var alertName = ""
    @State private var showAlert = false
    var body: some View {
        VStack
        {
            Text("Wanna go out tonight?")
                .font(.system(.title))
            ScrollView
            {
                ForEach(partyUsers) { user in
                    NavigationLink{
                        ShowProfileView(user: user)
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
                                .lineLimit(1)
                            Spacer()
                            Button
                            {
                                addUser(uid: user.uid)
                            }
                            
                        label:
                            {
                                Text("add")
                                    .foregroundColor(Color.white)
                                    .padding(.all)
                                    .background(Color.green)
                                    .cornerRadius(32)
                                    .padding(.horizontal)
                                    .shadow(radius: 15)
                            }.alert(alertName, isPresented: $showAlert) {
                                Button("OK", role: .cancel)
                                {
                                    
                                }
                            }
                            
                        }.padding(.horizontal, 10)
                            .foregroundColor(Color(.label))
                    }

                    Divider()
                }
            }

            bottomBar
            
        }.navigationTitle("Wanna go out tonight?")
            .onAppear
        {
            fetchPartyUsers()
        }

    }
    
    private var bottomBar: some View
    {
        HStack
        {
            Button
            {
                partyModeOn = false
                updatePartyMode(isOn: false)
            }
        label:
            {
                Text("Not really...")
                    .foregroundColor(Color.white)
                    .padding(.all)
                    .background(Color.red)
                    .cornerRadius(32)
                    .padding(.horizontal)
                    .shadow(radius: 15)
            }
            Spacer()
            VStack(alignment: .center)
            {
                Toggle("", isOn: $partyModeOn).labelsHidden()
                    .onChange(of: partyModeOn) { value in
                        updatePartyMode(isOn: value)
                    }
            }
            
            Spacer()
            Button
            {
                partyModeOn = true
                updatePartyMode(isOn: true)
            }
        label:
            {
                Text("Sure!")
                    .foregroundColor(Color.white)
                    .padding(.all)
                    .background(Color.green)
                    .cornerRadius(32)
                    .padding(.horizontal)
                    .shadow(radius: 15)
            }
        }
    }
    private func fetchPartyUsers()
    {
        partyUsers.removeAll()
        let userId = Auth.auth().currentUser?.uid ?? ""
        if userId == ""
        {
            print("no user logged")
            return
        }
        Firestore.firestore().collection("users").whereField("partyMode", isEqualTo: true).whereField(FieldPath.documentID(), isNotEqualTo: Auth.auth().currentUser?.uid ?? "").getDocuments { docSnapshot, error in
            if let error = error
            {
                self.errorMessage = "failed to fetch: \(error)"
                print("failed to fetch: \(error)")
                return
            }
            docSnapshot?.documents.forEach({ doc in
                let data = doc.data()
                partyUsers.append(.init(data: data))
            })
        }
        Firestore.firestore().collection("users").document(userId).getDocument { docSnapshot, error in
            if let error = error
            {
                self.errorMessage = "failed to get party mode: \(error)"
                print("failed to get party mode: \(error)")
                return
            }
            let data = docSnapshot?.data()
            guard let partyMode = data?["partyMode"] as? Bool
                    else
            {
                print("no party mode")
                partyModeOn = false
                updatePartyMode(isOn: false)
                return
            }
            self.partyModeOn = partyMode
            print("party mode downloaded")
        }
        
    }
    private func updatePartyMode(isOn: Bool)
    {
        let userId = Auth.auth().currentUser?.uid ?? ""
        if userId == ""
        {
            print("no user logged")
            return
        }
        Firestore.firestore().collection("users").document(userId)
            .setData(["partyMode": isOn], merge: true)
        {err in
            if let err = err
            {
                print(err)
                self.errorMessage = "\(err)"
                return
            }
            print("SUKCES")
            errorMessage = "Data uploaded"
        }
    }
    private func addUser(uid: String)
    {
        let userId = Auth.auth().currentUser?.uid ?? ""
        if userId == ""
        {
            print("no user logged")
            return
        }
        
        if uid != ""
        {
            Firestore.firestore().collection("dates")
                .document(userId)
                .collection("pickedUsers")
                .document(uid).getDocument { (document, error) in
                    if let error = error
                    {
                        self.errorMessage = "Failed to add date to collection: \(error)"
                        print(error)
                    }
                   if let document = document, document.exists {
                     print("Document data: \(document.data())")
                       self.alertName = "User already added"
                       self.showAlert = true
                       return
                  } else {
                      
                      Firestore.firestore().collection("dates")
                          .document(userId)
                          .collection("pickedUsers")
                          .document(uid)
                          .setData(["userId": uid, "wasTexted": false, "timestamp": Timestamp(), "lastMessage": ""])
                      {
                          error in
                          if let error = error
                          {
                              self.errorMessage = "Failed to add date to collection: \(error)"
                              print(error)
                          }
                      }
                      print("Added User: \(uid)")
                      self.alertName = "Added User"
                      self.showAlert = true
                  }
            }

        }
    }
}

struct CategoryPickView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CategoryPickView()
        }
        
    }
}
