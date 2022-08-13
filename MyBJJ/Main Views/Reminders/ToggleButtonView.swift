//
//  TestingSomething.swift
//  LocalNotificationBootCamp
//
//  Created by Josh Bourke on 19/6/2022.
//

import SwiftUI

    //MARK: - BRUTE FORCING THE PROBLEM.
struct ToggleButtonView: View {
    //MARK: - PROPERTIES
    
    @Binding var dayOfWeekSun: Bool
    @Binding var dayOfWeekMon: Bool
    @Binding var dayOfWeekTues: Bool
    @Binding var dayOfWeekWeds: Bool
    @Binding var dayOfWeekThurs: Bool
    @Binding var dayOfWeekFri: Bool
    @Binding var dayOfWeekSat: Bool
    //MARK: - BODY
    var body: some View {
        VStack{
            HStack(spacing: 2){
                ToggleButton(isOn: $dayOfWeekSun, title: "Sun")
                    .onChange(of: dayOfWeekSun) { newValue in
                        if dayOfWeekSun {
                            print("Sunday On")
                            dayOfWeekMon = false
                            dayOfWeekTues = false
                            dayOfWeekWeds = false
                            dayOfWeekThurs = false
                            dayOfWeekFri = false
                            dayOfWeekSat = false
                        } else {
                            print("Sunday Off")
                        }
                    }
                ToggleButton(isOn: $dayOfWeekMon, title: "Mon")
                    .onChange(of: dayOfWeekMon) { newValue in
                        if dayOfWeekMon {
                            print("Monday On")
                            dayOfWeekSun = false
                            dayOfWeekTues = false
                            dayOfWeekWeds = false
                            dayOfWeekThurs = false
                            dayOfWeekFri = false
                            dayOfWeekSat = false
                        } else {
                            print("Monday Off")
                        }
                    }
                ToggleButton(isOn: $dayOfWeekTues, title: "Tues")
                    .onChange(of: dayOfWeekTues) { newValue in
                        if dayOfWeekTues {
                            print("Tuesday On")
                            dayOfWeekSun = false
                            dayOfWeekMon = false
                            dayOfWeekWeds = false
                            dayOfWeekThurs = false
                            dayOfWeekFri = false
                            dayOfWeekSat = false
                        } else {
                            print("Tuesday Off")
                        }
                    }
                ToggleButton(isOn: $dayOfWeekWeds, title: "Weds")
                    .onChange(of: dayOfWeekWeds) { newValue in
                        if dayOfWeekWeds {
                            dayOfWeekSun = false
                            dayOfWeekMon = false
                            dayOfWeekTues = false
                            dayOfWeekThurs = false
                            dayOfWeekFri = false
                            dayOfWeekSat = false
                            print("Wednesday On")
                        } else {
                            print("Wednesday Off")
                        }
                    }

            }//: Hstack
            HStack(spacing: 2) {
                ToggleButton(isOn: $dayOfWeekThurs, title: "Thurs")
                    .onChange(of: dayOfWeekThurs) { newValue in
                        if dayOfWeekThurs {
                            print("Thursday On")
                            dayOfWeekSun = false
                            dayOfWeekMon = false
                            dayOfWeekTues = false
                            dayOfWeekWeds = false
                            dayOfWeekFri = false
                            dayOfWeekSat = false
                        } else {
                            print("Thursday Off")
                        }
                    }
                ToggleButton(isOn: $dayOfWeekFri, title: "Fri")
                    .onChange(of: dayOfWeekFri) { newValue in
                        
                        if dayOfWeekFri {
                            print("Friday On")
                            dayOfWeekSun = false
                            dayOfWeekMon = false
                            dayOfWeekTues = false
                            dayOfWeekWeds = false
                            dayOfWeekThurs = false
                            dayOfWeekSat = false
                        } else {
                            print("Friday Off")
                        }
                        
                    }
                ToggleButton(isOn: $dayOfWeekSat, title: "Sat")
                    .onChange(of: dayOfWeekSat) { newValue in
                        if dayOfWeekSat {
                            print("Saturday On")
                            dayOfWeekSun = false
                            dayOfWeekMon = false
                            dayOfWeekTues = false
                            dayOfWeekWeds = false
                            dayOfWeekThurs = false
                            dayOfWeekFri = false
                        } else {
                            print("Saturday Off")
                        }
                    }
                
            }//: HSTACK
        }
    }
}
    //MARK: - PREVIEW
struct TestingSomething_Previews: PreviewProvider {
    static var previews: some View {
        ToggleButtonView(dayOfWeekSun: .constant(false), dayOfWeekMon: .constant(false), dayOfWeekTues: .constant(false), dayOfWeekWeds: .constant(false), dayOfWeekThurs: .constant(false), dayOfWeekFri: .constant(false), dayOfWeekSat: .constant(false))
    }
}
