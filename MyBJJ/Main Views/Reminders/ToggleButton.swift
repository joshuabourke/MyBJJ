//
//  ToggleButton.swift
//  LocalNotificationBootCamp
//
//  Created by Josh Bourke on 19/6/2022.
//

import SwiftUI

struct ToggleButton: View {
    //MARK: - PROPERTIES
    
   @Binding var isOn: Bool
    var title: String
    
    //MARK: - BODY
    var body: some View {
        Toggle(title, isOn: $isOn)
            .toggleStyle(.button)
            .font(.caption)
            .overlay(RoundedRectangle(cornerRadius: 4).stroke().foregroundColor(.accentColor))
    }
}
    //MARK: - PREVIEW
struct ToggleButton_Previews: PreviewProvider {
    static var previews: some View {
        ToggleButton(isOn: .constant(false), title: "This Toggle")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
