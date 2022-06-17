//
//  ToDoReposiotory.swift
//  TodoLIst
//
//  Created by Monika Piątkowska on 12/06/2022.
//

import Foundation
import CoreData

class ToDoRepository {
    
    static let shared = ToDoRepository()
    
    private init() {
        
    }
    
    func add(text: String, context: NSManagedObjectContext) {
        let toDoItem = ToDoEntity(context: context)
        toDoItem.id = Int64(nextId(context: context))
        toDoItem.text = text
        do {
          try context.save()
        } catch let error as NSError {
          print("Could not save. \(error), \(error.userInfo)")
        }
    }
    func edit(todoItem: ToDoItem, context: NSManagedObjectContext) {
        do {
            let fetchRequest = ToDoEntity.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(
                format: "id = %d", todoItem.id
            )
            if let item = try context.fetch( fetchRequest).first {
                item.text = todoItem.text
                try context.save()
            }
        } catch let error as NSError {
            print("Could not edit. \(error), \(error.userInfo)")
        }
    }
    
    func toogleStatus(item: ToDoItem, context: NSManagedObjectContext) {
        do {
            let fetchRequest = ToDoEntity.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(
                format: "id = %d", item.id
            )
            if let item = try context.fetch( fetchRequest).first {
                item.done = !item.done
                try context.save()
            }
        } catch let error as NSError {
            print("Could not remove. \(error), \(error.userInfo)")
        }
    }
    
    func delete(item: ToDoItem, context: NSManagedObjectContext) {
        do {
            let fetchRequest = ToDoEntity.fetchRequest()
            fetchRequest.fetchLimit = 1
            fetchRequest.predicate = NSPredicate(
                format: "id = %d", item.id
            )
            if let item = try context.fetch( fetchRequest).first {
                context.delete(item)
            }
        } catch let error as NSError {
            print("Could not remove. \(error), \(error.userInfo)")
        }
    }
    
    func getAll(context: NSManagedObjectContext) -> Array<ToDoItem> {
        do {
            return try context.fetch( ToDoEntity.fetchRequest()).map { ToDoItem(id: Int($0.id), text: $0.text ?? "", status: $0.done) }
        } catch let error as NSError {
            print("Could not get all objects. \(error), \(error.userInfo)")
            return []
        }
    }
    
    private func nextId(context: NSManagedObjectContext) -> Int {
        (getAll(context: context).map {$0.id}.max() ?? 0) + 1
    }
}
