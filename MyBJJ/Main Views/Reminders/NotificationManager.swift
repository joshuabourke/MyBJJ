//
//  NotificationManager.swift
//  LocalNotificationBootCamp
//
//  Created by Josh Bourke on 26/6/2022.
//

import SwiftUI
import CoreLocation
import UserNotifications
//Have to import this to get access to auth and many other thing

class NotificationManager {

    
    static let instance = NotificationManager() // Singleton
    //Eg a single instance of the NotificationManage to use the same one through out the application
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        //Above are the types of notifcations the app will be asking the user permission for. They are all the usual notifications
        
        //.alert is the notification that drops down from the top of the screen
        //.sound is pretty self explainitory
        //.badge is the little number that sticks it self to the top right corner of the application app icon
            
        
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (succes, error) in
            if let error = error {
                print("Error:\(error)")
            } else {
                print("SUCCESS")
            }
        }
    }
    //MARK: - NOTES FOR NOTIFICATIONS
    //Calling the same notification function 2 times at least with different parameters seems to call 2 separate notifications. next step is to find a way the user can then input different notifications. But also so they can remove specific reminders from theirlist of reminders.
    func scheduleNotification(hours: Int, mintue: Int, weekday: Int, requestId: UUID) {
        let content =   UNMutableNotificationContent()
        content.title = "MyBJJ"
        content.subtitle = "Remember to track your progress!"
        content.sound = .default
        content.badge = 1
        
        
        
        //Time
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        //Calendar
        var dateComponents = DateComponents()
        dateComponents.hour = hours
        dateComponents.minute = mintue
        dateComponents.weekday = weekday

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        //Location
//        let coordinates = CLLocationCoordinate2D(latitude: 40.00,
//                                                 longitude: 50.00)
//
//        let region = CLCircularRegion(center: coordinates,
//                                      radius: 100,
//                                      identifier: UUID().uuidString)
//        let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
//
//        region.notifyOnExit = false
//        region.notifyOnEntry = true
        
        //I am trying to be able to fetch the id of the request so when the users wants to remove a notification i can remove a specific one instead of having to just remove them all.
        
        let request = UNNotificationRequest(identifier: requestId.uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func cancelSpecificNotification(notificationID: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [notificationID])
    }
}
