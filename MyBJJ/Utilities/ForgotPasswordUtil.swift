//
//  ForgotPasswordUtil.swift
//  MyBJJ
//
//  Created by Josh Bourke on 2/6/2022.
//

import Foundation
import Firebase

//MARK: - USER FORGOT PASS WORD
struct ForgotPasswordUtil {
    static func resetPassword(email:String, resetCompletion: @escaping(Result<Bool,Error>) -> Void) {
        FirebaseManager.shared.auth.sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                resetCompletion(.failure(error))
            } else {
                resetCompletion(.success(true))
            }
        }
    }
    
}
