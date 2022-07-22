//
//  StatsTextView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 13/6/2022.
//

import SwiftUI

//The idea of this view is to display stats in a text format compared to graph.

struct StatsTextView: View {
    @Environment(\.colorScheme) var colorScheme
    var titleName: String
    var valueName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(titleName)
                .font(.headline)
            Text(valueName)
                .font(.title.bold())
        }//: VSTACK
        .padding()
    }
}

struct StatsTextView_Previews: PreviewProvider {
    static var previews: some View {
        StatsTextView(titleName: "Most Successful", valueName: "Rear Naked")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
