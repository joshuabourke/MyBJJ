//
//  ReminderListViewItem.swift
//  LocalNotificationBootCamp
//
//  Created by Josh Bourke on 23/6/2022.
//

import SwiftUI

struct ReminderListViewItem: View {
    //MARK: - PROPERTIES
    
    //I'll need to give the list item the same identifier as the notification.
    
    @State var hours: Int
    @State var minutes: Int
    @State var dayOfTheWeek: Int
    //Could change this from string to bool. Just switch from true to false depeneding on am or pm.
    @State var amOrPm: String = ""

    //MARK: - BODY
    var body: some View {
        HStack {
            Image(systemName: "bell")
                .font(.system(size: 20).bold())
                .foregroundColor(.accentColor)
            Spacer()
            Text(intIntoDayOfTheWeek(dayNumber:dayOfTheWeek))
                .font(.system(size: 20))
                .bold()
            //This string here takes in hours and mintues are Int's
            let result24HourAmOrPm = changingAMAndPMTime(hoursToChange: self.hours, minutesToChange: self.minutes)
            Text("\(result24HourAmOrPm.0):\(result24HourAmOrPm.1)\(result24HourAmOrPm.2)")
                .font(.system(size: 20))
                .bold()
        }//: Hstack
        .padding()
    }

    //I need to make a function that will take 24 hour time and convert it into normal hours and switch am or pm accordinly.
    //The goal with this function is to check to see if the time is greater than 12 and if so then subtract 12. e.g if the time is 13:15 (1:15pm) to convert it from 24 hour time back to normal time just need to subtract 12.
    //Originally i was going to make some long switch or if else to cover this....
    func changingAMAndPMTime(hoursToChange: Int, minutesToChange: Int) -> (String, String, String) {
        //This function takes in the hours as int or 24 hour time then converts that into a readable time for the user.
        var hoursToChangeOver: String = ""
        var settingAmOrPm: String = ""
        var mintuesToChangeOver: String = ""
        var hours = hoursToChange
        
        //Also found out. To return minutes as 00 i will need to make something in here to cover that. e.g 00 prints "0" and 01 prints "1" and so on until 10. So I will also need to return another string checking to see if the value is less than 10 e.g 00,01,02,03..... until 10.
        if minutesToChange < 10 {
            mintuesToChangeOver = "0\(minutesToChange)"
        } else {
            mintuesToChangeOver = String(minutesToChange)
        }
        
        if hoursToChange >= 12 {
            if hoursToChange == 12{
                hoursToChangeOver = String(hours)
                settingAmOrPm = "pm"
                return (hoursToChangeOver, mintuesToChangeOver, settingAmOrPm)
            } else if hoursToChange == 24{
                hours -= 12
                hoursToChangeOver = String(hours)
                settingAmOrPm = "am"
                return(hoursToChangeOver, mintuesToChangeOver, settingAmOrPm)
            }
            hours -= 12
            hoursToChangeOver = String(hours)
            settingAmOrPm = "pm"
        } else if hoursToChange <= 12 {
            hoursToChangeOver = String(hours)
            settingAmOrPm = "am"
        }
        

        
        return (hoursToChangeOver,mintuesToChangeOver, settingAmOrPm)
    }
}

//MARK: - FUNCTIONS
//This function pretty much goes through all the different number of days it could be. Then uses the number to then return the day of the week it is.
func intIntoDayOfTheWeek(dayNumber: Int) -> String {
    var returnString: String = ""
    
    if dayNumber == 1 {
        returnString = "Sun"
    }
    else if dayNumber == 2 {
        returnString = "Mon"
    }
    else if dayNumber == 3{
        returnString = "Tues"
    }
    else if dayNumber == 4{
        returnString = "Weds"
    }
    else if dayNumber == 5{
        returnString = "Thurs"
    }
    else if dayNumber == 6 {
        returnString = "Fri"
    }
    else if dayNumber == 7 {
        returnString = "Sat"
    }
    return returnString
    
}

//MARK: - PREVIEW
struct ReminderListViewItem_Previews: PreviewProvider {
    static var previews: some View {
        ReminderListViewItem(hours: 24, minutes: 9, dayOfTheWeek: 1)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
