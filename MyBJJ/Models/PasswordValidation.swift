//
//  PasswordValidation.swift
//  MyBJJ
//
//  Created by Josh Bourke on 28/9/2022.
//

import Foundation
import Combine
import SwiftUI

//Reference to where I found out how to do this https://betterprogramming.pub/how-to-validate-complex-passwords-in-swiftui-b982cd326912

class FormViewModel: ObservableObject {
    @Published var password = ""
    @Published var email = ""
    @Published var validations: [Validation] = []
    @Published var emailValidations: [EmailValidationStruct] = []
    @Published var isValid: Bool = false
    @Published var isEmailValid: Bool = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    private var cancellableEmailSet: Set<AnyCancellable> = []
    
    init() {
        //Validations
        passwordPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.validations, on: self)
            .store(in: &cancellableEmailSet)
        
        emailPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.emailValidations, on: self)
            .store(in: &cancellableEmailSet)
        
        //isValid
        passwordPublisher
            .receive(on: RunLoop.main)
            .map { validations in
                return validations.filter { validation in
                    return ValidationState.failure == validation.state
                }.isEmpty
            }
            .assign(to: \.isValid, on: self)
            .store(in: &cancellableSet)
        
        emailPublisher
            .receive(on: RunLoop.main)
            .map { validations in
                return validations.filter { validation in
                    return ValidationState.failure == validation.state
                }.isEmpty
            }
            .assign(to: \.isEmailValid, on: self)
            .store(in: &cancellableEmailSet)
        
    }
    
    private var passwordPublisher: AnyPublisher<[Validation], Never> {
        $password
            .removeDuplicates()
            .map { password in
                var validations: [Validation] = []
                validations.append(Validation(string: password, id: 0, field: .password, validationType: .isNotEmpty))
                
                validations.append(Validation(string: password, id: 1, field: .password, validationType: .minCharacters(min: 8)))
                
                validations.append(Validation(string: password, id: 2, field: .password, validationType: .hasUppercasedLetters))
                
                return validations
            }
            .eraseToAnyPublisher()
    }
    private var emailPublisher: AnyPublisher<[EmailValidationStruct], Never> {
        $email
            .removeDuplicates()
            .map { email in
                var validations: [EmailValidationStruct] = []
                
                validations.append(EmailValidationStruct(string: email, id: 0, field: .email, validationType: .isNotEmpty))
                
                validations.append(EmailValidationStruct(string: email, id: 1, field: .email, validationType: .isEmailValid))
                
                return validations
            }
            .eraseToAnyPublisher()
        
    }
    
    
    enum Field: String{
        case email
        case password
    }
    
    enum ValidationState {
        case success
        case failure
    }
    
    enum emailValidationType{
        case isNotEmpty
        case isEmailValid
        
        func fulfills(string: String) -> Bool{
            switch self {
            case .isNotEmpty:
                return !string.isEmpty
            case .isEmailValid:
                return string.emailValidation()
            }
        }
        
        func message(fieldName: String) -> String {
            switch self {
            case .isNotEmpty:
                return "\(fieldName) must not be empty"
            case .isEmailValid:
                return "\(fieldName) must be valid"
            }
        }
    }
    
    enum ValidationType{
        case isNotEmpty
        case minCharacters(min: Int)
        case hasUppercasedLetters
        
        func fulfills(string: String) -> Bool{
            switch self {
            case .isNotEmpty:
                return !string.isEmpty
            case .minCharacters(min: let min):
                return string.count > min
            case .hasUppercasedLetters:
                return string.hasUppercasedCharacters()
            }
        }
        
        func message(fieldName:String) -> String {
            switch self {
            case .isNotEmpty:
                return "\(fieldName) must not be empty"
                
            case .minCharacters(min: let min):
                return "\(fieldName) must be longer than \(min) characters"
                
            case .hasUppercasedLetters:
                return "\(fieldName) must have an uppercase letter"
            }

        }
    }

    struct EmailValidationStruct: Identifiable {
        var id: Int
        var field: Field
        var validationType: emailValidationType
        var state: ValidationState
        
        init(string: String, id: Int, field: Field, validationType: emailValidationType) {
            self.id = id
            self.field = field
            self.validationType = validationType
            self.state = validationType.fulfills(string: string) ? .success : .failure
        }
    }
    
    struct Validation: Identifiable {
        var id: Int
        var field: Field
        var validationType: ValidationType
        var state: ValidationState
        
        init(string: String, id: Int, field: Field, validationType: ValidationType) {
            self.id = id
            self.field = field
            self.validationType = validationType
            self.state = validationType.fulfills(string: string) ? .success : .failure
        }
    }
}

extension String {
    func hasUppercasedCharacters() -> Bool {
        return stringFulfillRegex(regex: ".*[A-Z]+.*")
    }
    
    func emailValidation() -> Bool {
        return stringFulfillRegex(regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    }
//    func textFieldValidatorEmail(_ string: String) -> Bool  {
//        if string.count > 100 {
//            return false
//        }
//
//        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
//        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
//        return emailPredicate.evaluate(with: string)
//    }
    
    
    private func stringFulfillRegex(regex: String) -> Bool{
        
        let textTest = NSPredicate(format: "SELF MATCHES %@", regex)
        
        guard textTest.evaluate(with: self) else {
            return false
        }
        return true
    }
}
