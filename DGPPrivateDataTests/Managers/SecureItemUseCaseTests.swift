//
//  SecureStore.swift
//  DGPPrivateDataTests
//
//  Created by Daniel Gallego Peralta on 23/6/21.
//

import XCTest
import DGPPrivateData

class SecureItemUseCaseTests: XCTestCase {
    
    //MARK: - save
    
    func test_save_emptyKey_returnNil() {
        let store = AuthenticationStore()
        
        let result = store.save(key: "", value: anyValue())
        let expectedError = StoreError.emptyKey
        XCTAssertEqual(result, .failure(expectedError))
    }
    
    func test_save_emptyValue() {
        let store = AuthenticationStore()
        let result = store.save(key: anyKey(), value: "")
        let expectedError = StoreError.emptyValue
        XCTAssertEqual(result, .failure(expectedError))
    }
    
    func test_save_emptyKeyAndValue() {
        let store = AuthenticationStore()
        let result = store.save(key: "", value: "")
        let expectedError = StoreError.emptyKey
        XCTAssertEqual(result, .failure(expectedError))
    }
    
    func test_save_withKeyAndValue_storeValues() {
        let store = AuthenticationStore()
        let (key, value) = (anyKey(), anyValue())
        let result = store.save(key: key, value: value)
        XCTAssertEqual(result, .success)
        XCTAssertEqual(store.get(key), value)
    }
    
    //MARK: - Get
    
    func test_get_withEmptyKey_returnNil() {
        let store = AuthenticationStore()
        XCTAssertEqual(store.get(""), nil)
    }
    
    func test_get_withKey_andNoValue_returnNil() {
        let store = AuthenticationStore()
        XCTAssertEqual(store.get(anyKey()), nil)
    }
    
    func test_get_withKey_andValue_returnValue() {
        let store = AuthenticationStore()
        let (key, value) = (anyKey(), anyValue())
        _ = store.save(key: key, value: value)
        XCTAssertEqual(store.get(key), value)
    }
    
    func anyKey() -> String {
        return "any-key"
    }
    
    func anyValue() -> String{
        return "any-value"
    }
}
