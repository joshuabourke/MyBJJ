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
    @EnvironmentObject var subListVM: SubListViewModel
    @EnvironmentObject var vm: AddingNewSubViewModel
    
//    @ObservedObject var vm = AddingNewSubViewModel(myBJJUser: .init(data: ["uid" : "bQsUeLnTOXg27Bp06PaUayRXQv82", "email": "josh@gmail.com"]))
    //MARK: - BODY
    var body: some View {
        NavigationView {
            if !subListVM.isUserCurrentlyLoggedOut {
                VStack(alignment:.leading){
                    //MARK: - PIE GRAPH
                    if (vm.chokeHoldWinsStruct.count > 0) || (vm.upperBodyWinsStruct.count > 0) || vm.lowerBodyWinsStruct.count > 0{
                        VStack {
                            Spacer()
                            HStack(alignment:.center) {
                                Text("Wins")
                                    .font(.system(size: 12).bold())
                                    .padding()
                                PieChartViewRender(values: [Double(vm.chokeHoldWinsStruct.count), Double(vm.upperBodyWinsStruct.count), Double(vm.lowerBodyWinsStruct.count)], colors: subVM.colors, names: subVM.names, backgroundColor: Color.clear, innerRadiusFraction: 0.6)
                                PieChartLegend(colors: subVM.colors, numOfChokeHold: vm.chokeHoldWinsStruct.count, numOfUpperBody: vm.upperBodyWinsStruct.count, numOfLowerBody: vm.lowerBodyWinsStruct.count)
                                    .padding()
                            }//: HSTACK
                            Spacer()
                        }//: VSTACK
                        
                        //MARK: - GRAPH RIGHT SIDE (DESCRIPTION)
                    }//: IF GRAPH IS LESS THAN 0
                    //                        }//: IF GRAPH IS LESS THAN 0
                    else {
                        VStack {
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
                    Divider()
                    //MARK: - LOSS PIE GRAPH
                    //MARK: - PIE GRAPH
                    if (vm.chokeHoldLossStruct.count > 0) || (vm.upperBodyLossStruct.count > 0) || vm.lowerBodyLossStruct.count > 0{
                        VStack {
                            Spacer()
                            HStack(alignment:.center) {
                                Text("Loss")
                                    .font(.system(size: 12).bold())
                                    .padding()
                                PieChartViewRender(values: [Double(vm.chokeHoldLossStruct.count), Double(vm.upperBodyLossStruct.count), Double(vm.lowerBodyLossStruct.count)], colors: subVM.colorsLoss, names: subVM.names, backgroundColor: Color.clear, innerRadiusFraction: 0.6)
                                PieChartLegend(colors: subVM.colorsLoss, numOfChokeHold: vm.chokeHoldLossStruct.count, numOfUpperBody: vm.upperBodyLossStruct.count, numOfLowerBody: vm.lowerBodyLossStruct.count)
                                    .padding()
                            }//: HSTACK
                            Spacer()
                        }//: VSTACK
                        
                        //MARK: - GRAPH RIGHT SIDE (DESCRIPTION)
                    }//: IF GRAPH IS LESS THAN 0
                    else {
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
                .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height)
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(20)
                .padding(8)
                .shadow(radius: 10)
                .navigationTitle("Stats")
            } else {
                Button {
                    print("Testing Stats")
                } label: {
                    Text("Testing out logins")
                }
                
            }
        }//: NAVIGATION
    }
}


    //MARK: - PREVIEW
struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
//        StatsView(lossStatLessThanZero: false, winStatLessThanZero: false, vm: AddingNewSubViewModel(myBJJUser: .init(data: ["uid" : "bQsUeLnTOXg27Bp06PaUayRXQv82", "email": "josh@gmail.com"])))
        StatsView()
            .environmentObject(AddingNewSubViewModel(myBJJUser: .init(data: ["uid" : "bQsUeLnTOXg27Bp06PaUayRXQv82", "email": "josh@gmail.com"])))
            .environmentObject(SubListViewModel())
    }
}
