//
//  XCTestCaseExtension.swift
//  DGPPrivateDataTests
//
//  Created by Daniel Gallego Peralta on 6/6/21.
//

import XCTest

extension XCTestCase {
    
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potencial memory leak", file: file, line: line)
        }
    }
    
}
