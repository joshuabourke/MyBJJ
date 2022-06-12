//
//  PieChartRowsView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 18/4/22.
//

import SwiftUI

struct PieChartRowsView: View {
    //MARK: - PROPERTIES
    var colors: [Color]
    var names: [String]
    var values: [String]
    var percents: [String]
    
    //MARK: - BODY
    var body: some View {
        ForEach(0..<self.values.count) { i in
            HStack{
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(self.colors[i])
                    .frame(width: 20, height: 20)
                Text(self.names[i])
                Spacer()
                VStack(alignment: .trailing) {
                    Text(self.values[i])
                    Text(self.percents[i])
                        .foregroundColor(Color.gray)
                }
            }
        }
    }
}
    //MARK: - PREVIEW
//struct PieChartRowsView_Previews: PreviewProvider {
//    static var previews: some View {
//        PieChartRowsView(colors: [Color.blue, Color.green, Color.orange], names: ["Rent", "Transport", "Education"], values: [1300, 500, 300], percents: [])
//    }
//}
