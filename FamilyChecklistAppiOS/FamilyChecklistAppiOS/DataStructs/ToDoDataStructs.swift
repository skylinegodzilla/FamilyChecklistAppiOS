//
//  ToDoDataStructs.swift
//  FamilyChecklistAppiOS
//
//  Created by Benjamin james cawley on 05/08/2025.
//

struct ToDoItem: Identifiable, Codable, Equatable {
    let itemId: Int64
    let title: String
    let description: String
    let completed: Bool
    let dueDate: String // We'll probably want to convert this later
    let position: Int
    
    var id: Int64 { itemId } // added to conform to Identifiable
}

struct ToDoList: Identifiable, Codable, Equatable {
    let listId: Int64
    let title: String
    let description: String
    let items: [ToDoItem]
    
    var id: Int64 { listId } // added to conform to Identifiable
}
