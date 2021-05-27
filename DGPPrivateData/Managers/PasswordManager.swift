//
//  PasswordManager.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 7/3/21.
//

import Foundation

public struct PasswordConfig {
    var lowercaseCount: UInt = 8
    var uppercaseCount: UInt = 6
    var digitCount : UInt = 2
    var symbolCount: UInt = 2
    static let maximumCharacterForType: Int = 12
}

protocol PasswordGenerator {
    func generatePassword() -> String
    func setConfig(_ config: PasswordConfig)
}

public final class PasswordManager: PasswordGenerator {
    
    //MARK: - Instance properties
    
    private var config = PasswordConfig()
    let chars = "abcdefghijklmnopqrstuvwxyz"
    let digits = "1234567890"
    let symbols = "#$%&*+-.;=@_"
    
    var charsUpper: String {
        return chars.uppercased()
    }
    
    static public var shared = PasswordManager()
    
    public convenience init() {
        self.init(config: PasswordConfig())
    }
    
    public init(config: PasswordConfig) {
        self.config = config
    }
    
    func setConfig(_ config: PasswordConfig) {
        self.config = config
    }
    
    func generatePassword() -> String {
        let rndSymbols = String((0..<config.symbolCount).compactMap { _ in
            return symbols.randomElement()
        })
        
        let rndDigit = String((0..<config.digitCount).compactMap { _ in
            return digits.randomElement()
        })
        
        let rndUppercase = String((0..<config.uppercaseCount).compactMap { _ in
            return charsUpper.randomElement()
        })
        
        let rndLowercase = String((0..<config.lowercaseCount).compactMap { _ in
            return chars.randomElement()
        })
        
        let combinedString = rndSymbols + rndDigit + rndUppercase + rndLowercase
        return String(combinedString.shuffled())
    }
}
