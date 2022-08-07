//
//  AppState.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/22/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

struct AppState {
    var settings = Settings()
    var pokemonList = PokemonList()
    var mainTab = MainTab()
}

extension AppState {
    struct PokemonList {
        
        var isSFViewActive = false

        struct SelectionState {
            var expandingIndex: Int? = nil
            var panelIndex: Int? = nil
            var panelPresented = false
            var radarProgress: Double = 0
            var radarShouldAnimate = true

            func isExpanding(_ id: Int) -> Bool {
                expandingIndex == id
            }
        }

        @FileStorage(directory: .cachesDirectory, fileName: "pokemons.json")
        var pokemons: [Int: PokemonViewModel]?

        @FileStorage(directory: .cachesDirectory, fileName: "abilities.json")
        var abilities: [Int: AbilityViewModel]?

        func abilityViewModels(for pokemon: Pokemon) -> [AbilityViewModel]? {
            guard let abilities = abilities else { return nil }
            return pokemon.abilities.compactMap { abilities[$0.ability.url.extractedID!] }
        }
        
        var loadingError: AppError? = nil
        
        var loadingPokemons = false

        var selectionState = SelectionState()

        var searchText = ""

        func displayPokemons(with settings: Settings) -> [PokemonViewModel] {

            func isFavorite(_ pokemon: PokemonViewModel) -> Bool {
                guard let user = settings.loginUser else { return false }
                return user.isFavoritePokemon(id: pokemon.id)
            }

            func containsSearchText(_ pokemon: PokemonViewModel) -> Bool {
                guard !searchText.isEmpty else {
                    return true
                }
                return pokemon.name.contains(searchText) ||
                       pokemon.nameEN.lowercased().contains(searchText.lowercased())
            }

            guard let pokemons = pokemons else {
                return []
            }

            let sortFunc: (PokemonViewModel, PokemonViewModel) -> Bool
            switch settings.sorting {
            case .id:
                sortFunc = { $0.id < $1.id }
            case .name:
                sortFunc = { $0.nameEN < $1.nameEN }
            case .color:
                sortFunc = {
                    $0.species.color.name.rawValue < $1.species.color.name.rawValue
                }
            case .favorite:
                sortFunc = { p1, p2 in
                    switch (isFavorite(p1), isFavorite(p2)) {
                    case (true, true): return p1.id < p2.id
                    case (false, false): return p1.id < p2.id
                    case (true, false): return true
                    case (false, true): return false
                    }
                }
            }

            var filterFuncs: [(PokemonViewModel) -> Bool] = []
            filterFuncs.append(containsSearchText)
            if settings.showFavoriteOnly {
                filterFuncs.append(isFavorite)
            }

            let filterFunc = filterFuncs.reduce({ _ in true}) { r, next in
                return { pokemon in
                    r(pokemon) && next(pokemon)
                }
            }

            return pokemons.values
                .filter(filterFunc)
                .sorted(by: sortFunc)
        }
    }
}

extension AppState {
    struct Settings {
        enum Sorting: String, CaseIterable {
            case id, name, color, favorite
        }
        
        @UserPreferences(key: "showEnglishName", value: true)
        var showEnglishName
        
        @UserPreferences(key: "sortedBy", value: AppState.Settings.Sorting.id)
        var sorting

        @UserPreferences(key: "showFavorite", value: false)
        var showFavoriteOnly
        
        enum AccountBehavior: CaseIterable {
            case register, login
        }
        
        class AccountChecker {
            @Published var accountBehavior = AccountBehavior.login
            @Published var email = ""
            @Published var password = ""
            @Published var verifyPassword = ""
            
            var isEmailValid: AnyPublisher<Bool,Never> {
                let remoteVerify = $email
                    .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
                    .removeDuplicates()
                    .flatMap { email -> AnyPublisher<Bool, Never> in
                        let validEmail = email.isValidEmailAddress
                        let canSkip = self.accountBehavior == .login
                        switch (validEmail,canSkip) {
                            
                        case (false, _):
                            return Just(false).eraseToAnyPublisher()
                        case (true,false):
                            return EmailCheckingRequest(email: email)
                                .publisher
                                .eraseToAnyPublisher()
                        case (true, true):
                            return Just(true).eraseToAnyPublisher()
                        }
                        
                    }
                let emailLocalValid = $email.map { $0.isValidEmailAddress }
                let canSkipRemoteVerify = $accountBehavior.map {$0 == .login}
                return Publishers.CombineLatest3(emailLocalValid, canSkipRemoteVerify, remoteVerify)
                    .map {$0 && ($1 || $2)}
                    .eraseToAnyPublisher()
            }
            
            var isPasswordValid: AnyPublisher<Bool, Never> {
                let isPasswordEmpty = $password.map { $0.isEmpty }
                let isPasswordVerifyEmpty = $verifyPassword.map { $0.isEmpty }
                let passwordEqualsVerified = $verifyPassword.debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
                    .removeDuplicates()
                    .flatMap {verify -> AnyPublisher<Bool, Never> in
                        return Just(verify == self.password).eraseToAnyPublisher()
                    }
                
                return Publishers.CombineLatest3(isPasswordEmpty, isPasswordVerifyEmpty, passwordEqualsVerified)
                    .map { !$0 && !$1 && $2 }
                    .eraseToAnyPublisher()
            }
            
            var canRegister: AnyPublisher<Bool, Never> {
                Publishers.CombineLatest(isEmailValid, isPasswordValid)
                    .map {$0 && $1}
                    .eraseToAnyPublisher()
            }
        }
        
        var checker = AccountChecker()
        var isEmailValid: Bool = false
        var canRegister: Bool = false
        
        @FileStorage(directory: .documentDirectory, fileName: "user.json") var loginUser: User?
        var loginRequesting = false
        var loginError: AppError?
    }
}

extension AppState {
    struct MainTab {
        enum Index: Hashable {
            case list, settings
        }

        var selection: Index = .list
    }
}
