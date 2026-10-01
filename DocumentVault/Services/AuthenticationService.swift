//
//  AuthenticationService.swift
//  DocumentVault
//
//  Created by John Martino on 10/1/26.
//

import Foundation
import LocalAuthentication

actor AuthenticationService {
    func authenticate() async throws -> Bool {
        let context = LAContext()
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
