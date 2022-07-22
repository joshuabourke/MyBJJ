//
//  StatsView.swift
//  MyBJJ
//
//  Created by Josh Bourke on 28/4/22.
//

import SwiftUI

struct StatsView: View {
    //MARK: - PROPERTIES
    
    var subVM = SubViewModel()
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var subListVM: SubListViewModel
    @EnvironmentObject var vm: AddingNewSubViewModel
    @State var arrayOfWinSubmissions: [String] = []
    @State var arrayOfLossSubmissions: [String] = []
    @State var mostCommonWin: String = ""
    @State var mostCommonLoss: String = ""
    @Binding var tabSelection: Int
    @Binding var openProfileFromStats: Bool

    //MARK: - BODY
    var body: some View {
        NavigationView {
            
                statsExtractedView

            .navigationBarTitle("Stats")
        }//: NAVIGATION
        
        .onAppear(){
            arrayOfWinSubs()
            arrayOfLossSubs()
            mostCommonLoss = mostSuccessfulSub(stringArray: arrayOfLossSubmissions)
            mostCommonWin = mostSuccessfulSub(stringArray: arrayOfWinSubmissions)
            print(arrayOfWinSubmissions)
            print("Most Common Win: \(mostCommonWin)")
            print("Most Common Loss: \(mostCommonLoss)")
        }
        
    }
    //MARK: - EXTRACTED VIEW
    private var statsExtractedView: some View {
        
            ScrollView{
                VStack {
                //This massive if statement is to check to see if the user is signed in or not. If not it will prompt the user to login back in. If the user is signed in they will be shown either their stats or... They will be shown No Stats recorded. This will prompt them to start logging their progress.
                if !subListVM.isUserCurrentlyLoggedOut {
                    Group{
                        HStack(alignment: .top){
                            StatsTextView(titleName: "Most Successful", valueName: mostSuccessfulSub(stringArray: arrayOfWinSubmissions))
                            StatsTextView(titleName: "Least Successful", valueName: mostSuccessfulSub(stringArray: arrayOfLossSubmissions))
                        }//: HSTACK (Text Stat Views)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
                    .padding(.horizontal)
                    
                    
                    VStack(alignment:.leading){
                        //MARK: - PIE GRAPH
                        //This if statement will check to see if any of the subtype sections are greater than 0. If they are it will change from no recorded subs to start off a pie chart.
                        if (vm.chokeHoldWinsStruct.count > 0) || (vm.upperBodyWinsStruct.count > 0) || vm.lowerBodyWinsStruct.count > 0{
                            VStack(alignment: .center) {
                                
                                HStack{
                                    Spacer()
                                    Text("Wins")
                                        .font(.system(size: 12).bold())
                                        
                                    PieChartViewRender(values: [Double(vm.chokeHoldWinsStruct.count), Double(vm.upperBodyWinsStruct.count), Double(vm.lowerBodyWinsStruct.count)], colors: subVM.colors, names: subVM.names, backgroundColor: Color.clear, innerRadiusFraction: 0.6)
                                    PieChartLegend(colors: subVM.colors, numOfChokeHold: vm.chokeHoldWinsStruct.count, numOfUpperBody: vm.upperBodyWinsStruct.count, numOfLowerBody: vm.lowerBodyWinsStruct.count)
                                        
                                    Spacer()
                                }//: HSTACK
                                .padding(.vertical)
                                .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
                                .padding(.horizontal)
                                
                            }//: VSTACK

                            //MARK: - GRAPH RIGHT SIDE (DESCRIPTION)
                        }//: IF GRAPH IS LESS THAN 0
                        //                        }//: IF GRAPH IS LESS THAN 0
                        else {
                            VStack {
                                //This will show that the user hasnt recorded any wins yet into MyBJJ, but the user is signed in.
                                Spacer()
                                HStack(alignment: .center) {
                                    Spacer()
                                    Text("No Wins")
                                        .font(.title3.bold())
                                    Spacer()
                                }//: HSTACK
                                .padding()
                                Spacer()
                            }//: VSTACK
                        }
                        //MARK: - LOSS PIE GRAPH
                        //MARK: - PIE GRAPH
                        //This will show a break down of losses the user has logged into MyBJJ. This will be displayed by using a pie graph
                        //This will also check to see if the subtype in the data base if greater than 0 basically if someone has logged a loss into their account. Then display a pie chart.
                        if (vm.chokeHoldLossStruct.count > 0) || (vm.upperBodyLossStruct.count > 0) || vm.lowerBodyLossStruct.count > 0{
                            VStack(alignment: .center) {
                                HStack {
                                    Spacer()
                                    Text("Loss")
                                        .font(.system(size: 12).bold())
                                        
                                    PieChartViewRender(values: [Double(vm.chokeHoldLossStruct.count), Double(vm.upperBodyLossStruct.count), Double(vm.lowerBodyLossStruct.count)], colors: subVM.colorsLoss, names: subVM.names, backgroundColor: Color.clear, innerRadiusFraction: 0.6)
                                    PieChartLegend(colors: subVM.colorsLoss, numOfChokeHold: vm.chokeHoldLossStruct.count, numOfUpperBody: vm.upperBodyLossStruct.count, numOfLowerBody: vm.lowerBodyLossStruct.count)
                                        
                                    Spacer()
                                }//: HSTACK
                                .padding(.vertical)
                                .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
                                .padding(.horizontal)
                                
                            }//: VSTACK
                            
                            
                            //MARK: - GRAPH RIGHT SIDE (DESCRIPTION)
                        }//: IF GRAPH IS LESS THAN 0
                        else {
                            //This is to show that the user is logged in but they have no recorded any losses
                            VStack {
                                Spacer()
                                HStack(alignment: .center) {
                                    Spacer()
                                    Text("No Losses")
                                        .font(.title3.bold())
                                    Spacer()
                                }//: HSTACK
                                .padding()
                                Spacer()
                            }//: VSTACK
                        }
                    }//: VSTACK

                } else {
                    Group {
                        VStack {
                            //This is to show the user that they need to login when the stats field is nil. The stats field will show  that they currently have no stats recorded when they are actually logged in with no stats present.
                            Text("To start collecting your stats for MyBJJ make sure you...")
                                .font(.body.bold())
                                .multilineTextAlignment(.center)
                                .padding()
                            Button {
                                //With this button i want the user to be taken back to the main screen. The one that will display the list of the submissions they have logged. Then I would like it to navigate to the profile view to make them login first.
                                //1. go back to stat view tab
                                tabSelection = 0
                                //2. pop open the profile view for them to log in.
                                openProfileFromStats.toggle()
                                print("This button should take the user to the login screen")
                                
                            } label: {
                                Image(systemName: "person.fill")
                                    .font(.body.bold())
                                Text("Login")
                                    .bold()
                        }
                            .buttonStyle(RectangleButton())
                            .frame(width: 120, height: 45)
                        }//: VSTACK
                    }//:GROUP
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.vertical)
                    .background(Color(UIColor.tertiarySystemBackground).clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous)))
                    .padding(.horizontal)
                    
                }
            }//: VSTACK
                
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.vertical)
                .padding(.bottom,40)
                .background(colorScheme == .dark ? Color.black: Color(UIColor.secondarySystemBackground))
                
                .ignoresSafeArea()
                
        }//: SCROLL
    }
    
    //MARK: - FUNCTIONS
    func mostSuccessfulSub(stringArray: [String]) -> String{
        let stringArray = stringArray.reduce(into: [:]) { (counts, strings) in
            counts[strings, default: 0] += 1
        }
        return stringArray.sorted(by: {$0.value > $1.value}).first?.key ?? ""
    }
    func arrayOfWinSubs() -> [String] {
        for sub in vm.submissions {
            if sub.winOrLoss == "Win"{
                arrayOfWinSubmissions.append(sub.sub)
            }
        }
        return arrayOfWinSubmissions
    }
    
    func arrayOfLossSubs() -> [String] {
        for sub in vm.submissions {
            if sub.winOrLoss == "Loss"{
                arrayOfLossSubmissions.append(sub.sub)
            }
        }
        return arrayOfLossSubmissions
    }
}


    //MARK: - PREVIEW
struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
//        StatsView(lossStatLessThanZero: false, winStatLessThanZero: false, vm: AddingNewSubViewModel(myBJJUser: .init(data: ["uid" : "bQsUeLnTOXg27Bp06PaUayRXQv82", "email": "josh@gmail.com"])))
        StatsView(tabSelection: .constant(1), openProfileFromStats: .constant(false))
            .environmentObject(AddingNewSubViewModel(myBJJUser: .init(data: ["uid" : "bQsUeLnTOXg27Bp06PaUayRXQv82", "email": "josh@gmail.com"])))
            .environmentObject(SubListViewModel())
    }
}
