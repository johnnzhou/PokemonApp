//
//  AppCommand.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/24/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import Foundation
import Combine
import Kingfisher

protocol AppCommand {
    func execute(in store: Store)
}

struct LoginAppCommand: AppCommand {
    
    let email: String
    let password: String
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        LoginRequest(email: email, password: password)
            .publisher
            .sink { complete in
                if case .failure(let error) = complete {
                    store.dispatch(.accountBehaviorDone(result: .failure(error)))
                }
                token.unseal()
            } receiveValue: { user in
                store.dispatch(.accountBehaviorDone(result: .success(user)))
            }
            .seal(in: token)
    }
}

struct EmailCheckingRequest {
    let email: String
    var publisher: AnyPublisher<Bool, Never> {
        Future<Bool,Never> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if self.email.lowercased() == "zhouz46@uw.edu" {
                    promise(.success(false))
                } else {
                    promise(.success(true))
                }
            }
        }.receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct LoadPokemonsCommand: AppCommand {
    func execute(in store: Store) {
        let token = SubscriptionToken()
        LoadPokemonRequest.all.sink { complete in
            if case .failure(let error) = complete {
                store.dispatch(.loadPokemonsDone(result: .failure(error)))
            }
            token.unseal()
        } receiveValue: { value in
            store.dispatch(.loadPokemonsDone(result: .success(value)))
        }.seal(in: token)

    }
}

struct RegisterAppCommand: AppCommand {
    
    let email: String
    let password: String
    
    func execute(in store: Store) {
        let token = SubscriptionToken()
        RegisterRequest(email: email, password: password).publisher.sink { complete in
            if case .failure(let error) = complete {
                store.dispatch(.accountBehaviorDone(result: .failure(error)))
            }
            token.unseal()
        } receiveValue: { user in
            store.dispatch(.accountBehaviorDone(result: .success(user)))
        }.seal(in: token)
    }
}

struct ClearCacheCommand: AppCommand {
    func execute(in store: Store) {
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
    }
}

struct LoadAbilitiesCommand: AppCommand {
    
    let pokemon: Pokemon

    func load(pokemonAbility: Pokemon.AbilityEntry, in store: Store)
        -> AnyPublisher<AbilityViewModel, AppError>
    {
        if let value = store.appState.pokemonList.abilities?[pokemonAbility.id.extractedID!] {
            return Just(value)
                .setFailureType(to: AppError.self)
                .eraseToAnyPublisher()
        } else {
            return LoadAbilitiesRequest(abilityEntry: pokemonAbility).publisher
        }
    }

    func execute(in store: Store) {
        let token = SubscriptionToken()
        pokemon.abilities
            .map { load(pokemonAbility: $0, in: store) }
            .zipAll
            .sink(
                receiveCompletion: { complete in
                    if case .failure(let error) = complete {
                        store.dispatch(.loadAbilitiesDone(result: .failure(error)))
                    }
                    token.unseal()
                },
                receiveValue: { value in
                    store.dispatch(.loadAbilitiesDone(result: .success(value)))
                }
            )
            .seal(in: token)
    }
    
//    let pokemon: Pokemon
//
//    func load(ability abilityEntry: Pokemon.AbilityEntry, in store: Store) -> AnyPublisher<AbilityViewModel, AppError> {
//        if let value = store.appState.pokemonList.abilities?[abilityEntry.id.extractedID!] {
//            print("value is \(value.descriptionText)")
//            return Just(value).setFailureType(to: AppError.self)
//                .eraseToAnyPublisher()
//        } else {
//            print("ability entry is \(abilityEntry)")
//            return LoadAbilitiesRequest(abilityEntry: abilityEntry).publisher
//        }
//    }
//
//    func execute(in store: Store) {
//        let token = SubscriptionToken()
//        pokemon.abilities
//            .map { load(ability: $0, in: store) }
//            .zipAll
//            .sink { complete in
//                if case .failure(let error) = complete {
//                    print("failed")
//                    store.dispatch(.loadAbilitiesDone(result: .failure(error)))
//                }
//            } receiveValue: { value in
//                print("in execute, valu is \(value)")
//                store.dispatch(.loadAbilitiesDone(result: .success(value)))
//            }.seal(in: token) // seal the wrong place
//    }
}
