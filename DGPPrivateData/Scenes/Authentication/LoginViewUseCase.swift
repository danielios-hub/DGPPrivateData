//
//  LoginViewUseCase.swift
//  DGPPrivateData
//
//  Created by Daniel Gallego Peralta on 27/6/21.
//

import Foundation

class LoginViewUseCase {
    
    let faceIDWorker = AuthenticationWorker()
    
    enum Result {
        case success
        case failure(Error)
    }
    
    func visibleActions(session: AuthenticationService) -> (faceID: Bool, password: Bool) {
        let session = session.containsPreviousSession()
        
        switch session {
        case .none:
            return (faceIDWorker.isBiometricsAvailable(), true)
        case .faceID:
            return (true, false)
        case .password:
            return (false, true)
        }
    }
    
    func performFaceIDAuthentification(completion: @escaping (Result) -> Void) {
        faceIDWorker.doAuthentication { result in
            DispatchQueue.main.async {
                switch result {
                case .success(_):
                    completion(.success)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    
    
}
