//
//  PieChartViewRender.swift
//  MyBJJ
//
//  Created by Josh Bourke on 18/4/22.
//

import SwiftUI

struct PieChartViewRender: View {
    //MARK: - PROPERTIES
    public let values: [Double]
    public var colors: [Color]
    public let names: [String]
    
    public var backgroundColor: Color
    public var innerRadiusFraction: CGFloat
    
    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []
        
        for (i, value) in values.enumerated() {
            let degrees: Double = value * 360 / sum
            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), text: String(format: "%.0f%%", value * 100 / sum), color: self.colors[i]))
            endDeg += degrees
        }
        return tempSlices
    }
    
    
    //MARK: - BODY
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack{
                    ForEach(0..<self.values.count) { i in
                        PieChartView(pieSliceData: self.slices[i])
                    }
                    .frame(width: geometry.size.width, height: geometry.size.width)
                    
                    Circle()
                        .fill(self.backgroundColor)
                        .frame(width: geometry.size.width * innerRadiusFraction, height: geometry.size.width * innerRadiusFraction)
                    
                    ZStack {
                        Circle()
                            .frame(width: 100, height: 100)
                            .foregroundColor(Color(UIColor.secondarySystemBackground))
                        VStack{
                            Text("Total")
                                .font(.title.bold())
                                .foregroundColor(Color.primary)
                            Text(String(values.reduce(0, +)))
                                .font(.title.bold())
                                .foregroundColor(.secondary)
                        }//: VSTACK
                    }//: ZSTACK
                }//: ZSTACK
//                PieChartRowsView(colors: self.colors, names: self.names, values: self.values.map {String($0)}, percents: self.values.map{String(format: "%.0f%%", $0 * 100 / self.values.reduce(0, +))})
            }//: VSTACK
            .background(self.backgroundColor)
            .foregroundColor(Color.white)

        }//: GEO
        .frame(width: 175, height: 175)


    }
}


    //MARK: - PREVIEW
struct PieChartViewRender_Previews: PreviewProvider {
    static var previews: some View {
        PieChartViewRender(values: [4, 6, 9], colors: [Color.blue, Color.green, Color.orange], names: ["Rent", "Transport","Education"], backgroundColor: Color.clear, innerRadiusFraction: 0.6)
    }
}
 
