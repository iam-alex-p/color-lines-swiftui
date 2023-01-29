//
//  ColorLinesApp.swift
//  ColorLines
//
//  Created by Aleksei Pokolev on 1/9/23.
//

import SwiftUI

@main
struct ColorLinesApp: App {
    private let persistenceController = PersistenceController.instance
    
    var body: some Scene {
        WindowGroup {
            GameMainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
