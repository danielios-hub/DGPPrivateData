//
//  LoginView.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 27/6/21.
//

import SwiftUI

struct LoginView: View {
    
    var authenticationService: AuthenticationService
    var successNavigateClosure: () -> Void
    
    class StateView {
        var isFaceIDVisible: Bool = true
        var isPasswordVisible: Bool = true
        
        init(isFaceIDVisible: Bool = true, isPasswordVisible: Bool = true) {
            self.isFaceIDVisible = isFaceIDVisible
            self.isPasswordVisible = isPasswordVisible
        }
    }
    
    @State var stateView = StateView()
    @State var isErrorVisible = false
    @State var errorDescription: String = ""
    @State var password: String = ""
    
    var loginUseCase = LoginViewUseCase()
    
    var body: some View {
        NavigationView {
            VStack {
                if stateView.isFaceIDVisible {
                    Button(action: {
                        performLoginFaceID()
                    }, label: {
                        let textBiometrics = NSLocalizedString("Sign In with biometric identification", comment: "Button for login with FaceId or Touch ID")
                        Text(textBiometrics)
                        Image(systemName: "faceid")
                    })
                    .dgpButton()
                }
                
                Spacer()
                if stateView.isPasswordVisible {
                    let signInText = NSLocalizedString("Sign In", comment: "Sign In Button")
                    let signUpText = NSLocalizedString("Sign Un", comment: "Sign Up Button")
                    let textButton = authenticationService.containsPreviousSession() == .password ? signInText  : signUpText
                    let placeholder = NSLocalizedString("password...", comment: "Placeholder for password textField")
                    
                    VStack {
                        TextField(placeholder, text: $password)
                            .textFieldStyle(DGPTextField())
                        Spacer()
                        Button(action: {
                            performLoginWithPassword(password)
                        }, label: {
                            Text(textButton)
                            Image(systemName: "textbox")
                        })
                        .dgpButton()
                    }
                    .frame(height: 100)
                }
                
            }
            .padding()
            .frame(height: 250)
            .navigationBarTitle(Text(NSLocalizedString("Authentication",
                                                  comment: "title for authentication screen")))
            .toolbar(content: {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "info.circle.fill")
                })
            })
            .alert(isPresented: $isErrorVisible, content: {
                let title = NSLocalizedString("Something went wrong", comment: "something went wrong title alert")
                return Alert(title: Text(title),
                      message: Text(errorDescription))
            })
            
        }
        .navigationBarColor(backgroundColor: UIColor.forgottenPurple!,
                            tintColor: .white)
        .onAppear {
            updateState()
        }
    }
    
    //MARK: - Helpers
    
    func updateState() {
        let (faceID, password) = loginUseCase.visibleActions(session: authenticationService)
        stateView = StateView(isFaceIDVisible: faceID, isPasswordVisible: password)
    }
    
    func performLoginFaceID() {
        loginUseCase.performFaceIDAuthentification { result in
            switch result {
            case .success:
                switch self.authenticationService.loginWithFaceID() {
                case .success:
                    self.successNavigateClosure()
                case .failure(_):
                    break
                }
            case .failure(_):
                break
            }
        }
    }
    
    func performLoginWithPassword(_ password: String) {
        var result: AuthenticationManager.Result
        if authenticationService.containsPreviousSession() == .password {
            result = authenticationService.login(with: password)
        } else {
            result = authenticationService.storePasswordSession(password: password)
        }
        
        switch result {
        case .success:
            self.successNavigateClosure()
        case .failure(let error):
            switch error {
            case .invalidCredentials:
                errorDescription = NSLocalizedString("Wrong credentials", comment: "Bad credentials error message")
            case .minimumPasswordNotValid:
                errorDescription = NSLocalizedString("Minimum requirements for password not valid", comment: "error moessage for password not strong enough")
            default:
                errorDescription = NSLocalizedString("Something went wrong, please try again", comment: "error message default")
            }
            self.isErrorVisible = true
        }
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(
            authenticationService: AuthenticationManager(
                store: KeyChainStore(),
                passwordService: PasswordManager())) {}
    }
}
