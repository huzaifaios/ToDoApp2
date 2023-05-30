//
//  CoreDataManager.swift
//  ToDoApp
//
//  Created by M.Huzaifa on 28/04/2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared: CoreDataManager = CoreDataManager()
    
    let container: NSPersistentContainer
    
    private init() {
        container = NSPersistentContainer(name: "CoreDataContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Unable to initialize Core Data.\(error)")
            } else {
                print("Successfully Loaded Core Data.")
            }
        }
    }
    
}
