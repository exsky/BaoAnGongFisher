//
//  BaoAnGongFisherApp.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/9/7.
//

import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSDataStorePlugin
import AWSS3StoragePlugin
import SwiftUI

@main
struct BaoAnGongFisherApp: App {
    let persistenceController = PersistenceController.shared
    @State private var showSignPage = true
    // @State private var loggedInUser = Amplify.Auth.getCurrentUser()
    
    var body: some Scene {
        WindowGroup {
            if showSignPage {
                AuthView(showSignPage: $showSignPage)
            } else {
                MainListView(isSignOut: $showSignPage)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
    
    init() {
        configureAmplify()
    }
    
    func configureAmplify() {
        do {
            try Amplify.add(plugin: AWSCognitoAuthPlugin())
            let models = AmplifyModels()
            try Amplify.add(plugin: AWSAPIPlugin(modelRegistration: models))
            try Amplify.add(plugin: AWSDataStorePlugin(modelRegistration: models))
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.configure()
        } catch {
            print(error)
        }
    }
}
