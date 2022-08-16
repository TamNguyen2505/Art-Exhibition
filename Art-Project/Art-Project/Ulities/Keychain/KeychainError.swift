//
//  KeychainError.swift
//  TableGit
//
//  Created by MINERVA on 01/08/2022.
//

import Foundation

enum KeychainError: Error {
    
    case noPassword
    case stringToDataConversionError
    case dataToStringConversionError
    case unhandledError(status: String)
    
}
