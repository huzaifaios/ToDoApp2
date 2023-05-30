//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by M.Huzaifa on 28/04/2023.
//

import SwiftUI

@main
struct ToDoAppApp: App {
    
    let container = CoreDataManager.shared.container
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, container.viewContext)
        }
    }
}
