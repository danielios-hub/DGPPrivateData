//
//  AuthenticationUseCaseTests.swift
//  DGPPrivateDataTests
//
//  Created by Daniel Gallego Peralta on 21/6/21.
//

import XCTest
import DGPPrivateData

class AuthenticationUseCaseTests: XCTestCase {
    
    func test_init_doesNotSetData() {
        let (sut, _) = makeSUT()
        XCTAssertEqual(sut.containsPreviousSession(), .none)
    }
    
    //MARK: - Face ID
    
    func test_loginSession_withFaceIDSession_andPreviousPasswordSession_returnErrorNoAllowed() {
        let (sut, _) = makeSUT()
        var result = sut.storePasswordSession(password: anyValidPassword())
        XCTAssertEqual(result, .success)
        
        result = sut.loginWithFaceID()
        XCTAssertEqual(result, .failure(.onlyPasswordAllowed))
    }
    
    func test_loginSession_withFaceIDSession_doesSaveFaceIDSession() {
        let (sut, _) = makeSUT()
        XCTAssertEqual(sut.containsPreviousSession(), .none)
        var result = sut.loginWithFaceID()
        XCTAssertEqual(result, .success)
        XCTAssertEqual(sut.containsPreviousSession(), .faceID)
        
        result = sut.loginWithFaceID()
        XCTAssertEqual(result, .success)
        XCTAssertEqual(sut.containsPreviousSession(), .faceID)
    }
    
    //MARK: - Password Store
    
    func test_storeSession_withPasswordNotValid_returnNotValidPassword() {
        let (sut, _) = makeSUT()
        XCTAssertEqual(sut.containsPreviousSession(), .none)
        let result = sut.storePasswordSession(password: "short")
        XCTAssertEqual(result, .failure(.minimumPasswordNotValid))
    }
    
    func test_storeSession_withPasswordValid_doesSavePasswordSession() {
        let (sut, _) = makeSUT()
        XCTAssertEqual(sut.containsPreviousSession(), .none)
        let result = sut.storePasswordSession(password: anyValidPassword())
        XCTAssertEqual(sut.containsPreviousSession(), .password)
        XCTAssertEqual(result, .success)
    }
    
    //MARK: - Password login
    
    func test_loginWithPassword_withPreviousFaceIDSession_returnErrorNotAllowAuthentification() {
        let (sut, _) = makeSUT()
        let result = sut.loginWithFaceID()
        XCTAssertEqual(result, .success)
        XCTAssertEqual(sut.login(with: anyValidPassword()), .failure(.onlyFaceIDAllowed))
    }
    
    func test_loginWithPassword_withWrongPassword_returnErrorCredentials() {
        let (sut, _) = makeSUT()
        let password = anyValidPassword()
        let result = sut.storePasswordSession(password: password)
        XCTAssertEqual(result, .success)
        XCTAssertEqual(sut.login(with: "invalidpassword"), .failure(.invalidCredentials))
    }
    
    func test_loginWithPassword_withNoPasswordStore_returnErrorNotPasswordSet() {
        let (sut, _) = makeSUT()
        XCTAssertEqual(sut.login(with: anyValidPassword()), .failure(.noPasswordSet))
    }
    
    func test_loginWithPassword_withRightPassword_returnSuccess() {
        let (sut, _) = makeSUT()
        let password = anyValidPassword()
        let result = sut.storePasswordSession(password: password)
        XCTAssertEqual(result, .success)
        XCTAssertEqual(sut.login(with: password), .success)
    }
    
    
    //MARK: - Helpers
    
    func makeSUT() -> (sut: AuthenticationService, store: SecureStore) {
        let store = KeyChainStore()
        try! store.deleteAll()
        let sut = AuthenticationManager(store: store, passwordService: PasswordManager())
        
        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(store)
        
        addTeardownBlock { [weak store] in
            try! store?.deleteAll()
        }
        
        return (sut, store)
    }
    
    func anyValidPassword() -> String {
        return UUID().uuidString
    }
}
