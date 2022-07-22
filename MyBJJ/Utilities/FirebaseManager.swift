//
//  FirebaseManager.swift
//  MyBJJ
//
//  Created by Josh Bourke on 4/5/22.
//

import Foundation
import Firebase
import SwiftUI

class FirebaseManager: NSObject {
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
    override init() {
        FirebaseApp.configure()
        
        self .auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}

class SubListViewModel: ObservableObject {
    
    @Published var isUserCurrentlyLoggedOut: Bool = false
    @Published var errorMessage: String = ""
    @Published var myBJJUser: MyBJJUser?
    
    
    init() {
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        fetchCurrentUser()
    }
    
    func fetchCurrentUser(){
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMessage = "Could not find fire base uid"
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMessage = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user", error)
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMessage = "No Data found"
                return
            }
            self.myBJJUser = .init(data: data)
        }
    }
    
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
    
    func handleAccountDeletion() {
        FirebaseManager.shared.auth.currentUser?.delete(completion: { error in
            if let error = error {
                print("Could not delete user from Firebase FireStore ERROR:\(error)")
            } else {
                print("Successfully deleted user from Firebase FireStore")
            }
        })
    }
    
//    @Published var subListItem:
    
    
}
