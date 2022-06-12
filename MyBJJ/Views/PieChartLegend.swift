//
//  PieChartLegend.swift
//  MyBJJ
//
//  Created by Josh Bourke on 24/4/22.
//

import SwiftUI

struct PieChartLegend: View {
    //MARK: - PROPERTIES
    
    var colors: [Color]
    var numOfChokeHold: Int
    var numOfUpperBody: Int
    var numOfLowerBody: Int
    
    //MARK: - BODY
    var body: some View {
        VStack(alignment: .leading ,spacing: 20) {
            VStack(alignment: .center, spacing: 2) {
                HStack {
                    //BLUE
                    Rectangle()
                        .cornerRadius(5)
                        .frame(width: 20, height: 20)
                        .foregroundColor(colors[0])
                    Text("Chokehold")
                        .font(.system(size: 6).bold())
                        
                }//: HSTACK
                Text("\(numOfChokeHold)")
                    .font(.system(size: 12).bold())
                    
            }//: VSTACK
            VStack(alignment: .center, spacing: 2) {
                HStack {
                    //RED
                    Rectangle()
                        .cornerRadius(5)
                        .frame(width: 20, height: 20)
                        .foregroundColor(colors[1])
                    Text("Upperbody")
                        .font(.system(size: 6).bold())

                }//: HSTACK
                Text("\(numOfUpperBody)")
                    .font(.system(size: 12).bold())
            }//: VSTACK
            VStack(alignment: .center, spacing: 2) {
                HStack {
                    //ORANGE
                    Rectangle()
                        .cornerRadius(5)
                        .frame(width: 20, height: 20)
                        .foregroundColor(colors[2])
                    Text("Lowerbody")
                        .font(.system(size: 6).bold())
                }//: HSTACK
                Text("\(numOfLowerBody)")
                    .font(.system(size: 12).bold())
            }//: VSTACK
        }//: VSTACK

    }
}
    //MARK: - PREVIEW
struct PieChartLegend_Previews: PreviewProvider {
    static var previews: some View {
        PieChartLegend(colors: [Color.accentColor, Color.cyan.opacity(0.5), Color.teal.opacity(0.5)], numOfChokeHold: 5, numOfUpperBody: 6, numOfLowerBody: 8)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
