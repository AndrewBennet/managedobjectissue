//
//  Persistence.swift
//  managedobjectissue
//
//  Created by Andrew Bennet on 17/10/2022.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer

    init() {
        // The model has two version. The second verion has a "text" attribute that is optional, but is validated
        // in the extension at the bottom of this file. Here, however, we explicitly load the first version of
        // the model rather than the second, when initializing the container.
        let model = NSManagedObjectModel(contentsOf: Bundle.main.url(forResource: "managedobjectissue", withExtension: "momd")!)!
        let container = NSPersistentContainer(name: "managedobjectissue", managedObjectModel: model)

        container.loadPersistentStores { (_, error) in
            
            // Once the persistent store is loaded (version 1 of the model, remember), try to create a new managed object
            // which conforms to the requirements of version 1.
            let newItem = NSEntityDescription.insertNewObject(forEntityName: "Item", into: container.viewContext)
            newItem.setValue(Date(), forKey: "timestamp")
            do {
                try container.viewContext.save()
            } catch {
                // A validation error is thrown here indicating that the validation error below - intended to only
                // apply to version 2 - is being applied here too.
                
                // Is there a way to have this object treated as a plain NSManagedObject, not using any of the
                // customisations that may be applied to the corresponding class?
                print("Failed to save new Item: \(error)")
                fatalError()
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        self.container = container
    }
}

enum ValidationError: Error {
    case missingText
}

extension Item {
    public override func validateForInsert() throws {
        let localText = text
        if localText == nil {
            print("Throwing missingText validation error")
            throw ValidationError.missingText
        }
    }
}
