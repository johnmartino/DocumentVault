//
//  AuthenticationService.swift
//  DocumentVault
//
//  Created by John Martino on 10/1/26.
//

import Foundation
import LocalAuthentication

actor AuthenticationService {
    private let context = LAContext()
    
    var biometricImageName: String {
        _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        switch context.biometryType {
            case .faceID: return "faceid"
            case .touchID: return "touchid"
            default: return "lock.fill"
        }
    }
    
    func authenticate() async throws -> Bool {
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."
            try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason)
            return true
        } else {
            return false
        }
    }
}
