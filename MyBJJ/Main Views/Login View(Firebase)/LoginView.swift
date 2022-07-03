//
//  LoginView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 4/5/22.
//

import SwiftUI

struct LoginView: View {
    //MARK: - PROPERTIES
    @Environment(\.presentationMode) var presentationMode
    //MARK: - LOGIN/CREATE ACCOUNT PROCESS
    //MARK: - ACCOUNT
    let didFinishLoginProcess: () ->()
    @State var loginStatusMessage: String = ""
    @State var image: UIImage?
    
    @State var email: String = ""
    @State var password: String = ""
    @State var ifCreateAccount: Bool = false
    @State var tryingToChooseProfilePic: Bool = false
    @State var showForgotPassword: Bool = false

    @Binding var didFinishingLoggingIn: Bool
    //MARK: - BODY
    var body: some View {
        NavigationView {
            VStack {
                if ifCreateAccount {
                    createAccountScreen
                    
                } else {
                    loginScreen
                }
                
            }//: VSTACK
            .fullScreenCover(isPresented: $tryingToChooseProfilePic){
                ImagePicker(image: $image)
        }//: fullscreencover(Image picker profile pic)
            
            
            .navigationTitle(ifCreateAccount ? "Create Account" : "Login")
            .navigationBarItems(leading: Button {
                presentationMode.wrappedValue.dismiss()
                print("Close Window")
            } label: {
                Image(systemName: "xmark")
                    .font(.title2.bold())
                    .foregroundColor(.accentColor)
            })
        }//: NAVIGATION
        
        
    }
    //MARK: - EXTRACTED VIEWS
    
