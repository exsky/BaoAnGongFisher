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
import Combine

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
            try Amplify.add(plugin: AWSS3StoragePlugin())
            try Amplify.configure()
            print("The Amplify configured with Auth and Storage plugins!")
            Task {
                await fetchCurrentAuthSession()
            }
        } catch {
            print(error)
        }
    }
    
    func fetchCurrentAuthSession() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            print("Is user signed in - \(session.isSignedIn)")
        } catch let error as AuthError {
            print("Fetch session failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
//    func checkSignIn() {
//        _ = Amplify.Auth.fetchAuthSession { result in
//            switch result {
//            case .success(let signInResult):
//                if signInResult.isSignedIn {
//                    print("Confirm sign in succeeded. The user is signed in.")
//                    self.showSignPage = false
//                }
//            case .failure(let error):
//                print("Confirm sign in failed \(error)")
//            }
//        }
//    }
//    
//    func signIn2() async throws {
//        let subscription = Amplify.API.subscribe(
//            request: .subscription(of: Todo.self, type: .onCreate)
//        )
//
//        let sink = Amplify.Publisher.create(subscription)
//            .sink { completion in
//                // handle completion
//            } receiveValue: { value in
//                // handle value
//            }
//    }
}
