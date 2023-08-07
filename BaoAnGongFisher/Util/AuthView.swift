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
                            viewModel.signIn()
                            self.fetchStatus()
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
                        TextField("電話", text: $viewModel.phone)
                        SecureField("密碼", text: $viewModel.password)
                            .autocapitalization(.none)
                        Button("取得驗證碼", action: viewModel.signUp)
                        TextField("驗證碼", text: $viewModel.confirmationCode)
                        Button("完成註冊", action: viewModel.confirm)
                    }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 80)
                }
                
            }
        }
    }
    
    func fetchStatus() {
        _ = Amplify.Auth.fetchAuthSession { result in
            do {
                let session = try result.get()
                self.showSignPage = !(session.isSignedIn) // hide sign ui
                print("Session Is Login ? \(session.isSignedIn)")
                // print(session)
            } catch {
                print("Fetch auth session failed with error - \(error)")
            }
        }
    }
}

extension AuthView {
    class ViewModel: ObservableObject {
        @Published var username: String = ""
        @Published var nickname: String = ""
        @Published var password: String = ""
        @Published var email: String = ""
        @Published var phone: String = ""
        @Published var confirmationCode: String = ""
        
        func signUp() {
            var username = email    // let email equal to username
            let userAttributes = [
                AuthUserAttribute(.email, value: email),
                AuthUserAttribute(.phoneNumber, value: phone),
                AuthUserAttribute(.name, value: username)
            ]
            let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
            
            Amplify.Auth.signUp(
                username: username,
                password: password,
                options: options
            ) { result in
                switch result {
                case .success(let signUpResult):
                    if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                        print("Delivery details \(String(describing: deliveryDetails))")
                    } else {
                        print("SignUp Complete")
                    }
                case .failure(let error):
                    print("An error occurred while registering a user \(error)")
                }
            }
        }
        
        func confirm() {
            var username = email    // let email equal to username
            Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
                switch result {
                case .success(let confirmResult):
                    print(confirmResult)
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        func signIn() {
            self.signOutLocally()
            Amplify.Auth.signIn(username: username, password: password) { result in
                switch result {
                case .success:
                    print("Sign in succeeded")
                case .failure(let error):
                    print("Sign in failed \(error)")
                }
            }
        }
        
        func signOutLocally() {
            Amplify.Auth.signOut() { result in
                switch result {
                case .success:
                    print("Successfully signed out")
                case .failure(let error):
                    print("Sign out failed with error \(error)")
                }
            }
        }
    }
}

struct AuthView_Previews: PreviewProvider {
    static var previews: some View {
        AuthView(showSignPage: .constant(true))
    }
}
