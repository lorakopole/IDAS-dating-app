//
//  DatePickerView.swift
//  Dating App 1
//
//  Created by Karol Jagiełło on 08/12/2022.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth
struct DatePickerView: View {
    
    
    @State var pickedUser: CurrentUser = CurrentUser(data: ["uid": "", "email": "", "imageURL": "", "name": "Start", "surname": "Dating", "birthDate": "", "sex": "", "orientation": "", "description": "Press button to start searching for profiles", "university": "", "favoriteArtist": ""])
    @State var errorMessage = "Witam"
    @State var key = ""
    @Binding var orientation: String
    @State private var startedFromZero = false
    
    var body: some View {
        VStack {
            ProfileView(user: $pickedUser)
                .padding(10)
                .animation(.linear(duration: 0.5))
            HStack
        {
            Spacer()
            Button {
                handleYesPressed()
            } label: {
                Image(systemName: "checkmark.circle.fill").font(.system(size: 70)).foregroundColor(Color.green)
            }
            Spacer()
            Button {
                getRandomProfile()
            } label: {
                Image(systemName: "x.circle.fill").foregroundColor(Color.red).font(.system(size: 70))
            }
            Spacer()
        }
        }.task {
            key = await generateKeyID()
        }
    }
    
    func generateKeyID() async -> String
    {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let genKey = String((0..<5).map{ _ in letters.randomElement()! })
        print("randomKey : \(key)")
        errorMessage = genKey
        return genKey
    }
    
    func getRandomProfile()
    {
        let ref = Firestore.firestore().collection("users")
        
        ref.whereField("sex", isEqualTo: self.orientation)
            .whereField(FieldPath.documentID(), isNotEqualTo: Auth.auth().currentUser?.uid ?? "")
            .whereField(FieldPath.documentID(), isGreaterThan: key)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                
                if let error = error
                {
                    self.errorMessage = "FAIL TO FETCH \(error)"
                    print("Failed to fetch: \(error)")
                    return
                }
                //print("liczba dokumentow: \(snapshot!.documents.count)")
                if snapshot!.documents.count == 0
                {
                    self.key = "0"
                    if self.startedFromZero == false
                    {
                        self.startedFromZero = true
                        self.getRandomProfile()
                        return
                    }
                    else
                    {
                        self.pickedUser = CurrentUser(data: ["uid": "", "email": "", "imageURL": "", "name": "No", "surname": "Matches", "birthDate": "", "sex": "", "orientation": "", "description": "Sorry, couldnt find any matches for you. Try again later or change your orientation settings.", "university": "", "favoriteArtist": ""])
                        return
                    }

                }
                
                for document in snapshot!.documents {
                    
                        Firestore.firestore()
                        .collection("dates")
                        .document(Auth.auth().currentUser!.uid)
                        .collection("pickedUsers")
                        .document(document.data()["uid"] as! String)
                        .getDocument { docSnapshot, err in
                            
                            if let empty = docSnapshot?.exists
                            {
                                if !empty
                                {
                                    print("liczba dokumentow: \(snapshot!.documents.count)")
                                    self.pickedUser = CurrentUser(data: document.data())
                                    //self.asignData(data: document.data())
                                    self.key = document.documentID
                                    self.startedFromZero = false;
                                    return
                                }
                                else
                                {
                                    print("This user is already added: \(document.data()["name"] ?? "")")
                                    self.key = document.documentID
                                    self.getRandomProfile()
                                    return
                                }
                            }
                            if let err = err
                            {
                                self.errorMessage = "there is an error\(err)"
                                print("there is an error \(err)")
                                return
                            }

                        }
                    
                    //print("Was user already added?")
                    }
                    
                }
        }
    
    func handleYesPressed()
    {
        print("user id:\(Auth.auth().currentUser!.uid)")
        if self.pickedUser.uid != ""
        {
            
            Firestore.firestore().collection("dates")
                .document(Auth.auth().currentUser!.uid)
                .collection("pickedUsers")
                .document(pickedUser.uid)
                .setData(["userId": pickedUser.uid, "wasTexted": false, "timestamp": Timestamp(), "lastMessage": ""])
            {
                error in
                if let error = error
                {
                    self.errorMessage = "Failed to add date to collection: \(error)"
                    print(error)
                }
            }
            print("Added User: \(pickedUser.uid)")
        }
        getRandomProfile()
    }
    
    
}

struct BindingPreview2: View
{
    @State var orientation = "Male"
    
    var body: some View
    {
        DatePickerView(orientation: $orientation)
    }


}

struct DatePickerView_Previews: PreviewProvider {
    static var previews: some View {
        BindingPreview2()
    }
}
