//
//  BeltView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 25/4/22.
//

import SwiftUI

struct BeltView: View {
    //MARK: - PROPERTIES
    
    var beltColor: Color
    var beltStripes: [Color]
    var stripeBackgroundColor: Color
    //MARK: - BODY
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .frame(width: 150, height: 75)
                .foregroundColor(beltColor)
            //-----------------------------
            Rectangle()
                .frame(width: 20, height: 70)
                .foregroundColor(beltStripes[0])
                .padding(.horizontal,5)
            Rectangle()
                .frame(width: 20, height: 70)
                .foregroundColor(beltStripes[1])
                .padding(.trailing, 2.5)
            Rectangle()
                .frame(width: 20, height: 70)
                .foregroundColor(beltStripes[2])
                .padding(.leading,2.5)
            Rectangle()
                .frame(width: 20, height: 70)
                .foregroundColor(beltStripes[3])
                .padding(.horizontal,5)
            //-----------------------------
            Rectangle()
                .frame(width: 50, height: 75)
                .foregroundColor(beltColor)
        }//: HSTACK
        .background(stripeBackgroundColor)
        .cornerRadius(8)
    }
}
    //MARK: - PREVIEW
struct BeltView_Previews: PreviewProvider {
    static var previews: some View {
        BeltView(beltColor: Color.blue, beltStripes: [Color.white, Color.white, Color.white, Color.white], stripeBackgroundColor: .black)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
