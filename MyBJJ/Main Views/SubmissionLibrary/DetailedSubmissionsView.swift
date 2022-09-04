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
    
    //These will be the strings to fill out the infomation for all of the detailed views.
    @State var aboutString: String = ""
    @State var photoString: String = ""
    @State var howToString: String = ""
    
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
                    Text(aboutString)
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
                    Image(systemName: photoString)
                        .resizable()
                        .frame(width: 300, height: 200)
                        .cornerRadius(8)
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
                    Text(howToString)
                }//: VSTACK
            }//: GROUP HOW TO
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
            Spacer()
        }//: VSTACK
        .padding()
        .onAppear(){
            checkSubmissionName(subName: submissionName)
        }
        
    }//SubmissionLibraryDetailViewExtracted.
    //MARK: - FUNC
    //This function will take in the submission name and then check the name against the switch statment. This will then change some of the values in the detail view accordingly.
        func checkSubmissionName(subName: String) {
            let result = subName
            switch result {
            //CHOKEHOLD
            case "Anaconda":
                print("Anaconda Detailed View")
                self.aboutString = "Anaconda Detailed View"
                self.photoString = "photo"
                self.howToString = "Anaconda Detailed View"
                
            case "Arm Triangle":
                print("Arm Triangle Detailed View")
                self.aboutString = "Arm Triangle Detailed View"
                self.photoString = "photo"
                self.howToString = "Arm Triangle Detailed View"
                
            case "Back Triangle":
                print("Back Triangle Detailed View")
                self.aboutString = "Back Triangle Detailed View"
                self.photoString = "photo"
                self.howToString = "Back Triangle Detailed View"
                
            case "Baseball bat":
                print("Baseball Bat Detailed View")
                self.aboutString = "Baseball bat Detailed View"
                self.photoString = "photo"
                self.howToString = "Baseball bat Detailed View"
                
            case "Bulldog Choke":
                print("Bulldog Choke Detailed View")
                self.aboutString = "Bulldog Choke Detailed View"
                self.photoString = "photo"
                self.howToString = "Bulldog Choke Detailed View"
                
            case "Crucifix":
                print("Crucifix Detailed View")
                self.aboutString = "Crucifix Detailed View"
                self.photoString = "photo"
                self.howToString = "Crucifix Detailed View"
                
            case "D'arce":
                print("D'arce Detailed View")
                self.aboutString = "D'arce Detailed View"
                self.photoString = "photo"
                self.howToString = "D'arce Detailed View"
                
            case "Ezekiel":
                print("Ezekiel Detailed View")
                self.aboutString = "Ezekiel Detailed View"
                self.photoString = "photo"
                self.howToString = "Ezekiel Detailed View"
                
            case "Gogoplata":
                print("Gogoplata Detailed View")
                self.aboutString = "Gogoplata Detailed View"
                self.photoString = "photo"
                self.howToString = "Gogoplata Detailed View"
                
            case "Guillotine":
                print("Guillotine Detailed View")
                self.aboutString = "Guillotine Detailed View"
                self.photoString = "photo"
                self.howToString = "Guillotine Detailed View"
                
            case "Inverted Triangle":
                print("Inverted Triangle Detailed View")
                self.aboutString = "Inverted Triangle Detailed View"
                self.photoString = "photo"
                self.howToString = "Inverted Triangle Detailed View"
                
            case "North South":
                print("North South Detailed View")
                self.aboutString = "North South Detailed View"
                self.photoString = "photo"
                self.howToString = "North South Detailed View"
                
            case "Rear Naked":
                print("Rear Naked Detailed View")
                self.aboutString = "Rear Naked Detailed View"
                self.photoString = "photo"
                self.howToString = "Rear Naked Detailed View"
                
            case "Triangle":
                print("Triangle Detailed View")
                self.aboutString = "Triangle Detailed View"
                self.photoString = "photo"
                self.howToString = "Triangle Detailed View"
                
            case "Von Fluke":
                print("Von Fluke Detailed View")
                self.aboutString = "Von Fluke Detailed View"
                self.photoString = "photo"
                self.howToString = "Von Fluke Detailed View"
                
            //UPPER BODY
            case "Americana":
                print("Americana Detailed View")
                self.aboutString = "Americana Detailed View"
                self.photoString = "photo"
                self.howToString = "Americana Detailed View"
                
            case "Arm Bar":
                print("Arm Bar Detailed View")
                self.aboutString = "Arm Bar Detailed View"
                self.photoString = "photo"
                self.howToString = "Arm Bar Detailed View"
                
            case "Arm Crush":
                print("Arm Crush Detailed View")
                self.aboutString = "Arm Crush Detailed View"
                self.photoString = "photo"
                self.howToString = "Arm Crush Detailed View"
                
            case "Kimura":
                print("Kimura Detailed View")
                self.aboutString = "Kimura Detailed View"
                self.photoString = "photo"
                self.howToString = "Kimura Detailed View"
                
            case "Wrist Lock":
                print("Wrist Lock Detailed View")
                self.aboutString = "Wrist Lock Detailed View"
                self.photoString = "photo"
                self.howToString = "Wrist Lock Detailed View"
                
            //LOWER BODY
            case "Calf Slicer":
                print("Calf Slicer Detailed View")
                self.aboutString = "Calf Slicer Detailed View"
                self.photoString = "photo"
                self.howToString = "Calf Slicer Detailed View"
                
            case "Inside Heel Hook":
                print("Inside Heel Hook Detailed View")
                self.aboutString = "Inside Heel Hook Detailed View"
                self.photoString = "photo"
                self.howToString = "Inside Heel Hook Detailed View"
                
            case "Knee Bar":
                print("Knee Bar Detailed View")
                self.aboutString = "Knee Bar Detailed View"
                self.photoString = "photo"
                self.howToString = "Knee Bar Detailed View"
                
            case "Outside Heel Hook":
                print("Outside Heel Hook Detailed View")
                self.aboutString = "Outside Heel Hook Detailed View"
                self.photoString = "photo"
                self.howToString = "Outside Heel Hook Detailed View"
                
            case "Straight Leg Lock":
                print("Straight Leg Lock Detailed View")
                self.aboutString = "Straight Leg Lock Detailed View"
                self.photoString = "photo"
                self.howToString = "Straight Leg Lock Detailed View"
                
            case "Toe Hold":
                print("Toe Hold Detailed View")
                self.aboutString = "Toe Hold Detailed View"
                self.photoString = "photo"
                self.howToString = "Toe Hold Detailed View"
            
            default: ""
                print("Default Value trigger. Detailed View")
                self.aboutString = "Default value triggerd, couldnt find subname"
                self.photoString = "photo"
                self.howToString = "Default value triggerd, couldnt find subname"
            }
        }
}

    //MARK: - PREVIEW
struct DetailedSubmissionsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedSubmissionsView(submissionName: "Rear Naked", subArea: "Chokehold")
    }
}
