//
//  AppError.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/24/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import Foundation

enum AppError: Error, Identifiable {
    var id: String {localizedDescription}
    
    case passwordWrong
    case networkingFailed(Error)
    case unableToRegister
}

extension AppError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .passwordWrong: return "Incorrect Password"
        case .networkingFailed(let e):
            return e.localizedDescription
        case .unableToRegister: return "Unable to Register"
        }
    }
}
