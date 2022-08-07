//
//  AppAction.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/23/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import Foundation
enum AppAction {
    case login(email: String, password: String)
    case logout
    case accountBehaviorDone(result: Result<User, AppError>)
    case emailValid(valid: Bool)
    case canRegister(valid: Bool)
    case register(email: String, password: String)
    case clearCache
    case loadPokemons
    case loadPokemonsDone(result: Result<[PokemonViewModel], AppError>)
    case toggleListSelection(index: Int?)
    case loadAbilities(pokemon: Pokemon)
    case loadAbilitiesDone(result: Result<[AbilityViewModel], AppError>)
    case togglePanelPresenting(presenting: Bool)
    case closeSafariView
    case openSafariView
    case switchTab(tabItem: AppState.MainTab.Index)
}
