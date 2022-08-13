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
            noGiSubmissionListItem
    }
    //Separating these into 2 private(Gi and NoGi) view variables to make the body less cluttered.
    private var noGiSubmissionListItem: some View {
        VStack(alignment: .leading) {
            HStack(alignment:.center){
                VStack{
                    HStack{
                        ZStack {
                            let checkAreaOfSubmission = checkSubmissionArea()
                            Image(systemName: "figure.stand")
                                .renderingMode(.template)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.accentColor)
                            ListViewItemSubAreaImage("figure.stand", width: 20, height: 20, offSetY: checkAreaOfSubmission.1)
                                .offset(y:checkAreaOfSubmission.0)
                            //ListViewItemSubAreaImage off set 0 with width and height 20 will indicate body.
                            
                            //ListViewItemSubAreaImage offset 15 with offset -15 on ListViewItemSubAreaImage with width and height 20 to show an attack to the head or a choke hold
                            
                            //ListViewItemSubAreaImage offset -17.5 with offset 17.5 on ListViewItemSubAreaImage with width and height 20 to show an attack to the lowerbody or legs.
                                .foregroundColor(submissionListModel.winOrLoss ? .green : .red)
                        }//: ZSTACK
                            
                            
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
    
    //MARK: - FUNCTIONS
    //The idea behind this func is to read the of the submission. Where on the body has it been performed and then place the new affected area cropped  image offset over that area.
    
    //This function is quite successful in showing more detail where the submission was performed.
    //Now to use this same sort of function but in a larger scale for a stat view.
    //This function checks to see what subtype the user has selected. Then displays a coloured cropped portion of the figure stand SF symbol over the top of the default blue one.
    func checkSubmissionArea() -> (CGFloat, CGFloat) {
        
        var offsetY: CGFloat = 0
        
        var listViewItemSubAreaImageOffsetY: CGFloat = 0
        
        if submissionListModel.upperLowerChoke == "Chokehold" {
            listViewItemSubAreaImageOffsetY = 15
            offsetY = -15
        }
        else if submissionListModel.upperLowerChoke == "Upper Body" {
            listViewItemSubAreaImageOffsetY = 1
            offsetY = -1
        }
        else if submissionListModel.upperLowerChoke == "Lower Body" {
            listViewItemSubAreaImageOffsetY = -17.5
            offsetY = 17.5
        }
        
        return (offsetY, listViewItemSubAreaImageOffsetY)
    }
}

struct SubmissionListRowGi: View {
    //MARK: - PROPERTIES
    let todaysDate = Date().formatDate()
    @State var submissionListModel: SubmissionListModel
    //MARK: - BODY
    var body: some View {
        giSubmissionListItem
    }
    private var giSubmissionListItem: some View {
        VStack(alignment: .leading) {
            HStack(alignment:.center){
                VStack{
                    HStack{
                        ZStack {
                            let checkAreaOfSubmission = checkSubmissionArea()
                            Image("giman")
                                .resizable()
                                .renderingMode(.template)
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                                .foregroundColor(.accentColor)
                            ListViewItemSubAreaGIImage("giman", widthGi: 20, heightGi: 20, offSetYGi: checkAreaOfSubmission.1)
                                .offset(y:checkAreaOfSubmission.0)
                            //ListViewItemSubAreaImage off set 0 with width and height 20 will indicate body.
                            
                            //ListViewItemSubAreaImage offset 15 with offset -15 on ListViewItemSubAreaImage with width and height 20 to show an attack to the head or a choke hold
                            
                            //ListViewItemSubAreaImage offset -17.5 with offset 17.5 on ListViewItemSubAreaImage with width and height 20 to show an attack to the lowerbody or legs.
                                .foregroundColor(submissionListModel.winOrLoss ? .green : .red)
                        }//: ZSTACK
                            
                            
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
    //MARK: - FUNCTIONS
    //The idea behind this func is to read the of the submission. Where on the body has it been performed and then place the new affected area cropped  image offset over that area.
    
    //This function is quite successful in showing more detail where the submission was performed.
    //Now to use this same sort of function but in a larger scale for a stat view.
    //This function checks to see what subtype the user has selected. Then displays a coloured cropped portion of the figure stand SF symbol over the top of the default blue one.
    func checkSubmissionArea() -> (CGFloat, CGFloat) {
        
        var offsetY: CGFloat = 0
        
        var listViewItemSubAreaImageOffsetY: CGFloat = 0
        
        if submissionListModel.upperLowerChoke == "Chokehold" {
            listViewItemSubAreaImageOffsetY = 15
            offsetY = -15
        }
        else if submissionListModel.upperLowerChoke == "Upper Body" {
            listViewItemSubAreaImageOffsetY = 1
            offsetY = -1
        }
        else if submissionListModel.upperLowerChoke == "Lower Body" {
            listViewItemSubAreaImageOffsetY = -17.5
            offsetY = 17.5
        }
        
        return (offsetY, listViewItemSubAreaImageOffsetY)
    }
}
    
    //MARK: - PREVIEW
struct SubmissionListRow_Previews: PreviewProvider {
    static var previews: some View {
        
        SubmissionListRowChokes(submissionListModel:SubmissionListModel(upperLowerChoke: "Chokehold", sub: "Rear Naked", date:"Sunday, May 21, 2022", winOrLoss: true))
        
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
