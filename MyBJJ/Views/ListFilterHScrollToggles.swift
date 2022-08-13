//
//  ListFilterHScrollToggles.swift
//  MyBJJ
//
//  Created by Josh Bourke on 9/8/2022.
//

import SwiftUI

struct ListFilterHScrollToggles: View {
    //MARK: - PROPERTIES
    //This view is filter all of the submissions in the list, these submissions are added by the user at the submission list view.
    @EnvironmentObject var vm: AddingNewSubViewModel
    
    @Binding var giUpperIsOn: Bool
    @Binding var giLowerIsOn: Bool
    @Binding var giChokeIsOn: Bool
    @Binding var noGiUpperIsOn: Bool
    @Binding var noGiLowerIsOn: Bool
    @Binding var noGiChokeIsOn: Bool
    @Binding var all: Bool
    @Binding var filterWins: Bool
    @Binding var filterLosses: Bool
    @Binding var doesHaveGiOrNoGiField: Bool
    //This is the idea I have to use the toggle to set the strings according to what has been activated. This will use the toggle to then set the search term strings over in the submission list view. This then "should" then filter the list.
    @Binding var upperChokeLowerSearchTermPassed: String
    @Binding var giOrNoGiSearchTermPassed: String
    @Binding var winOrLossSearchTermPassed: String
    //MARK: - BODY
    
