//
//  PersistenceController.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/25/23.
//

import CoreData

struct PersistenceController {
    static let instance = PersistenceController()
    let container: NSPersistentContainer
    
    private init() {
        self.container = NSPersistentContainer(name: "RecordsModel")
        self.container.loadPersistentStores { (description, error) in
            if let error = error as? NSError {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    func saveContext() {
        if self.container.viewContext.hasChanges {
            do {
                try self.container.viewContext.save()
            } catch let error as NSError {
                NSLog("Unresolved error saving context: \(error), \(error.userInfo)")
            }
        }
    }
}
