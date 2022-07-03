//
//  ReminderListViewItem.swift
//  LocalNotificationBootCamp
//
//  Created by Josh Bourke on 23/6/2022.
//

import SwiftUI

struct ReminderListViewItem: View {
    //MARK: - PROPERTIES
    
    //MARK: - BODY
    var body: some View {
        HStack {
            Image(systemName: "bell")
                .font(.title2.bold())
                .foregroundColor(.accentColor)
            Spacer()
            Text("Sun")
                .font(.title.bold())
            Text("8:30am")
                .font(.title.bold())
        }//: Hstack
    }
}
//MARK: - PREVIEW
struct ReminderListViewItem_Previews: PreviewProvider {
    static var previews: some View {
        ReminderListViewItem()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