    //The for some reason changing the search index to a different string value instead of nil works better than just leaving it empty e.g "" Could be to do with setting the hasprefix instead of contains.
    var body: some View {
        HStack {
            Text("Filter: ")
                .font(.body.bold())
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ToggleButton(isOn: $all, title: "All")
                        .onChange(of: all) { newValue in
                            if all {
                                giUpperIsOn = false
                                giLowerIsOn = false
                                giChokeIsOn = false
                                noGiUpperIsOn = false
                                noGiLowerIsOn = false
                                noGiChokeIsOn = false
                                filterWins = false
                                filterLosses = false
                                upperChokeLowerSearchTermPassed = ""
                                giOrNoGiSearchTermPassed = ""
                                winOrLossSearchTermPassed = ""
                            } else {
                                print("Filter All Off")
                            }
                        }
                    Group{
                        ToggleButton(isOn: $filterWins, title: "Win")
                            .onChange(of: filterWins) { newValue in
                                if filterWins {
                                    all = false

                                    filterLosses = false
                                    giUpperIsOn = false
                                    giLowerIsOn = false
                                    giChokeIsOn = false
                                    noGiUpperIsOn = false
                                    noGiLowerIsOn = false
                                    noGiChokeIsOn = false
                                    winOrLossSearchTermPassed = "Win"
                                    upperChokeLowerSearchTermPassed = "1"
                                    giOrNoGiSearchTermPassed = "1"
                                } else {
                                    makeSureAllTurnedOff()
                                    print("Filter Wins Off")
                                }
                            }
                        ToggleButton(isOn: $filterLosses, title: "Loss")
                            .onChange(of: filterLosses) { newValue in
                                if filterLosses {
                                    all = false
                                    filterWins = false
                                    giUpperIsOn = false
                                    giLowerIsOn = false
                                    giChokeIsOn = false
                                    noGiUpperIsOn = false
                                    noGiLowerIsOn = false
                                    noGiChokeIsOn = false
                                    winOrLossSearchTermPassed = "Loss"
                                    upperChokeLowerSearchTermPassed = "1"
                                    giOrNoGiSearchTermPassed = "1"
                                } else {
                                    makeSureAllTurnedOff()
                                    print("Filter Losses Off")
                                }
                            }
                    }//: WIN AND LOSS FILTER GROUP
                    Group{
                        ToggleButton(isOn: $giUpperIsOn, title: "Gi Upper")
                            .onChange(of: giUpperIsOn) { newValue in
                                if giUpperIsOn {
                                    all = false
                                    giLowerIsOn = false
                                    giChokeIsOn = false
                                    noGiUpperIsOn = false
                                    noGiLowerIsOn = false
                                    noGiUpperIsOn = false
                                    filterWins = false
                                    filterLosses = false
                                    doesHaveGiOrNoGiField = true
                                    upperChokeLowerSearchTermPassed = "Upper Body"
                                    giOrNoGiSearchTermPassed = "Gi"
                                    winOrLossSearchTermPassed = "1"
                                } else {
                                    makeSureAllTurnedOff()
                                    print("Filter giUpperIsOn Off")
                                }
                            }
                        
                        ToggleButton(isOn: $giLowerIsOn, title: "Gi Lower")
                            .onChange(of: giLowerIsOn) { newValue in
                                if giLowerIsOn {
                                    all = false
                                    giUpperIsOn = false
                                    giChokeIsOn = false
                                    noGiUpperIsOn = false
                                    noGiLowerIsOn = false
                                    noGiUpperIsOn = false
                                    filterWins = false
                                    filterLosses = false
                                    doesHaveGiOrNoGiField = true
                                    upperChokeLowerSearchTermPassed = "Lower Body"
                                    giOrNoGiSearchTermPassed = "Gi"
                                    winOrLossSearchTermPassed = "1"
                                } else {
                                    makeSureAllTurnedOff()
                                    print("Filter giLowerIsOn Off")
                                }
                            }
                        ToggleButton(isOn: $giChokeIsOn, title: "Gi Choke")
                            .onChange(of: giChokeIsOn) { newValue in
                                if giChokeIsOn {
                                    all = false
                                    giUpperIsOn = false
                                    giLowerIsOn = false
                                    noGiUpperIsOn = false
                                    noGiLowerIsOn = false
                                    noGiChokeIsOn = false
                                    filterWins = false
                                    filterLosses = false
                                    doesHaveGiOrNoGiField = true
                                    upperChokeLowerSearchTermPassed = "Chokehold"
                                    giOrNoGiSearchTermPassed = "Gi"
                                    winOrLossSearchTermPassed = "1"
                                } else {
                                    makeSureAllTurnedOff()
                                    print("Filter giChokeIsOn Off")
                                }
                            }
                    }//: GI BODY AREA FILTERS GROUP
                    Group{
                        ToggleButton(isOn: $noGiUpperIsOn, title: "NoGi Upper")
                            .onChange(of: noGiUpperIsOn) { newValue in
                                if noGiUpperIsOn {
                                    all = false
                                    giUpperIsOn = false
                                    giLowerIsOn = false
                                    giChokeIsOn = false
                                    noGiLowerIsOn = false
                                    noGiChokeIsOn = false
                                    filterWins = false
                                    filterLosses = false
                                    doesHaveGiOrNoGiField = false
                                    upperChokeLowerSearchTermPassed = "Upper Body"
                                    giOrNoGiSearchTermPassed = "NoGi"
                                    winOrLossSearchTermPassed = "1"
                                } else {
                                    makeSureAllTurnedOff()
                                    print("Filter noGiUpperIsOn Off")
                                }
                            }
                        ToggleButton(isOn: $noGiLowerIsOn, title: "NoGi Lower")
                            .onChange(of: noGiLowerIsOn) { newValue in
                                if noGiLowerIsOn {
                                    all = false
                                    giUpperIsOn = false
                                    giLowerIsOn = false
                                    giChokeIsOn = false
                                    noGiChokeIsOn = false
                                    noGiUpperIsOn = false
                                    filterWins = false
                                    filterLosses = false
                                    doesHaveGiOrNoGiField = false
                                    upperChokeLowerSearchTermPassed = "Lower Body"
                                    giOrNoGiSearchTermPassed = "NoGi"
                                    winOrLossSearchTermPassed = "1"
                                } else {
                                    makeSureAllTurnedOff()
                                    print("Filter noGiLowerIsOn Off")
                                }
                            }
                        ToggleButton(isOn: $noGiChokeIsOn, title: "NoGi Choke")
                            .onChange(of: noGiChokeIsOn) { newValue in
                                if noGiChokeIsOn {
                                    all = false
                                    giUpperIsOn = false
                                    giLowerIsOn = false
                                    giChokeIsOn = false
                                    noGiLowerIsOn = false
                                    noGiUpperIsOn = false
                                    filterWins = false
                                    filterLosses = false
                                    doesHaveGiOrNoGiField = false
                                    upperChokeLowerSearchTermPassed = "Chokehold"
                                    giOrNoGiSearchTermPassed = "NoGi"
                                    winOrLossSearchTermPassed = "1"
                                } else {
                                    makeSureAllTurnedOff()
                                    print("Filter noGiChokeIsOn Off")
                                }
                            }
                    }//: NOGI BODY AREA FILTERS GROUP
                }//: HSTACK
            }//: HSCROLL
        }//: HSTACK
        .padding()
        .onAppear(){
            all = true
        }
    }//: BODY
    //MARK: - FUNCTION
    //This function just makes sure all of the following toggle are turned off, then it will make the filter go back showing the user all of the submissions.
    func makeSureAllTurnedOff(){
        if !giUpperIsOn, !giChokeIsOn, !giLowerIsOn, !noGiChokeIsOn, !noGiLowerIsOn, !noGiUpperIsOn, !filterWins, !filterLosses {
            all = true
            upperChokeLowerSearchTermPassed = ""
            giOrNoGiSearchTermPassed = ""
            winOrLossSearchTermPassed = ""
        }
    }
}

    //MARK: - PREVIEW
struct ListFilterHScrollToggles_Previews: PreviewProvider {
    static var previews: some View {
        ListFilterHScrollToggles(giUpperIsOn: .constant(false), giLowerIsOn: .constant(false), giChokeIsOn: .constant(false), noGiUpperIsOn: .constant(false), noGiLowerIsOn: .constant(false), noGiChokeIsOn: .constant(true), all: .constant(true), filterWins: .constant(false), filterLosses: .constant(false), doesHaveGiOrNoGiField: .constant(false), upperChokeLowerSearchTermPassed: .constant(""), giOrNoGiSearchTermPassed: .constant(""), winOrLossSearchTermPassed: .constant(""))
    }
}
