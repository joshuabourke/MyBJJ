//
//  NotificationSettingsView.swift
//  LocalNotificationBootCamp
//
//  Created by Josh Bourke on 18/6/2022.
//

import SwiftUI


struct NotificationSettingsView: View {
    //MARK: - PROPERTIES
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) var moc
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.dateFormat = "HHmm"
        formatter.locale = Locale(identifier: "en_GB")
        return formatter
    }//: DateFormatter
    
    @State var dayOfWeekSun: Bool = false
    @State var dayOfWeekMon: Bool = false
    @State var dayOfWeekTues: Bool = false
    @State var dayOfWeekWeds: Bool = false
    @State var dayOfWeekThurs: Bool = false
    @State var dayOfWeekFri: Bool = false
    @State var dayOfWeekSat: Bool = false
    
    @State private var currentTime = Date()
    
    @State private var showAlertToggle: Bool = false
    
    @State var dayOfTheWeekInt: Int = 0
    
    @State var userPickedTime: String = ""
    @State var userPickedHours: String = ""
    @State var userPickedMinutes: String = ""
    @State var localNotificationID = UUID()
    
    @Binding var hours: Int
    @Binding var mintues: Int
    @Binding var dayOfTheWeek: Int
    //MARK: - BODY
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    print("Close This View")
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2.bold())
                }.padding()
            }//: Hstack
            Spacer()
            
            //MARK: - PICKER FOR TIME
            DatePicker("Picker your time",selection: $currentTime, displayedComponents: .hourAndMinute)
                .labelsHidden()
                .datePickerStyle(.wheel)
                .padding()
            
            HStack(spacing: 2){
                //MARK: - TOGGLE DAYS
                ToggleButtonView(dayOfWeekSun: $dayOfWeekSun, dayOfWeekMon: $dayOfWeekMon, dayOfWeekTues: $dayOfWeekTues, dayOfWeekWeds: $dayOfWeekWeds, dayOfWeekThurs: $dayOfWeekThurs, dayOfWeekFri: $dayOfWeekFri, dayOfWeekSat: $dayOfWeekSat)
            }//: Hstack
            .padding()
            
            Button {
                print("Add new Notification")
                //This function pretty much just runs an if else loop over all the toggles and returns an Int base on what day of the week has been selected.
                dayOfTheWeekInt = returningNumbersForDays()
                
                //This if function checks to see if the user hasnt picked a day of the week. Then after that it will toggle an alert letting the user know that they need to select something first.
                if dayOfTheWeekInt == 0 {
                    showAlertToggle.toggle()
                }
                //This below converts the time into a string
                //Then i will use the string to then split it in half
                //Half of the string will be the hours from the picker
                //The second half of the string will be the mintues requried for the reminder function.
                userPickedTime = dateFormatter.string(from: currentTime)
                //Next step on the button press is to us the time that has been switched into a string. Then after that split it in half, first 2 numbers and last 2 number or.... Hours and minutes
                //Prefix picks the first 2 characters out of the string
                //While suffix picks the last 2 characters out of the string
                let first2String = userPickedTime.prefix(2)
                let last2String = userPickedTime.suffix(2)
                userPickedHours = String(first2String)
                userPickedMinutes = String(last2String)
                hours = Int(userPickedHours) ?? 0
                mintues = Int(userPickedMinutes) ?? 0
                dayOfTheWeek = dayOfTheWeekInt
                addItem()
                //Once the user presses down the add button it will then add the reminder to their MyBJJ and they will then be reminded.
                NotificationManager.instance.scheduleNotification(hours: hours, mintue: mintues, weekday: dayOfTheWeek, requestId: localNotificationID)
                
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Add")
                    .foregroundColor(.white)
                    .font(.body.bold())
            }
            .buttonStyle(RectangleButton())
            .frame(width: 100, height: 45)

            
            Text("This is your Time \(currentTime, formatter: dateFormatter) Day Number \(dayOfTheWeekInt)\n \(userPickedTime) <-- User picked time\n \(userPickedHours) <--- User picked hours\n \(userPickedMinutes) <-- User picked minutes")
                .padding()
            Spacer()
        }//: Vstack
        .alert(isPresented: $showAlertToggle) { () -> Alert in
            Alert(title: Text("Select a day of the week to be reminded"))
        }
    }
    //MARK: - FUNCTIONS
    func returningNumbersForDays() -> Int {
        var dayNumber: Int = 0
        
        if dayOfWeekSun {
            dayNumber = 1
        }
        else if dayOfWeekMon {
            dayNumber = 2
        }
        else if dayOfWeekTues {
            dayNumber = 3
        }
        else if dayOfWeekWeds {
            dayNumber = 4
        }
        else if dayOfWeekThurs {
            dayNumber = 5
        }
        else if dayOfWeekFri {
            dayNumber = 6
        }
        else if dayOfWeekSat {
            dayNumber = 7
        }
        return dayNumber
    }
    
    //MARK: - CORE DATA FUNCTION
    func addItem () {
        
        let newItem = UserReminders(context: moc)
        newItem.reminderDay = dayOfTheWeekInt
        newItem.reminderHours = Int(userPickedHours) ?? 0
        newItem.reminderMinutes = Int(userPickedMinutes) ?? 0
        newItem.reminderID = localNotificationID
        do{
            try moc.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }//: addItem
}
    //MARK: - PREVIEW
struct NotificationSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationSettingsView(hours: .constant(0), mintues: .constant(0), dayOfTheWeek: .constant(0))
    }
}
