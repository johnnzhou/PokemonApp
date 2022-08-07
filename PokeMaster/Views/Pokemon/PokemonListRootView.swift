//
//  PokemonListRootView.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/17/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import SwiftUI

struct PokemonListRootView: View {
    
    @EnvironmentObject var store: Store
    
    var body: some View {
        NavigationView {
            if store.appState.pokemonList.pokemons == nil {
                Text("Loading...")
                    .onAppear {
                        store.dispatch(.loadPokemons)
                    }
            } else {
                PokemonList().navigationTitle("Pokemon List")
            }
        }
    }
}

struct PokemonListRootView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListRootView()
    }
}
