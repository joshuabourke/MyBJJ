//
//  DetailedSubmissionsView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 16/8/2022.
//

import SwiftUI

struct DetailedSubmissionsView: View {
    //MARK: - PROPERTIES
    //This is to tell if it is light or dark mode.
    @Environment(\.colorScheme) var colorScheme
    
    //These 2 strings will take the input for either the submission and the area it can be performed
    var submissionName: String
    var subArea: String
    
    //MARK: - BODY
    var body: some View {
            VStack {
                ScrollView(showsIndicators: false){
                        submissionLibraryDetailViewExtracted
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(colorScheme == .dark ? Color.black: Color(UIColor.secondarySystemBackground))
                            .ignoresSafeArea()
                    }//: SCROLL
                Spacer()
                    .navigationTitle(submissionName)
            }//: VSTACK
    }
    //MARK: - EXTRACTED VIEW
    private var submissionLibraryDetailViewExtracted: some View {
        VStack{
            //MARK: - ABOUT GROUP
            Group{
                VStack{
                    SubLibraryDetailedViewListItemGroup(titleString: "About", systemImageName: "info.circle", captionString: "More about \(submissionName)")
                    Text("More Stuff will be going here")
                }//: VSTACK
            }//: GROUP ABOUT
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
            
            Spacer()
            //MARK: - PHOTO GROUPING
            Group{
                VStack{
                    SubLibraryDetailedViewListItemGroup(titleString: "Photo", systemImageName: "photo", captionString: "This is a photo of a \(submissionName)")
                    Text("Some more stuff will go here")
                }//: VSTACK
            }//: GROUP PHOTO
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.tertiarySystemBackground)
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
            
            
            Spacer()
            //MARK: - HOW TO GROUPING
            Group {
                VStack{
                    SubLibraryDetailedViewListItemGroup(titleString: "How To", systemImageName: "questionmark.circle", captionString: "How to perform \(submissionName)")
                    Text("This will show some stuff here")
                    
                }//: VSTACK
            }//: GROUP HOW TO
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
            Spacer()
        }//: VSTACK
        .padding()
        
    }//SubmissionLibraryDetailViewExtracted.
}
    //MARK: - PREVIEW
struct DetailedSubmissionsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedSubmissionsView(submissionName: "Rear Naked", subArea: "Chokehold")
    }
}
