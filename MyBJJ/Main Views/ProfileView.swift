//
//  ProfileView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 13/6/2022.
//

import SwiftUI

struct ProfileView: View {
    //MARK: - PROPERTIES
    
    @EnvironmentObject var subListVM: SubListViewModel
    @Binding var closeProfileView: Bool
    //MARK: - BODY
    var body: some View {
            VStack{
                Text("Rank")
                    .font(.system(size: 22))
                    .bold()
                
                BeltView(beltColor: .blue, beltStripes: [Color.white, Color.black, Color.black, Color.black])
                    .shadow(radius: 8)
                Spacer()
                Button {
                    print("Log Out")
                    subListVM.handleSignOut()
                    withAnimation {
                        closeProfileView.toggle()
                    }
                } label: {
                    Text("Log Out")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .buttonStyle(RedRectangleButton())
                .frame(width: 150, height: 45)
                .padding()
            }//: VSTACK
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
    //MARK: - PREVIEW
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(closeProfileView: .constant(false))
    }
}
