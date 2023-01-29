//
//  MainView.swift
//  Dating App 1
//
//  Created by Karol Jagiełło
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct MainView: View {
    @State var errorMessage = ""
    @State var isUserCurrentlyLoggedOut = false //zmienna pokazujaca czy aktualnie jest ktos zalogowany
    @State var isUserDataMissing = false
    
    
    @State var currentUser: CurrentUser = CurrentUser(data: ["uid": "", "email": "", "imageURL": "", "name": "Name", "surname": "Surname", "birthDate": "","age": "", "sex": "", "orientation": "", "description": "", "university": "", "favoriteArtist": ""])
    
    @State var users = [CurrentUser]()
    @State var lastMessages = [String: String]()
    var body: some View {
        NavigationView
        {
            VStack {
                //Text(mvm.errorMessage).foregroundColor(Color.red)
                TabView{
                    DatePickerView(orientation: $currentUser.orientation).tabItem {
                        Image(systemName: "heart.text.square.fill")
                        Text("Pick a date")
                    }.padding(.all)
                    CategoryPickView().tabItem {
                        Image(systemName: "party.popper.fill")
                        Text("For Tonight")
                    }.padding(.all)
                    MessagesView(users: $users, lastMessages: $lastMessages).tabItem {
                        Image(systemName: "message.circle.fill")
                        Text("Your Dates")
                    }.padding(.all)
                    OwnProfileView(currentUser: $currentUser){
                        fetchCurrentUser()
                    } signOutProcess: {
                        handleSignOut()
                    }.tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Your Profile")
                    }
                }
                .edgesIgnoringSafeArea([.top,.trailing,.leading])
                .accentColor(Color.purple)
                .fullScreenCover(isPresented: $isUserDataMissing, content: {
                    PersonalDataFormView(name: "", surname: "", description: "", university: "", favoriteArtist: "") {
                        
                        isUserDataMissing = false
                        fetchCurrentUser()
                    }
                })
                .fullScreenCover(isPresented: $isUserCurrentlyLoggedOut) {
                    WelcomeView {
                        
                        isUserCurrentlyLoggedOut = false
                        fetchCurrentUser()
                        fetchChatedUsers()
                    }
                }
                
            }
        }
        .onAppear
        {
            self.isUserCurrentlyLoggedOut = Auth.auth().currentUser?.uid == nil
            fetchCurrentUser()
            fetchChatedUsers()
        }
    }
    private func fetchChatedUsers()
    {
        
        print("Started Fetching")
        let userId = Auth.auth().currentUser?.uid ?? ""
        if userId == ""
        {
            print("no user logged")
            return
        }
        self.users.removeAll()
        Firestore.firestore().collection("dates")
            .document(userId)
            .collection("pickedUsers")
            .order(by: "timestamp", descending: true)
            .whereField("wasTexted", isEqualTo: true)
            
            .addSnapshotListener
            { documentsSnapshot, error in
                if let error = error
                {
                    self.errorMessage = "failed to fetch: \(error)"
                    print("failed to fetch: \(error)")
                    return
                }
                self.errorMessage = "Fetched Succesfully"
                print("Fetched Succesfully, downloaded users: \(documentsSnapshot?.count)")
                documentsSnapshot?.documentChanges.forEach({ change in
                    if change.type == .added
                    {
                        let data = change.document.data()
                        let userId = data["userId"] as? String ?? ""
                        Firestore.firestore().collection("users").document(userId).getDocument { userSnapshot, err in
                            if let err = err
                            {
                                self.errorMessage = "failed to fetch: \(err)"
                                print("failed to fetch: \(err)")
                                return
                            }
                            guard let userData = userSnapshot?.data() else { return }
                            self.users.insert(.init(data: userData), at: 0)
                            self.lastMessages.updateValue(data["lastMessage"] as? String ?? "", forKey: userId)
                        }
                    }
                    else if change.type == .modified
                    {
                        let data = change.document.data()
                        let userId = data["userId"] as? String ?? ""
                        self.lastMessages.updateValue(data["lastMessage"] as? String ?? "", forKey: userId)
                    }
                })
            }
    }
    private func fetchCurrentUser()
    {
        self.errorMessage = "Fetching current user"
        guard let uid = Auth.auth().currentUser?.uid else {
            self.errorMessage = "Could not find firebase uid"
            return
            
        }
        //Firestore.firestore().enableNetwork()
        self.errorMessage = "\(uid)"
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, error in
            
            if let error = error
            {
                self.errorMessage = "FAIL TO FETCH \(error)"
                print("Failed to fetch: \(error)")
                self.isUserDataMissing = true
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "NO DATA AMIGO"
                self.isUserDataMissing = true
                return
                
            }
            
            
            self.currentUser = CurrentUser(data: data)
            self.checkUserData()
            self.errorMessage = "\(self.currentUser.name),\(self.currentUser.surname), \(self.currentUser.sex), \(self.currentUser.orientation), \(self.currentUser.description), \(self.currentUser.university), \(self.currentUser.favoriteArtist) "
        }
    }
    private func handleSignOut()
    {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        return
        }
        isUserCurrentlyLoggedOut = true
        
        
    }
    
    private func checkUserData()
    {
        if self.currentUser.uid == "" || self.currentUser.email == "" || self.currentUser.imageURL == "" ||
            self.currentUser.name == "" || self.currentUser.surname == "" || self.currentUser.orientation == "" || self.currentUser.sex == ""
        {
            self.errorMessage = "Czegos brakuje \(self.currentUser.name ?? "")"
            isUserDataMissing = true;
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
