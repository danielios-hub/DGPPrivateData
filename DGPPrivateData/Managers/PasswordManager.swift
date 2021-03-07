//
//  PasswordManager.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 7/3/21.
//

import Foundation

protocol PasswordGenerator {
    func generatePassword() -> String
}

public class PasswordManager: PasswordGenerator {
    
    public struct PasswordConfig {
        let digitCount : Int = 2
        let uppercaseCount: Int = 6
        let symbolCount: Int = 2
        let totalCharacterCount: Int = 16
        
        var totalLowercase: Int {
            return totalCharacterCount - digitCount - uppercaseCount - symbolCount
        }
    }
    
    //MARK: - Instance properties
    
    var config = PasswordConfig()
    let chars = "abcdefghijklmnopqrstuvwxyz"
    let digits = "1234567890"
    let symbols = "#$%&*+-.;=@_"
    
    var charsUpper: String {
        return chars.uppercased()
    }
    
    static public var shared = PasswordManager()
    
    private init() {}
    
    public init(config: PasswordConfig) {
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
        
        let rndLowercase = String((0..<config.totalLowercase).compactMap { _ in
            return chars.randomElement()
        })
        
        let combinedString = rndSymbols + rndDigit + rndUppercase + rndLowercase
        return String(combinedString.shuffled())
    }
}

//extension RangeReplaceableCollection  {
//    /// Returns a new collection containing this collection shuffled
//    var shuffled: Self {
//        var elements = self
//        return elements.shuffleInPlace()
//    }
//    /// Shuffles this collection in place
//    @discardableResult
//    mutating func shuffleInPlace() -> Self  {
//        indices.forEach {
//            let subSequence = self[$0...$0]
//            let index = indices.randomElement()!
//            replaceSubrange($0...$0, with: self[index...index])
//            replaceSubrange(index...index, with: subSequence)
//        }
//        return self
//    }
//    func choose(_ n: Int) -> SubSequence { return shuffled.prefix(n) }
//}
