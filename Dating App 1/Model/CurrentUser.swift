//
//  Person.swift
//  Dating App 1
//
//  Created by Karol Jagiełło
//

import SwiftUI

struct CurrentUser: Identifiable
{
    var id: String { uid }
    
    var uid: String
    var email: String
    var imageURL: String
    
    var name: String
    var surname: String
    var birthDate: String
    var age: String
    var sex: String
    var orientation: String
    var description: String
    var university: String
    var favoriteArtist: String
    
    init(data: [String: Any])
    {
        uid = data["uid"] as? String ?? ""
        email = data["email"] as? String ?? ""
        imageURL = data["imageURL"] as? String ?? ""
        name = data["name"] as? String ?? ""
        surname = data["surname"] as? String ?? ""
        
        age = DateHandler.CountYearsFromNow(date: DateHandler.StringToDate(date: data["birthDate"] as? String ?? ""))
        birthDate = data["birthDate"] as? String ?? ""
        sex = data["sex"] as? String ?? ""
        orientation = data["orientation"] as? String ?? ""
        description = data["description"] as? String ?? ""
        university  = data["univeristy"] as? String ?? ""
        favoriteArtist = data["favouriteArtist"] as? String ?? ""
    }
    
}
