//
//  SubLibraryDetailedViewListItemGroup.swift
//  MyBJJ
//
//  Created by Josh Bourke on 18/8/2022.
//

import SwiftUI

struct SubLibraryDetailedViewListItemGroup: View {
    //MARK: - PROPERTIES
    var titleString: String
    var systemImageName: String
    var captionString: String
    //MARK: - BODY
    var body: some View {
                HStack{
                   Text(titleString)
                        .font(.title)
                        .bold()
                    Spacer()
                    Image(systemName: systemImageName)
                        .foregroundColor(.accentColor)
                        .font(.body.bold())
                }//: HSTACK
                HStack{
                    Text(captionString)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }//:HSTACK
                Divider().padding(.vertical,4)

    }
}

    //MARK: - PREVIEW
struct SubLibraryDetailedViewListItemGroup_Previews: PreviewProvider {
    static var previews: some View {
        SubLibraryDetailedViewListItemGroup(titleString: "Hello World!", systemImageName: "figure.stand", captionString: "This is the caption something about this section will go here!...")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
