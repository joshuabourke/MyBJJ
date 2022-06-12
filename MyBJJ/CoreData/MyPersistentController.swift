//
//  Persistence.swift
//  MyBJJ
//
//  Created by Josh Bourke on 16/4/22.
//

import CoreData

struct MyPersistentController {
    
    //MARK: - PERSISTENT CONTROLLER
    static let shared = MyPersistentController()
    
    
    //MARK: - PERSISTENT CONTAINER
    let container: NSPersistentContainer
    
    
    //MARK: - INIT (Load persistent storage)
    init(){
        container = NSPersistentContainer(name: "CoreDataModel")
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolve Error: \(error)")
            }
        }
    }
}
