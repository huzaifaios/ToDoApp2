//
//  ContentView.swift
//  ToDoApp
//
//  Created by M.Huzaifa on 28/04/2023.
//

import SwiftUI


enum Priority: String, Identifiable, CaseIterable {
    var id: UUID {
        return UUID()
    }
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

extension Priority {
    
    var title: String {
        switch self {
        case.low:
            return "Low"
        case.medium:
            return "Medium"
        case.high:
            return "High"
        }
    }
}

struct ContentView: View {
    
    @State var textFieldText: String = ""
    @State var selectedPriority: Priority = .medium
    @Environment(\.managedObjectContext) private var ViewContext
    
    @FetchRequest(entity: TaskEntity.entity(), sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)])
    private var AllTasks: FetchedResults<TaskEntity>
    @State var isFavourite: Bool = false
    
    private func saveTask() {
        let task = TaskEntity(context: ViewContext)
        task.title = textFieldText
        task.priority = selectedPriority.rawValue
        task.dateCreated = Date()
        do {
            try ViewContext.save()
        } catch let error {
            print("Error\(error.localizedDescription)")
        }
    }
    
    func styleForPriority(value: String) -> Color{
        let priority = Priority(rawValue: value)
        
        switch priority {
        case.low:
            return Color.green
        case.medium:
            return Color.orange
        case.high:
            return Color.red
        default:
            return Color.black
        }
    }
    
    func updateTask(task: TaskEntity) {
        task.isFavourite.toggle()
        
        do {
            try ViewContext.save()
        } catch let error {
            print("\(error.localizedDescription)")
        }
    }
    
    func deleteTask(indexSet: IndexSet) {
        indexSet.forEach { index in
            let task = AllTasks[index]
            ViewContext.delete(task)
            
            do {
                try ViewContext.save()
            } catch let error {
                print("\(error.localizedDescription)")
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                
                TextField("Enter title", text: $textFieldText)
                    .textFieldStyle(.roundedBorder)
                
                Picker("Priority", selection: $selectedPriority) {
                    ForEach(Priority.allCases) { priority  in
                        Text(priority.title).tag(priority)
                    }
                }
                .pickerStyle(.segmented)
                
                Button {
                    saveTask()
                } label: {
                    Text("Save")
                        .foregroundColor(Color.white)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                
                List {
                    ForEach(AllTasks) { task in
                        HStack {
                            Circle()
                                .fill(styleForPriority(value: task.priority!))
                                .frame(width: 15, height: 15)
                            Spacer().frame(width: 20)
                            Text(task.title ?? "")
                            Spacer()
                            Image(systemName: task.isFavourite ? "heart.fill" : "heart")
                                .foregroundColor(Color.red)
                                .onTapGesture {
                                    updateTask(task: task)
                                }
                        }
                    }
                    .onDelete { IndexSet in
                        deleteTask(indexSet: IndexSet)
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Tasks")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let container = CoreDataManager.shared.container
        ContentView().environment(\.managedObjectContext, container.viewContext)
    }
}


