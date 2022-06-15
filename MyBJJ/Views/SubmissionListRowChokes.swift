//
//  SubmissionListRow.swift
//  MyBJJ
//
//  Created by Josh Bourke on 14/4/22.
//

import SwiftUI

struct SubmissionListRowChokes: View {
    //MARK: - PROPERTIES
    let todaysDate = Date().formatDate()
   @State var submissionListModel: SubmissionListModel
    //MARK: - BODY
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment:.center){
                VStack{
                    HStack{
                        Image(systemName: "figure.stand")
                            .foregroundColor(submissionListModel.winOrLoss ? .green : .red)
                            .font(.system(size: 22))
                        Text(submissionListModel.winOrLoss ? "Win" : "Loss")
                            .foregroundColor(submissionListModel.winOrLoss ? .green : .red)
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                    }//:HSTACK
                }//: VSTACK
                Spacer()
                VStack(alignment:.trailing){
                    Text(submissionListModel.upperLowerChoke)
                        .font(.system(size: 12))
                        .bold()
                    Text(submissionListModel.sub)
                        .font(.system(size: 20))
                        .bold()
                    Text(submissionListModel.date)
                        .font(.system(size: 10))
                        .foregroundColor(.secondary.opacity(0.5))
                }//: VSTACK
            }//: HSTACK
        }
        .padding()
    }
}
    
    //MARK: - PREVIEW
struct SubmissionListRow_Previews: PreviewProvider {
    static var previews: some View {
        
        SubmissionListRowChokes(submissionListModel: SubmissionListModel(upperLowerChoke: "Chokehold", sub: "Rear Naked", date:"Sunday, May 21, 2022", winOrLoss: true))
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
