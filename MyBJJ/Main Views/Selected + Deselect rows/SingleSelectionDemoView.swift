//
//  SingleSelectionDemoView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 14/4/22.
//

import SwiftUI

struct SingleSelectionDemoView: View {
    //MARK: - PROPERTIES
    
    var items = ["josh", "izzy", "zenith", "jack","lucy", "jasmine"]
    
    
    @State var selectedItem: String = ""
    //MARK: - BODY
    var body: some View {
        NavigationView {
            List {
                ForEach(items, id: \.self) { item in
                    CustomRowSelectionTest(title: item, selectedItem: $selectedItem) { title in
                        print(title)
                    }
                }
            }
            .listStyle(.inset)
            .navigationTitle("Friends")
        }
    }
}
    //MARK: - PREVIEW
struct SingleSelectionDemoView_Previews: PreviewProvider {
    static var previews: some View {
        SingleSelectionDemoView()
    }
}