    //MARK: - LOG IN SCREEN
    private var loginScreen: some View{

        VStack(alignment: .center, spacing: 40) {
            Text(self.loginStatusMessage)
                .foregroundColor(.red)
            
            HStack {
                Image(systemName: "envelope")
                    .font(.system(size: 32).bold())
                    .padding()
                TextField("email", text: $email)
                    .foregroundColor(Color.primary)
                    .font(.system(.title3).bold())
                    .padding(.vertical)
                    .cornerRadius(12)
            }//: HSTACK
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
            .padding(.horizontal)

            
            HStack {
                Image(systemName: "lock")
                    .font(.system(size: 32).bold())
                    .padding()
                SecureField("password", text: $password)
                    .foregroundColor(Color.primary)
                    .font(.system(.title3).bold())
                    .padding(.vertical)
                    .cornerRadius(12)
            }//: HSTACK
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
            .padding(.horizontal)
            
            Button(action: {
                DispatchQueue.main.asyncAfter(deadline: .now()){
                    didFinishingLoggingIn.toggle()
                }
                handleAction()
                print("Login button has been tapped")
            }, label: {
                Text("Login")
                    .fontWeight(.bold)
            })
            .buttonStyle(RectangleButton())
            .frame(width: 100, height: 45)
            .padding()
            
            HStack{
                Text("Don't already have an account?")
                    .font(.body.bold())
                Button {
                    withAnimation(.default) {
                        ifCreateAccount.toggle()
                    }
                    
                    print("User doesn't have an account, is being redirected to create account screen")
                } label: {
                    Text("Tap Here")
                        .bold()
                        .underline()
                }
            }//: HSTACK
            Button {
                print("Forgot Password")
                showForgotPassword.toggle()
            } label: {
                Text("Forgot Password")
                    .bold()
                    .underline()
            }

            
        }//: VSTACK
        .sheet(isPresented: $showForgotPassword) {
            ForgotPasswordView()
        }
    }//: LOGIN SCREEN
    
    
    //MARK: - CREATE ACCOUNT SCREEN
    private var createAccountScreen: some View {

        VStack(alignment: .center, spacing: 40) {
            Text(self.loginStatusMessage)
                .foregroundColor(.red)
            HStack {
                Image(systemName: "envelope")
                    .font(.system(size: 32).bold())
                    .padding()
                TextField("email", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .foregroundColor(Color.primary)
                    .font(.system(.title3).bold())
                    .padding(.vertical)
                    .cornerRadius(12)
            }//: HSTACK
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
            .padding(.horizontal)

            
            HStack {
                Image(systemName: "lock")
                    .font(.system(size: 32).bold())
                    .padding()
                SecureField("password", text: $password)
                    .foregroundColor(Color.primary)
                    .font(.system(.title3).bold())
                    .padding(.vertical)
                    .cornerRadius(12)
            }//: HSTACK
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
            .padding(.horizontal)
            
            Button(action: {
                didFinishingLoggingIn.toggle()
                handleAction()
                print("Create Account Button has been tapped")
            }, label: {
                Text("Create Account")
                    .fontWeight(.bold)
            })//: Login/Create Button
            .buttonStyle(RectangleButton())
            .frame(width: 200, height: 45)
            .padding()
            HStack{
                Text("Already have an account?")
                    .font(.body.bold())
                Button {
                    withAnimation(.default) {
                        ifCreateAccount.toggle()
                    }
                    
                    print("Already has an account, redirect to login screen")
                } label: {
                    Text("Tap Here")
                        .bold()
                        .underline()
                }
            }//: HSTACK
        }//: VSTACK
    }//: CREATE ACCOUNT SCREEN
    
    //MARK: - FUNCTION
    
    //MARK: - HANDLE ACTION
    private func handleAction() {
        if ifCreateAccount{
            createNewAccount()
            print("Register a new account inside of Firebase Auth and then store image in Storage somehow....")
        } else {
            loginUser()
            print("Should log into Firebase with exsisting credentials")
        }
    }
    
    //MARK: - LOGIN
    private func loginUser() {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("Failed to Log In user:", err)
                self.loginStatusMessage = "Failed to log in user: \(err)"
                return
            }
            print("Successfully Logged In as user: \(result?.user.uid ?? "")")
            self.loginStatusMessage = "Successfully Logged In as user: \(result?.user.uid ?? "")"
            
            self.didFinishLoginProcess()
        }
    }//: LOGIN
    
    //MARK: - CREATE ACCOUNT
    private func createNewAccount() {
        FirebaseManager.shared.auth.createUser(withEmail: self.email, password: self.password) { result, err in
            if let err = err {
                print("Failed to create user:", err)
                self.loginStatusMessage = "Failed to create user: \(err)"
                return
            }
            print("Successfully created user: \(result?.user.uid ?? "")")
            self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
            self.didFinishLoginProcess()
        }
    }//: CREATE ACCOUNT
    
    //MARK: - PERSIST IMAGE TO STORAGE
    private func persistImageToStorage() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            return
        }
        
        guard let imageData = self.image?.jpegData(compressionQuality: 0.5) else {
            return
        }
        let ref = FirebaseManager.shared.storage.reference(withPath: uid)
        ref.putData(imageData, metadata: nil) { metadata, err in
            if let err = err {
                self.loginStatusMessage = "Failed to push image to storage:\(err)"
                return
            }
            ref.downloadURL { url, err in
                if let err = err {
                    self.loginStatusMessage = "Failed to retrieve downloadURL: \(err)"
                    return
                }
                self.loginStatusMessage = "Successfully stored Image with url: \(url?.absoluteString ?? "")"
                print(url?.absoluteString)
                
                guard let url = url else {return}
                storeUserInfomation(imageProfileURL: url)
            }
        }
    }//: PERSIST IMAGE TO STORAGE
    
    //MARK: - STORE USER INFOMATION
    private func storeUserInfomation(imageProfileURL: URL) {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        
        let userData = ["email" : self.email, "uid": uid, "profileImageURL" : imageProfileURL.absoluteString]
        
        FirebaseManager.shared.firestore.collection("users")
            .document(uid).setData(userData) { err in
                if let err = err{
                    print(err)
                    self.loginStatusMessage = "\(err)"
                    return
                }
                print("Success")
                self.didFinishLoginProcess()
            }
    }//: STORE USER INFOMATION
}


//MARK: - PREVIEW
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(didFinishLoginProcess: {
            
        }, didFinishingLoggingIn: .constant(false))
    }
}
