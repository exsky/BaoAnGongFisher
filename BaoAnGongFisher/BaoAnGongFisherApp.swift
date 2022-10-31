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
import SwiftUI

@main
struct BaoAnGongFisherApp: App {
    let persistenceController = PersistenceController.shared
    @State private var showSignPage = true
    // @State private var loggedInUser = Amplify.Auth.getCurrentUser()
    
    var body: some Scene {
        WindowGroup {
            if showSignPage {
                //AuthView(showSignPage: $showSignPage)
                MainListView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                MainListView()
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
            try Amplify.configure()
            print("The Amplify is configured!")
        } catch {
            print(error)
        }
    }
    
    func checkSignIn() {
        Amplify.Auth.fetchAuthSession() { result in
            switch result {
            case .success(let signInResult):
                if signInResult.isSignedIn {
                    print("Confirm sign in succeeded. The user is signed in.")
                    self.showSignPage = false
                }
            case .failure(let error):
                print("Confirm sign in failed \(error)")
            }
        }
    }
}
