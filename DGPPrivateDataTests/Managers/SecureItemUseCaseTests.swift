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
        let store = makeSUT()
        let result = store.set(anyValue(), forKey: "")
        let expectedError = KeyChainError.noKey
        XCTAssertEqual(result, .failure(expectedError))
    }
    
    func test_save_emptyKeyAndValue() {
        let store = makeSUT()
        let result = store.set("", forKey: "")
        let expectedError = KeyChainError.noKey
        XCTAssertEqual(result, .failure(expectedError))
    }
     
     func test_save_emptyValue_removeKey() {
        let store = makeSUT()
        let (key, value) = (anyKey(), anyValue())
        let result = store.set(value, forKey: key)
        XCTAssertEqual(result, .success)
        XCTAssertEqual(store.get(key: key, withType: String.self), value)
     }
    
    //MARK: - Get
    
    func test_get_withEmptyKey_returnNil() {
        let store = makeSUT()
        XCTAssertEqual(store.get(key: "", withType: String.self), nil)
    }
    
    
    func test_get_withKey_andNoValue_returnNil() {
        let store = makeSUT()
        XCTAssertEqual(store.get(key: anyKey(), withType: String.self), nil)
    }
    
    func test_get_withKey_andValue_returnValue() {
        let store = makeSUT()
        let (key, value) = (anyKey(), anyValue())
        let result = store.set(value, forKey: key)
        XCTAssertEqual(result, .success)
        XCTAssertEqual(store.get(key: key, withType: String.self), value)
    }
    
    //MARK: - Helpers
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> SecureStore {
        let store = KeyChainStore()
        try! store.deleteAll()
        
        addTeardownBlock { [weak store] in
            try! store?.deleteAll()
        }
        
        trackForMemoryLeaks(store, file: file, line: line)
        return store
    }
    
    func anyKey() -> String {
        return "any-key"
    }
    
    func anyValue() -> String{
        return "any-value"
    }
}
