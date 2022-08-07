//
//  LoadAbilitiesRequest.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 3/23/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import Foundation
import Combine

struct LoadAbilitiesRequest {
    
    let abilityEntry: Pokemon.AbilityEntry
    
    var publisher: AnyPublisher<AbilityViewModel, AppError> {
        URLSession.shared
            .dataTaskPublisher(for: abilityEntry.ability.url)
            .map { $0.data }
//            .print()
            .decode(type: Ability.self, decoder: appDecoder)
            .map { AbilityViewModel(ability: $0) }
            .mapError { AppError.networkingFailed($0) }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
