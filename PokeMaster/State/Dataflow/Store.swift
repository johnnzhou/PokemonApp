//
//  Store.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/22/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import Combine

class Store: ObservableObject {
    @Published var appState = AppState()
    var disposeBag = [AnyCancellable]()
    
    init() {
        setupObservers()
    }
    
    func setupObservers() {
        appState.settings.checker.isEmailValid.sink { isValid in
            self.dispatch(.emailValid(valid: isValid))
        }.store(in: &disposeBag)
        
        appState.settings.checker.canRegister.sink { canRegister in
            self.dispatch(.canRegister(valid: canRegister))
        }.store(in: &disposeBag)
    }
    
    static func reduce(state: AppState, action: AppAction) -> (AppState, AppCommand?) {
        var appState = state
        var appCommand: AppCommand?
        
        switch action {
        case .login(let email, let password):
            
            guard !appState.settings.loginRequesting else {
                break
            }
            
            appState.settings.loginRequesting = true
            appCommand = LoginAppCommand(email: email, password: password)
            
        case .accountBehaviorDone(result: let result):
            appState.settings.loginRequesting = false
            switch result {
            case .success(let user):
                appState.settings.loginUser = user
            case .failure(let error):
                appState.settings.loginError = error
                print("Error \(error)")
            }
        case .logout:
            if let _ = appState.settings.loginUser {
                appState.settings.loginUser = nil
                appState.settings.checker.email = ""
                appState.settings.checker.password = ""
                appState.settings.checker.verifyPassword = ""
            }
            
            // do nothing when user not logged in
            break
        case .emailValid(let valid):
            appState.settings.isEmailValid = valid
        case .loadPokemons:
            if appState.pokemonList.loadingPokemons {
                break
            }
            appState.pokemonList.loadingError = nil
            appState.pokemonList.loadingPokemons = true
            appCommand = LoadPokemonsCommand()
        case .loadPokemonsDone(let result):
            appState.pokemonList.loadingPokemons = false
            switch result {
            case .success(let model):
                appState.pokemonList.pokemons = Dictionary(uniqueKeysWithValues: model.map {($0.id, $0)})
            case .failure(let error):
                appState.pokemonList.loadingError = error
            }
        case .canRegister(let valid):
            appState.settings.canRegister = valid
        case .clearCache:
            appState.pokemonList.pokemons = nil
            appState.pokemonList.abilities = nil
            appState.pokemonList.loadingPokemons = false
            appState.settings.showEnglishName = true
            appState.settings.showFavoriteOnly = false
            appState.settings.sorting = .id
            appCommand = ClearCacheCommand()
        case .register(let email, let password):
            guard !appState.settings.loginRequesting else {
                break
            }
            
            appState.settings.loginRequesting = true
            appCommand = RegisterAppCommand(email: email, password: password)
        case .toggleListSelection(let index):
            let expanding = appState.pokemonList.selectionState.expandingIndex
            if expanding == index {
                appState.pokemonList.selectionState.expandingIndex = nil
                appState.pokemonList.selectionState.panelPresented = false
                appState.pokemonList.selectionState.radarProgress = 0
            } else {
                appState.pokemonList.selectionState.expandingIndex = index
                appState.pokemonList.selectionState.panelIndex = index
                appState.pokemonList.selectionState.radarShouldAnimate =
                appState.pokemonList.selectionState.radarProgress == 1 ? false : true
            }
            
        case .loadAbilities(let pokemon):
            appCommand = LoadAbilitiesCommand(pokemon: pokemon)
        case .loadAbilitiesDone(let result):
            switch result {
            case .success(let loadedAbilities):
                var abilities = appState.pokemonList.abilities ?? [:]
                for ability in loadedAbilities {
                    abilities[ability.id] = ability
                }
                appState.pokemonList.abilities = abilities
            case .failure(let error):
                print(error)
                
            }
        case .togglePanelPresenting(let presenting):
            appState.pokemonList.selectionState.panelPresented = presenting
            appState.pokemonList.selectionState.radarProgress = presenting ? 1 : 0
            
        case .closeSafariView:
            appState.pokemonList.isSFViewActive = false
        case .openSafariView:
            appState.pokemonList.isSFViewActive = true
        case .switchTab(tabItem: let tabItem):
            appState.mainTab.selection = tabItem
        }
        
        return (appState, appCommand)
    }
    
    
    func dispatch(_ action: AppAction) {
        #if DEBUG
        print("[ACTION]: \(action)")
        #endif
        let result = Store.reduce(state: appState, action: action)
        appState = result.0
        if let command = result.1 {
            #if DEBUG
            print("[COMMAND] \(command)")
            #endif
            command.execute(in: self)
        }
    }
}
