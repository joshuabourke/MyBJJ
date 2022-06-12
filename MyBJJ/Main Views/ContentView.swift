//
//  ContentView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 12/4/22.
//

import SwiftUI


struct ContentView: View {
    //MARK: - PROPERTIES
    @State private var isNewBJJItemOpen: Bool = false
    @State private var winMoreThanZero: Bool = false
    @State private var lossMoreThanZero: Bool = false
    
    //MARK: - UPDATING STAT VIEW (From main view)
    @State private var currentTab = 0
    @StateObject var vm = AddingNewSubViewModel(myBJJUser: .init(data: ["uid" : "bQsUeLnTOXg27Bp06PaUayRXQv82", "email": "josh@gmail.com"]))
    @StateObject var subListVM = SubListViewModel()
    //MARK: - BODY
    var body: some View {
        TabView(selection: $currentTab){
                SubListView()
                    .tabItem {
                        Text("Saved")
                        Image(systemName: "bookmark")
                    }
                    .onAppear(){
                            self.currentTab = 0
                        }
                    .tag(0)
                StatsView()
                    .tabItem {
                        Text("Stats")
                        Image(systemName: "text.alignleft")
                    }
                    .tag(1)
                    .onAppear() {
                        self.currentTab = 1
                        self.vm.fetchAllStats()
                    }
            }
            .environmentObject(vm)
            .environmentObject(subListVM)
            .ignoresSafeArea(edges: .bottom)

    }

}
    //MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
