//
//  MyBJJUser.swift
//  MyBJJ
//
//  Created by Josh Bourke on 4/5/22.
//

import Foundation

struct MyBJJUser: Identifiable {
    var id: String {uid}
    
    let uid, email, profileImageURL: String
    
    init(data: [String: Any]) {
        
        self.uid = data["uid"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.profileImageURL = data["profileImageURL"] as? String ?? ""
        
    }
}
