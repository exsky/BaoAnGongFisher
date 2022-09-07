//
//  BaoAnGongFisherApp.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/9/7.
//

import SwiftUI

@main
struct BaoAnGongFisherApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
