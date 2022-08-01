//
//  TestingNewGiGraphic.swift
//  MyBJJ
//
//  Created by Josh Bourke on 30/7/2022.
//

import SwiftUI

struct TestingNewGiGraphic: View {
    //MARK: - PROPERTIES

    
    //MARK: - BODY
    var body: some View {
        let mailtoLink = "mailto:mybjj.apphelp@gmail.com".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let mailtoURL = URL(string: mailtoLink!)!

        
        Link("Submit feedback", destination: mailtoURL)
    }
}

//MARK: - PREVIEW
struct TestingNewGiGraphic_Previews: PreviewProvider {
    static var previews: some View {
        TestingNewGiGraphic()
    }
}
