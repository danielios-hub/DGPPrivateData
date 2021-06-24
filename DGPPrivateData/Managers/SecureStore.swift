//
//  SecureStore.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 24/6/21.
//

import Foundation

public enum KeyChainError: Error {
    case `default`
    case noValue
    case unexpectedValue
    case noKey
}

public enum StoreResult: Equatable {
    case success
    case failure(Error)
    
    public static func ==(lhs: StoreResult, rhs: StoreResult) -> Bool {
        switch (lhs, rhs) {
        case (.success, .success):
            return true
        case let (.failure(errorLhs as KeyChainError?), .failure(errorRhs as KeyChainError?)):
            return errorLhs == errorRhs
        case let (.failure(errorLhs as NSError?), .failure(errorRhs as NSError?)):
            return errorLhs?.code == errorRhs?.code
        default:
            return false
        }
    }
}

public protocol SecureStore {
    func get<T: Decodable>(key: String, withType type: T.Type) -> T?
    func set<T: Encodable>(_ value: T?, forKey key: String) -> StoreResult
    func deleteAll() throws
}

public class KeyChainStore: SecureStore {

    var store: [String: String] = [:]
    let service = "es.danigp.DGPPrivateData"
    
    public init() {}
    
    public func get<T: Decodable>(key: String, withType type: T.Type) -> T? {
        let decoder = JSONDecoder()
        guard let data = try? readValue(forKey: key),
              let model = try? decoder.decode(type, from: data) else {
            return nil
        }
        
        return  model
    }
    
    public func set<T: Encodable>(_ value: T?, forKey key: String) -> StoreResult {
        guard key.isNotEmpty else {
            return .failure(KeyChainError.noKey)
        }
        let encoder = JSONEncoder()
        do {
            guard let value = value, let data = try? encoder.encode(value) else {
                try delete(key: key)
                return .success
            }
            try writeValue(data, forKey: key)
            return .success
        } catch {
            return .failure(error)
        }
    }
    
    public func deleteAll() throws {
        for key in try self.keys() {
            try delete(key: key)
        }
    }
    
    //MARK: - Private methods
    
    private func get(key: String) -> Data? {
        try? readValue(forKey: key)
    }
    
    private func set(_ value: Data?, forKey key: String) {
        guard let value = value else {
            //delete key
            try? delete(key: key)
            return
        }
        
        try? writeValue(value, forKey: key)
    }
    
    private func delete(key: String) throws {
        let query = createQuery(for: key)
        let status = SecItemDelete(query as CFDictionary)
        guard status == noErr || status == errSecItemNotFound else {
            throw KeyChainError.default
        }
    }
    
    private func readValue(forKey key: String) throws -> Data {
        var query = createQuery(for: key)
        query[String(kSecMatchLimit)] = kSecMatchLimitOne
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) { pointer in
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(pointer))
        }
        
        guard status != errSecItemNotFound else {
            throw KeyChainError.noValue
        }
        
        guard status == noErr else {
            throw KeyChainError.default
        }
        
        guard let item = queryResult as? [String:Any],
              let data = item[String(kSecValueData)] as? Data else {
            throw KeyChainError.unexpectedValue
        }
        
        return data
    }
    
    private func writeValue(_ value: Data?, forKey key: String) throws {
        do {
            try _ = readValue(forKey: key)
            var attributesToUpdate: [String: Any] = [:]
            attributesToUpdate[String(kSecValueData)] = value
            let query = createQuery(for: key)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            guard status == noErr else {
                throw KeyChainError.default
            }
        } catch KeyChainError.noValue {
            var newObject = createQuery(for: key)
            newObject[String(kSecValueData)] = value
            let status = SecItemAdd(newObject as CFDictionary, nil)
            guard status == noErr else {
                throw KeyChainError.default
            }
        } catch {
            fatalError()
        }
    }
    
    private func createQuery(for key: String? = nil) ->[String: Any] {
        var query: [String: Any] = [
            String(kSecClass): kSecClassGenericPassword,
            String(kSecAttrService): service,
        ]
        
        if let key = key {
            query[String(kSecAttrAccount)] = key
        }
        
        return query
    }
    
    private func keys() throws -> [String] {
        var query = createQuery()
        
        query[String(kSecMatchLimit)] = kSecMatchLimitAll
        query[String(kSecReturnAttributes)] = kCFBooleanTrue
        query[String(kSecReturnData)] = kCFBooleanFalse
        
        var queryResult: AnyObject?
        let status = withUnsafeMutablePointer(to: &queryResult) { pointer in
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(pointer))
        }
        
        guard status != errSecItemNotFound else {
            return []
        }
        
        guard status == noErr else {
            throw KeyChainError.default
        }
        
        guard let resultData = queryResult as? [[String: Any]] else {
            throw KeyChainError.unexpectedValue
        }
        
        var allKeys = [String]()
        for result in resultData {
            guard let key = result[kSecAttrAccount as String] as? String else {
                throw KeyChainError.unexpectedValue
            }
            allKeys.append(key)
        }
        return allKeys
    }
    
}
