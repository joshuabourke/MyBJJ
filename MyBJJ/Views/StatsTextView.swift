//
//  StatsTextView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 13/6/2022.
//

import SwiftUI

struct StatsTextView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Best Submission")
                .font(.headline)
            Text("Rear Naked")
                .font(.title.bold())
        }//: VSTACK
        
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 6)
        
        
    }
}

struct StatsTextView_Previews: PreviewProvider {
    static var previews: some View {
        StatsTextView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
