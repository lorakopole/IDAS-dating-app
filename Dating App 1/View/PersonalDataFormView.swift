//
//  RegisterAcountView.swift
//  Dating App 1
//
//  Created by Karol Jagiełło
//

import SwiftUI
import PhotosUI
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct PersonalDataFormView: View {
    
    @State var name: String
    @State var surname: String
    @State var birthDate = Date.now
    @State var sex: String = "Male"
    @State var orientation: String = "Male"
    @State var description: String
    @State var university: String
    
    @State private var shouldShowImagePicker = false
    @State var image: UIImage?
    
    @State var favoriteArtist: String
    
    @State var errorMessage: String = ""
    
    let didCompleteUploadProces: () -> ()
    
    var justUpdate = false
    
    var body: some View {
            VStack
            {
                List {
                    RegisterTextField(fieldName: "Name*", data: $name)
                    RegisterTextField(fieldName: "Surname*", data: $surname)
                    VStack {
                        Text("Pick your birth date:")
                        DatePicker("Date of Birth:", selection: $birthDate,in: ...Date(), displayedComponents: .date)
                            .datePickerStyle(.wheel)
                            .labelsHidden()
                    }
                    Picker(selection: $sex, label: Text("Sex*:")) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                        Text("Other").tag("Other")
                    }
                    Picker(selection: $orientation, label: Text("Orientation*:")) {
                            Text("Male").tag("Male")
                            Text("Female").tag("Female")
                            Text("Other").tag("Other")
                    }
                    TextField("description", text: $description, axis: .vertical)
                        .lineLimit(5)
                    RegisterTextField(fieldName: "University", data: $university)
                    HStack
                    {
                        Spacer()
                        Button {
                            shouldShowImagePicker.toggle()
                        } label: {
                            VStack
                            {
                                if let image = self.image
                                {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 200, height: 200)
                                        .cornerRadius(64)
                                        
                                }
                                else
                                {
                                    Image(systemName: "person.circle")
                                        .font(.system(size: 128))
                                        .padding()
                                        .foregroundColor(Color.black)
                                }
                                
                            }
                            .overlay(RoundedRectangle(cornerRadius: 64).stroke(Color.black, lineWidth: 3))
                            Text("Pick profile image")
                        }

                        Spacer()
                    }
                    RegisterTextField(fieldName: "Favourite Artist", data: $favoriteArtist)
                    UploadDataButton
                }
                .adaptsToKeyboard()
                .padding(.top,20)
                    .scrollContentBackground(.hidden)
                Text(errorMessage)
                    .foregroundColor(Color.red)
            }.edgesIgnoringSafeArea(.all)
            .background(content: {
                K.colors.MainPurple.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
                Image("idas").resizable().aspectRatio(contentMode: .fit).opacity(0.3)
            })
                .navigationBarBackButtonHidden(true)
                .navigationTitle("Registration Form")
                .fullScreenCover(isPresented: $shouldShowImagePicker) {
                    ImagePicker(image: $image)

        }
    }
    
    private var UploadDataButton: some View
    {
        HStack
        {
            Spacer()
            Button {
                if justUpdate
                {
                    updateData()
                }
                else
                {
                    persistImageToStorage()
                }
            } label: {
                Text("Upload Data")
                    .foregroundColor(Color.purple)
                    .fontWeight(.heavy)
                
                
            }.buttonStyle(EnterButton())
            Spacer()
        }
    }
    
    private func persistImageToStorage() //funkcja do zapisu zdjecia
    {
        if name == "" || surname == "" || image == nil
        {
            errorMessage = "Fields with '*', and image cant be empty!"
            return
        }
        guard let uid = Auth.auth().currentUser?.uid //pobranie id aktualnego użytkownika
        else { return }
        
        let ref = Storage.storage().reference(withPath: uid) //stworzenie referencji do uzytkownika
        
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) //zakodowanie zdjecia
        else { return }
        
        ref.putData(imageData, metadata: nil)
        {
            metadata, err in
            if let err = err
            {
                self.errorMessage = "Failed to push image: \(err)"
                return
                
            }
            
            ref.downloadURL { url, err in
                if let err = err
                {
                    self.errorMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                self.errorMessage = "image uploaded"
                print(url?.absoluteString)
            
                guard let url = url else { return }
                storeUserInformation(image: url)
            }
        }

        
        
    }
    private func storeUserInformation(image: URL)
    {
        guard let uid = Auth.auth().currentUser?.uid else
        {
            return
        }
        
        guard let email = Auth.auth().currentUser?.email else
        {
            return
        }
        
        
        let userData = ["uid": uid, "email": email, "imageURL": image.absoluteString, "name": self.name, "surname": self.surname, "birthDate": DateHandler.DateToString(date: birthDate), "sex": self.sex, "orientation": self.orientation, "description": self.description, "univeristy": self.university, "favouriteArtist": self.favoriteArtist]
        
        Firestore.firestore().collection("users")
            .document(uid).setData(userData, merge: true)
        {
            err in
            if let err = err
            {
                print(err)
                self.errorMessage = "\(err)"
                return
            }
            print("SUKCES")
            errorMessage = "Data uploaded"
            self.didCompleteUploadProces()
        }
    }
    private func updateData()
    {
        if self.image == nil //zakodowanie zdjecia
        {
            print("Brak zdjecia")
            self.errorMessage = "no photo uploaded"
            guard let uid = Auth.auth().currentUser?.uid else
            {
                return
            }
            
            guard let email = Auth.auth().currentUser?.email else
            {
                return
            }
            
            
            let userData = ["uid": uid, "email": email, "name": self.name, "surname": self.surname, "birthDate": DateHandler.DateToString(date: birthDate), "sex": self.sex, "orientation": self.orientation, "description": self.description, "univeristy": self.university, "favouriteArtist": self.favoriteArtist]
            
            Firestore.firestore().collection("users")
                .document(uid).setData(userData, merge: true)
            {
                err in
                if let err = err
                {
                    print(err)
                    self.errorMessage = "\(err)"
                    return
                }
                print("SUKCES")
                
                self.didCompleteUploadProces()
            }
            
        }
        else
        {
            persistImageToStorage()
        }
    }
    
}


struct RegisterAcountView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalDataFormView(name: "Jan", surname: "Kowalski", sex: "Male", orientation: "Female", description: "",university: "Politechnika Wrocławska", favoriteArtist: "The Weeknd") {
            
        }
    }
}
