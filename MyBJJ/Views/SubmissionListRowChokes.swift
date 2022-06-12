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
        VStack(alignment: .leading, spacing: 2) {
            HStack{
                Group{
                    Image(systemName: "figure.stand")
                        .foregroundColor(submissionListModel.winOrLoss ? .accentColor : .red)
                        .font(.system(size: 20))
                    Text("Submission")
                        .foregroundColor(submissionListModel.winOrLoss ? .accentColor : .red)
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                    Spacer()
                    Text(submissionListModel.sub)
                        .font(.system(size: 20))
                        .bold()
                        
                }//: GROUP
            }//: HSTACK
            .padding(4)
            Divider()
            HStack {
                Group{
                    Image(systemName: "info.circle")
                        .foregroundColor(submissionListModel.winOrLoss ? .accentColor : .red)
                        .font(.system(size: 12))
                    Text("Sub Type")
                        .foregroundColor(submissionListModel.winOrLoss ? .accentColor : .red)
                        .font(.system(size: 12))
                        .fontWeight(.bold)
                    Spacer()
                    Text(submissionListModel.upperLowerChoke)
                        .font(.system(size: 12))
                        .bold()
                        
                }//: GROUP
            }//: HSTACK
            .padding(4)

            HStack{
                
                Text(submissionListModel.date)
                    .font(.system(size: 10))
                    .foregroundColor(.secondary.opacity(0.5))
                Spacer()
            }//: HSTACK
            .padding(4)
        }//: VSTACK
        .padding(4)
        .clipShape(RoundedRectangle(cornerRadius: 16))

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
