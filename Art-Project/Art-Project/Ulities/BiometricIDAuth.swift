//
//  BiometricIDAuth.swift
//  TableGit
//
//  Created by MINERVA on 28/07/2022.
//

import LocalAuthentication

enum BiometicType {
    
    case none, touchID, faceID, unknown
    
}

enum BiometricError: LocalizedError {
    
    case authenticationFailed, userCancel, userFallback, biometryNotAvailable, biometryNotEnrolled, biometryLockout, unknown
    
    var errorDescription: String? {
        switch self {
        case .authenticationFailed:
            return "There was a problem verifying your identity."
            
        case .userCancel:
            return "You pressed cancel."
            
        case .userFallback:
            return "You pressed password."
            
        case .biometryNotAvailable:
            return "Face ID/Touch ID is not available."
            
        case .biometryNotEnrolled:
            return "Face ID/Touch ID is not set up."
            
        case .biometryLockout:
            return "Face ID/Touch ID is locked."
            
        case .unknown:
            return "Face ID/Touch ID may not be configured"
            
        }
        
    }
    
}

class BiometricIDAuth {
    //MARK: Properties
    static var shared = BiometricIDAuth()
    private let context = LAContext()
    private let policy: LAPolicy
    private let localizedReason: String
    private var error: NSError?

    //MARK: Init
    init(policy: LAPolicy = .deviceOwnerAuthenticationWithBiometrics, localizedReason: String = "Access your password on the keychain", localizedFallbackTitle: String = "Enter App Password", localziedCancelTitle: String = "Touch me not") {
        
        self.policy = policy
        self.localizedReason = localizedReason
        context.localizedFallbackTitle = localizedFallbackTitle
        context.localizedCancelTitle = localziedCancelTitle
        
    }
    
    //MARK: Helpers
    private func biometricType(for type: LABiometryType) -> BiometicType {
        
        switch type {
        case .none:
            return .none
            
        case .touchID:
            return .touchID
            
        case .faceID:
            return .faceID
            
        @unknown default:
            return .unknown
            
        }
        
    }
    
    private func biometricError(from nsError: NSError) -> BiometricError {
        let error: BiometricError
        
        switch nsError {
        case LAError.authenticationFailed:
                error = .authenticationFailed
            
            case LAError.userCancel:
                error = .userCancel
            
            case LAError.userFallback:
                error = .userFallback
            
            case LAError.biometryNotAvailable:
                error = .biometryNotAvailable
            
            case LAError.biometryNotEnrolled:
                error = .biometryNotEnrolled
            
            case LAError.biometryLockout:
                error = .biometryLockout
            
            default:
                error = .unknown
        }
        
        return error
        
    }
    
    func canEvaluate() -> (success: Bool, biometricType: BiometicType, biometricError: BiometricError?){
        
        guard context.canEvaluatePolicy(policy, error: &error) else {
            
            let type = biometricType(for: context.biometryType)
            
            guard let error = error else {
                return (false, type, nil)
            }

            return (false, type, biometricError(from: error))
            
        }
        
        return (true, biometricType(for: context.biometryType), nil)
        
    }
    
    func evaluate() async -> (success: Bool, biometricError: BiometricError?){
        
        guard canEvaluate().success else {return (false, canEvaluate().biometricError)}
        
        do {
              
            return (try await context.evaluatePolicy(policy, localizedReason: localizedReason), nil)
            
        } catch let error {
            
            return (false, biometricError(from: error as NSError))

        }
        
    }
    
    
}
