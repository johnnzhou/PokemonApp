//
//  RegisterRequest.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 3/23/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import Foundation
import Combine

struct RegisterRequest {
    let email: String
    let password: String
    
    var publisher: AnyPublisher<User, AppError> {
        Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1.5) {
                    let user = User(email: self.email, favoritePokemonIDs: Set<Int>())
                    promise(.success(user))
            }
            
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
}
