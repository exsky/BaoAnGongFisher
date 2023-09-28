//
//  MainListView.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/10/9.
//

import Amplify
import AWSCognitoAuthPlugin
import SwiftUI

struct MainListView: View {
    @Binding var isSignOut: Bool
    
    var body: some View {
        TabView {
            StampAlbumView()
                .tabItem {
                    Image(systemName: "book.closed.fill")
                    Text("集郵冊")
                }
            ToxicFishListView()
                .tabItem {
                    Image(systemName: "xmark.shield.fill")
                    Text("危險魚類")
                }
            FishingLocationView()
                .tabItem {
                    Image(systemName: "map.fill")
                    Text("私藏釣點")
                }
            NavigationView {
                    List {
                        Section {
                            HStack {
                                //Button(action: logout) {
                                Button(action: {
                                    Task {
                                        await self.signOutLocally()
                                    }
                                }) {
                                    Label("登出", systemImage: "plus.rectangle.on.folder.fill")
                                    //.onTapGesture {
                                    //    self.isSignOut.toggle()
                                    //}
                                }
                                Text("登出")
                            }
                        }
                    }
                }
            .tabItem {
                    Image(systemName: "doc.badge.gearshape.fill")
                    Text("管理")
            }
        }
        //.tabViewStyle(PageTabViewStyle())
        //.tabViewStyle(.page)
        //.edgesIgnoringSafeArea(.all)
        .accentColor(.pink)
    }

    func signOutLocally() async {
        let result = await Amplify.Auth.signOut()
        guard let signOutResult = result as? AWSCognitoSignOutResult
        else {
            print("Signout failed")
            return
        }

        // Return Login View
        print("Log out ~~")
        self.isSignOut = true

        print("Local signout successful: \(signOutResult.signedOutLocally)")
        switch signOutResult {
        case .complete:
            // Sign Out completed fully and without errors.
            print("Signed out successfully")

        case let .partial(revokeTokenError, globalSignOutError, hostedUIError):
            // Sign Out completed with some errors. User is signed out of the device.

            if let hostedUIError = hostedUIError {
                print("HostedUI error  \(String(describing: hostedUIError))")
            }

            if let globalSignOutError = globalSignOutError {
                // Optional: Use escape hatch to retry revocation of globalSignOutError.accessToken.
                print("GlobalSignOut error  \(String(describing: globalSignOutError))")
            }

            if let revokeTokenError = revokeTokenError {
                // Optional: Use escape hatch to retry revocation of revokeTokenError.accessToken.
                print("Revoke token error  \(String(describing: revokeTokenError))")
            }

        case .failed(let error):
            // Sign Out failed with an exception, leaving the user signed in.
            print("SignOut failed with \(error)")
        }
    }
}

struct MainListView_Previews: PreviewProvider {
    static var previews: some View {
        MainListView(isSignOut: .constant(false))
    }
}
