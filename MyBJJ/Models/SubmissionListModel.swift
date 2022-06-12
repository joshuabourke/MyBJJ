//
//  SubmissionListModel.swift
//  MyBJJ
//
//  Created by Josh Bourke on 14/4/22.
//

import Foundation

//MARK: - FUNCTIONS

//Getting the current Date and time
func getCurrentTime() -> String {
    let date = Date()
    let calendar = Calendar.current
    let day = calendar.component(.day, from: date)
    let month = calendar.component(.month, from: date)
    let year = calendar.component(.year, from: date)
    let hour = calendar.component(.hour, from: date)
    let minutes = calendar.component(.minute, from: date)
    
    var minutesTwo = "\(minutes)"
    if (minutesTwo.count == 1) {
        minutesTwo = "0\(minutes)"
    }
    
    var hoursTwo = "\(hour)"
    if (hoursTwo.count == 1) {
        hoursTwo = "0\(hoursTwo)"
    }
    let theDate =   "\(day)/\(month)/\(year) \(hoursTwo):\(minutesTwo)"
    return theDate
}

struct SubmissionListModel: Identifiable {
    let id = UUID()
    let upperLowerChoke: String
    let sub: String
    let date: String
    let winOrLoss: Bool
}
