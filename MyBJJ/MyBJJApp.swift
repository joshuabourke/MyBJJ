//
//  MyBJJApp.swift
//  MyBJJ
//
//  Created by Josh Bourke on 12/4/22.
//

import SwiftUI
import CoreData

@main
struct MyBJJApp: App {
    let persistentContainer = MyPersistentController.shared

    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistentContainer.container.viewContext)
               
        }
    }
}
