//
//  ListViewItemSubAreaImage.swift
//  MyBJJ
//
//  Created by Josh Bourke on 4/7/2022.
//

import SwiftUI

struct ListViewItemSubAreaImage: View {
    //MARK: - PROPERTIES
    
    let imageName: String
    let width: CGFloat
    let height: CGFloat
    let offSetY: CGFloat
    
    init(_ imageName: String, width: CGFloat, height: CGFloat, offSetY: CGFloat) {
        self.imageName = imageName
        self.width = width
        self.height = height
        self.offSetY = offSetY
    }
    
    //MARK: - BODY
    var body: some View {
        //In this Swift view file, I am going to try and make something to better show where the submission occured. I am going to try and crop some of the SF symbols for either choke hold, upper body or lower body. To display this on the left hand side of the logged submission list items.
        
        ZStack {
            Image(systemName: imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: width, height: height)
                .offset(y:offSetY)
        }//: ZSTACK
        .cornerRadius(0)
        .frame(width: width, height: height)
        
//        VStack {
//            //This is the one i am looking at cropping to make it able to show either the lower body or the upper body. to better display what has been logged.
//            Image(systemName: "figure.stand")
//                .padding()
//
//            //This person.fill looks like a good fit for chokeholds
//            Image(systemName: "person.fill")
//                .padding()
//        }//: VSTACK
        
        
    }
}
    //MARK: - PREVIEW
struct ListViewItemSubAreaImage_Previews: PreviewProvider {
    static var previews: some View {
        ListViewItemSubAreaImage("figure.stand", width: 100, height: 100, offSetY: -70)
    }
}
