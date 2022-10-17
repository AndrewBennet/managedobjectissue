//
//  managedobjectissueApp.swift
//  managedobjectissue
//
//  Created by Andrew Bennet on 17/10/2022.
//

import SwiftUI

@main
struct managedobjectissueApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
