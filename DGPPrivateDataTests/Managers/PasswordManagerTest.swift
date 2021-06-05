//
//  PasswordManagerTest.swift
//  DGPPrivateDataTests
//
//  Created by Daniel Gallego Peralta on 22/5/21.
//

import Foundation
import XCTest
@testable import DGPPrivateData

class PasswordManagerTest: XCTestCase {
    
    func test_generatePassword_emptyConfig() {
        let config = createConfig(lowercase: 0, uppercase: 0, digit: 0, symbol: 0)
        let sut = PasswordManager(config: config)
        let password = sut.generatePassword()
        XCTAssertTrue(password.isEmpty)
    }
    
    //Negative Test not posible for UInt
    
    func test_generatePassword_OneCharacter_lowercase() {
        let config = createConfig(lowercase: 1, uppercase: 0, digit: 0, symbol: 0)
        let sut = PasswordManager(config: config)
        let password = sut.generatePassword()
        XCTAssertEqual(password.count, 1)
        XCTAssertTrue(sut.chars.contains(password))
    }
    
    func test_generatePassword_OneCharacter_uppercase() {
        let config = createConfig(lowercase: 0, uppercase: 1, digit: 0, symbol: 0)
        let sut = PasswordManager(config: config)
        let password = sut.generatePassword()
        XCTAssertEqual(password.count, 1)
        XCTAssertTrue(sut.charsUpper.contains(password))
    }
    
    func test_generatePassword_OneCharacter_digit() {
        let config = createConfig(lowercase: 0, uppercase: 0, digit: 1, symbol: 0)
        let sut = PasswordManager(config: config)
        let password = sut.generatePassword()
        XCTAssertEqual(password.count, 1)
        XCTAssertTrue(sut.digits.contains(password))
    }
    
    func test_generatePassword_OneCharacter_usymbol() {
        let config = createConfig(lowercase: 0, uppercase: 0, digit: 0, symbol: 1)
        let sut = PasswordManager(config: config)
        let password = sut.generatePassword()
        XCTAssertEqual(password.count, 1)
        XCTAssertTrue(sut.symbols.contains(password))
    }
    
    func test_generatePassword_defaultConfig() {
        let config = createConfig()
        let sut = PasswordManager(config: config)
        let password = sut.generatePassword()
        checkOcurrences(for: password, with: config, in: sut)
    }
    
    func test_generatePassword_HighValues() {
        let config = createConfig(lowercase: 500, uppercase: 500, digit: 500, symbol: 500)
        let sut = PasswordManager(config: config)
        let password = sut.generatePassword()
        checkOcurrences(for: password, with: config, in: sut)
    }
    
    
    
    //MARK: - Helpers
    
    func createConfig(lowercase: UInt? = nil, uppercase: UInt? = nil, digit: UInt? = nil, symbol: UInt? = nil) -> PasswordConfig {
        var config = PasswordConfig()
        
        if let value = lowercase {
            config.lowercaseCount = value
        }
        
        if let value = uppercase {
            config.uppercaseCount = value
        }
        
        if let value = digit {
            config.digitCount = value
        }
        
        if let value = symbol {
            config.symbolCount = value
        }
        
        return config
    }
    
    func numberOfOccurrences(for password: String, in characters: String) -> UInt {
        var occurrences: UInt = 0
        for character in password {
            if characters.contains(character) {
                occurrences += 1
            }
        }
        return occurrences
    }
    
    func checkOcurrences(for password: String, with config: PasswordConfig, in sut: PasswordManager) {
        XCTAssertEqual(numberOfOccurrences(for: password, in: sut.chars), config.lowercaseCount)
        XCTAssertEqual(numberOfOccurrences(for: password, in: sut.charsUpper), config.uppercaseCount)
        XCTAssertEqual(numberOfOccurrences(for: password, in: sut.digits), config.digitCount)
        XCTAssertEqual(numberOfOccurrences(for: password, in: sut.symbols), config.symbolCount)
    }
    
}
