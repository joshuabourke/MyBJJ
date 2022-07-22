//
//  ContentView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 12/4/22.
//

import SwiftUI


struct ContentView: View {
    //I am trying to figure out how to send the user from stats view across into the sub list view and then toggle the login screen.
    
    //MARK: - PROPERTIES
    @State private var isNewBJJItemOpen: Bool = false
    @State private var winMoreThanZero: Bool = false
    @State private var lossMoreThanZero: Bool = false
    
    //These 2 state var's are used to open the profile view from the stat view.
    @State private var currentTab = 0
    @State private var openProfileView: Bool = false
    //MARK: - UPDATING STAT VIEW (From main view)
    @StateObject var vm = AddingNewSubViewModel(myBJJUser: .init(data: ["uid" : "bQsUeLnTOXg27Bp06PaUayRXQv82", "email": "josh@gmail.com"]))
    @StateObject var subListVM = SubListViewModel()
    //MARK: - BODY
    var body: some View {
        TabView(selection: $currentTab){
            SubListView(needsToLogin: $openProfileView)
                    .tabItem {
                        Text("Saved")
                        Image(systemName: "bookmark")
                    }
                    .onAppear(){
                            self.currentTab = 0
                        }
                    .tag(0)
            StatsView(tabSelection: $currentTab, openProfileFromStats: $openProfileView)
                    .tabItem {
                        Text("Stats")
                        Image(systemName: "align.vertical.bottom.fill")
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
            .onAppear(){
                
                //The below code will ask the user to allow notifications. It will also remove the badge from the corner of the app once the user has opened it.
                NotificationManager.instance.requestAuthorization()
                UIApplication.shared.applicationIconBadgeNumber = 0
            }
    }

}
    //MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
