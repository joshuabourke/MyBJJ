//
//  ForgotPasswordView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 2/6/2022.
//

import SwiftUI

struct ForgotPasswordView: View {
    //MARK: - PROPERITES
    @State var email: String = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert: Bool = false
    @State private var errString: String?
    @State private var hasTextTimerFinished: Bool = false
    @State private var hasCloseTimerFinished: Bool = false
    @State private var resetPasswordInfoText: String = ""
    //MARK: - BODY
    var body: some View {
        VStack{
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                    print("Close Window")
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2.bold())
                        .foregroundColor(.accentColor)
                }
                Spacer()
            }//: HSTACK(Buttons top of screen)
            .padding()
            
            
            //MARK: - Dismiss sheet view buttons.
            HStack {
                Text("Reset Password")
                    .font(.title.bold())
                .padding()
                Spacer()
            }//: HSTACK
            Spacer()
            Text(hasTextTimerFinished ? "Reset email sent" : resetPasswordInfoText)
                .fontWeight(.bold)
                .foregroundColor(.red)
            //MARK: - Email to send forgotten password to (TextField).
            HStack {
                Image(systemName: "envelope")
                    .font(.system(size: 32).bold())
                    .padding()
                TextField("email to reset pass", text: $email)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .foregroundColor(Color.primary)
                    .font(.system(.title3).bold())
                    .padding(.vertical)
                    .cornerRadius(12)
            }//: HSTACK
            .background(RoundedRectangle(cornerRadius: 12).fill(Color(.secondarySystemBackground)))
            .padding(.horizontal)
            
            //MARK: - Send button.
            Button(action: {
                FirebaseManager.shared.auth.sendPasswordReset(withEmail: email){ error in
                }
                delayTask()
                delayClose()
                resetPasswordInfoText = "Thinking...."
                print("ForgotPassword Button has been pressed")
            }, label: {
                Text("Reset")
                    .fontWeight(.bold)
            })
            .buttonStyle(RectangleButton())
            .frame(width: 100, height: 45)
            .padding()
            Spacer()
        }//: VSTACK

        .alert(isPresented: $showAlert) {
            Alert(title: Text("Password Reset"), message: Text(self.errString ?? "Success. Reset email sent successfully. Check your email"), dismissButton: .default(Text("Ok")) {
                self.presentationMode.wrappedValue.dismiss()
            })
        }

    }
    
    //MARK: - FUNCTIONS
    func delayTask() {
        //Delay of 7.5 Seconds (1 second  = 1_000_000_000 nano seconds)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            hasTextTimerFinished = true

        })
    }
    func delayClose(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            hasCloseTimerFinished = true
            if hasCloseTimerFinished {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}
    //MARK: - PREVIEW
struct ForgotPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        ForgotPasswordView()
    }
}
