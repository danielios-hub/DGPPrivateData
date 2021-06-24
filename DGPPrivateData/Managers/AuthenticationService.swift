//
//  AuthenticationService.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 23/6/21.
//

import Foundation

public enum StoreError: Error {
    case emptyKey
    case emptyValue
    
}
public enum StoreResult: Equatable {
    case success
    case failure(Error)
    
    public static func ==(lhs: StoreResult, rhs: StoreResult) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return true
        case let (.failure(errorLhs as StoreError?), .failure(errorRhs as StoreError?)):
            return errorLhs == errorRhs
        case let (.failure(errorLhs as NSError?), .failure(errorRhs as NSError?)):
            return errorLhs?.code == errorRhs?.code
        default:
            return false
        }
    }
}

public class AuthenticationStore {
    var savedPassword: String?
    
    var store: [String: String] = [:]
    
    public init() {}
    
    public func contains(key: String, with value: String) -> Bool {
        return store[key] == value
    }
    
    public func get(_ key: String) -> String? {
        return store[key] as? String
    }
    
    public func save(key: String, value: String, password: String? = nil) -> StoreResult {
        if key.isEmpty {
            return .failure(StoreError.emptyKey)
        } else if value.isEmpty {
            return .failure(StoreError.emptyValue)
        } else {
            store[key] = value
            savedPassword = password
            return .success
        }
    }
    
}

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
    private let store: AuthenticationStore
    private let passwordService: PasswordGenerator
    private let modeKey = "mode"
    
    public enum Result: Equatable {
        case success
        case failure(AuthenticationError)
    }
    
    public enum AuthenticationMode: String, CaseIterable {
        case faceID = "faceID"
        case password = "password"
        case none = "none"
    }
    
    struct AuthenticationSession {
        let mode: AuthenticationMode
        let password: String?
        
        init(mode: AuthenticationMode, password: String? = nil) {
            self.mode = mode
            self.password = password
        }
    }
    
    public init(store: AuthenticationStore,
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
            if store.savedPassword == password {
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
            store.save(key: modeKey,
                       value: AuthenticationMode.password.rawValue,
                       password: password)
            return .success
        } else {
            return .failure(.minimumPasswordNotValid)
        }
    }
    
    private func storeFaceIDSession() {
        store.save(key: modeKey, value: AuthenticationMode.faceID.rawValue)
    }
    
    //MARK: - Helpers
    
    private func isSignIn(with mode: AuthenticationMode) -> Bool {
        store.contains(key: modeKey, with: mode.rawValue)
    }
    
}
