//
//  CustomRowSelectionTest.swift
//  MyBJJ
//
//  Created by Josh Bourke on 14/4/22.
//

import SwiftUI

struct CustomRowSelectionTest: View {
    //MARK: - PROPERTIES
    
    typealias Action = (String) -> Void
    
    let title: String
    @Binding var selectedItem: String
    var action: Action?
    
    
    //MARK: - BODY
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 20).bold())
            
            Spacer()
            if title == selectedItem {
                Image(systemName: "checkmark")
                    .foregroundColor(.accentColor)
                    .font(.system(size: 20).bold())
            }
        }//: HSTACK
        .contentShape(Rectangle())
        .onTapGesture {
            //Tap
            if title == selectedItem {
                selectedItem = ""
            } else {
                selectedItem = title
            }
            //Action
            if let action = action {
                action(title)
            }
        }
    }
}
    //MARK: - PREVIEW
struct CustomRowSelectionTest_Previews: PreviewProvider {
    static var previews: some View {
        CustomRowSelectionTest(title: "NoName", selectedItem: .constant("NoName"))
    }
}
