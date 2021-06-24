//
//  AuthenticationService.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 23/6/21.
//

import Foundation

public protocol AuthenticationService {
    func containsPreviousSession() -> AuthenticationManager.AuthenticationMode
    func storePasswordSession(password: String) -> AuthenticationManager.Result
    func login(with password: String) -> AuthenticationManager.Result
    func loginWithFaceID() -> AuthenticationManager.Result
}

public enum AuthenticationError: Error {
    case invalidCredentials
    case onlyFaceIDAllowed
    case onlyPasswordAllowed
    case noPasswordSet
    case minimumPasswordNotValid
}

public class AuthenticationManager: AuthenticationService {
    private let store: SecureStore
    private let passwordService: PasswordGenerator
    private let modeKey = "mode"
    
    public enum Result: Equatable {
        case success
        case failure(AuthenticationError)
    }
    
    public enum AuthenticationMode: String, CaseIterable, Codable {
        case faceID = "faceID"
        case password = "password"
        case none = "none"
    }
    
    struct AuthenticationSession: Codable {
        let mode: AuthenticationMode
        let password: String?
        
        init(mode: AuthenticationMode, password: String? = nil) {
            self.mode = mode
            self.password = password
        }
    }
    
    public init(store: SecureStore,
         passwordService: PasswordGenerator) {
        self.store = store
        self.passwordService = passwordService
    }
    
    public func containsPreviousSession() -> AuthenticationMode {
        var previousSession: AuthenticationMode = .none
        AuthenticationMode.allCases.forEach {
            if isSignIn(with: $0) {
                previousSession = $0
            }
        }
        return previousSession
    }
    
    //MARK: - Login
    
    public func loginWithFaceID() -> Result {
        if isSignIn(with: .password) {
            return .failure(.onlyPasswordAllowed)
        } else {
            self.storeFaceIDSession()
            return .success
        }
    }
    
    public func login(with password: String) -> Result {
        if isSignIn(with: .faceID) {
            return .failure(.onlyFaceIDAllowed)
        } else if isSignIn(with: .password) {
            let object = store.get(key: modeKey, withType: AuthenticationSession.self)
            if object?.password == password {
                return .success
            } else {
                return .failure(AuthenticationError.invalidCredentials)
            }
        } else {
            return .failure(.noPasswordSet)
        }
    }
    
    //MARK: - Store
    
    public func storePasswordSession(password: String) -> Result {
        if passwordService.isValidPassword(password: password) {
            let session = AuthenticationSession(mode: .password, password: password)
            _ = store.set(session, forKey: modeKey)
            return .success
        } else {
            return .failure(.minimumPasswordNotValid)
        }
    }
    
    private func storeFaceIDSession() {
        let session = AuthenticationSession(mode: .faceID)
        _ = store.set(session, forKey: modeKey)
    }
    
    //MARK: - Helpers
    
    private func isSignIn(with mode: AuthenticationMode) -> Bool {
        let object = store.get(key: modeKey, withType: AuthenticationSession.self)
        
        guard let object = object,
              object.mode == mode else {
            return false
        }
        
        return true
    }
    
}
