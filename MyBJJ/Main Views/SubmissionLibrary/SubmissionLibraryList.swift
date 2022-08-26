//
//  SubmissionLibraryList.swift
//  MyBJJ
//
//  Created by Josh Bourke on 23/8/2022.
//

import SwiftUI

struct SubmissionLibraryList: View {
    //MARK: - PROPERTIES
    //These are Arrays that have all of the submissions in the app
    var chokeHolds = ["Rear Naked", "Arm Triangle", "Triangle" ,"Guillotine", "Ezekiel", "Baseball bat", "D'arce", "North South", "Crucifix" ,"Anaconda", "Gogoplata", "Von Fluke", "Bulldog Choke", "Inverted Triangle", "Back Triangle"].sorted()

    var upperBody = ["Arm Bar", "Wrist Lock", "Americana", "Kimura", "Arm Crush"].sorted()

    var lowerBody = ["Straight Leg Lock", "Toe Hold", "Knee Bar" ,"Calf Slicer", "Inside Heel Hook", "Outside Heel Hook"].sorted()
    
    //MARK: - BODY
    var body: some View {
        NavigationView {
            List{
                //MARK: - CHOKEHOLD SECTION
                Section {
                    ForEach(chokeHolds, id:\.self) { chokehold in
                        NavigationLink(destination: DetailedSubmissionsView(submissionName: chokehold, subArea: "Chokehold")){
                            Text(chokehold)
                                .font(.body.bold())
                        }//: LINK
                    }//: FOREACH
                } header: {
                    Text("Chokehold")
                        
                    Image(systemName: "figure.stand")
                        .foregroundColor(.accentColor)
                }
                //MARK: - UPPER BODY SECTION
                Section {
                    ForEach(upperBody, id: \.self) { upperBody in
                        Text(upperBody)
                            .font(.body.bold())
                    }//: FOREACH
                } header: {
                    Text("Upper Body")
                        
                    Image(systemName: "figure.stand")
                        .foregroundColor(.accentColor)
                }
                //MARK: - LOWER BODY SECTION
                Section {
                    ForEach(lowerBody, id:\.self) { lowerBody in
                        Text(lowerBody)
                            .font(.body.bold())
                    }//: FOREACH
                } header: {
                    Text("Lower Body")
                        
                    Image(systemName: "figure.stand")
                        .foregroundColor(.accentColor)
                }
            }//: LIST
            .listStyle(.sidebar)
            .navigationTitle("Sub Library")
        }//: NAVIGATION
    }
}
    
    //MARK: - PREVIEW
struct SubmissionLibraryList_Previews: PreviewProvider {
    static var previews: some View {
        SubmissionLibraryList()
    }
}
