//
//  AuthView.swift
//  BaoAnGongFisher
//
//  Created by nipapa on 2022/10/1.
//

import Amplify
import AWSAPIPlugin
import AWSCognitoAuthPlugin
import AWSDataStorePlugin
import SwiftUI
//import BetterSegmentedControl

struct AuthView: View {
    
    @StateObject var viewModel: AuthView.ViewModel = .init()
    @Binding var showSignPage: Bool
    @State var isRegister: Bool = false
    @State var segmentationSelection : ProfileSection = .signin
    
    enum ProfileSection : String, CaseIterable {
        case signin = "登入"
        case signup = "註冊"
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("保安宮釣客")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 30)
                
                Image("Sea-1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 180, height: 180)
                    .clipped()
                    .cornerRadius(100)
                    .padding(.bottom, 50)
                
                Picker("", selection: $segmentationSelection) {
                    ForEach(ProfileSection.allCases, id: \.self) { option in
                        Text(option.rawValue)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .padding()
                Spacer()
                if segmentationSelection == ProfileSection.signin {
                    VStack(spacing: 20) {
                        TextField("信箱或電話", text: $viewModel.username)
                            .autocapitalization(.none)
                        SecureField("密碼", text: $viewModel.password)
                            .autocapitalization(.none)
                        Button("登入", action: {
                            Task {
                                await self.viewModel.signIn()
                                await self.fetchCurrentAuthSession()
                            }
                        })
                        //Button("檢查狀態", action: self.fetchStatus)
                        Button("以訪客身份登入", action: {
                            self.showSignPage = false
                        })
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 80)
                } else {
                    VStack(spacing: 20) {
                        //TextField("信箱或電話", text: $viewModel.username)
                        TextField("暱稱", text: $viewModel.nickname)
                            .autocapitalization(.none)
                        TextField("信箱", text: $viewModel.email)
                            .autocapitalization(.none)
                        TextField("電話", text: $viewModel.phone,
                                  prompt: Text("電話，請以國碼開頭，如 +886"))
                        SecureField("密碼", text: $viewModel.password,
                                    prompt: Text("密碼，8位以上英文數字組合"))
                            .autocapitalization(.none)
                        Button("取得驗證碼", action:{
                            Task {
                                await self.viewModel.signUp()
                            }
                        })
                        TextField("驗證碼", text: $viewModel.confirmationCode)
                        Button("完成註冊", action:{
                            Task {
                                await self.viewModel.confirm()
                            }
                        })
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 80)
                }
                
            }
        }
    }
    
    func fetchCurrentAuthSession() async {
        do {
            let session = try await Amplify.Auth.fetchAuthSession()
            self.showSignPage = !(session.isSignedIn) // hide sign ui
            print("Is user signed in - \(session.isSignedIn)")
        } catch let error as AuthError {
            print("Fetch session failed with error \(error)")
        } catch {
            print("Unexpected error: \(error)")
        }
    }
}

extension AuthView {
    class ViewModel: ObservableObject {
        @Published var username: String = ""
        @Published var nickname: String = ""
        @Published var password: String = ""
        @Published var email: String = ""
        @Published var phone: String = "+886"
        @Published var confirmationCode: String = ""
        
        func signUp() async {
            let username = email    // let email equal to username
            let userAttributes = [
                AuthUserAttribute(.email, value: email),
                AuthUserAttribute(.phoneNumber, value: phone),
                AuthUserAttribute(.name, value: username)
            ]
            let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
            
//        }
        
//        func signUp(username: String, password: String, email: String) async {
//            let userAttributes = [AuthUserAttribute(.email, value: email)]
//            let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
            do {
                let signUpResult = try await Amplify.Auth.signUp(
                    username: username,
                    password: password,
                    options: options
                )
                if case let .confirmUser(deliveryDetails, _, userId) = signUpResult.nextStep {
                    print("Delivery details \(String(describing: deliveryDetails)) for userId: \(String(describing: userId))")
                } else {
                    print("SignUp Complete")
                }
            } catch let error as AuthError {
                print("An error occurred while registering a user \(error)")
            } catch {
                print("Unexpected error: \(error)")
            }
        }
        
        func confirm() async {
            let username = email    // let email equal to username
            do {
                let confirmSignUpResult = try await Amplify.Auth.confirmSignUp(
                    for: username,
                    confirmationCode: confirmationCode
                )
                print("Confirm sign up result completed: \(confirmSignUpResult.isSignUpComplete)")
            } catch let error as AuthError {
                print("An error occurred while confirming sign up \(error)")
            } catch {
                print("Unexpected error: \(error)")
            }
        }
        
        func signIn() async {
            do {
                let signInResult = try await Amplify.Auth.signIn(
                    username: username,
                    password: password
                    )
                if signInResult.isSignedIn {
                    print("Sign in succeeded")
                }
            } catch let error as AuthError {
                print("Sign in failed \(error)")
            } catch {
                print("Unexpected error: \(error)")
            }
        }
        
        func signOutLocally() async {
            let result = await Amplify.Auth.signOut()
            guard let signOutResult = result as? AWSCognitoSignOutResult
            else {
                print("Signout failed")
                return
            }

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
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(showSignPage: .constant(true))
    }
}
