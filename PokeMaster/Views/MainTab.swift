//
//  MainTab.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/22/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import SwiftUI


struct MainTab: View {

    @EnvironmentObject var store: Store

    private var pokemonList: AppState.PokemonList {
        store.appState.pokemonList
    }
    private var pokemonListBinding: Binding<AppState.PokemonList> {
        $store.appState.pokemonList
    }

    private var selectedPanelIndex: Int? {
        pokemonList.selectionState.panelIndex
    }

    var body: some View {
        TabView(selection: $store.appState.mainTab.selection) {
            PokemonListRootView().tabItem {
                Image(systemName: "list.bullet.below.rectangle")
                Text("List")
            }.tag(AppState.MainTab.Index.list)

            SettingRootView().tabItem {
                Image(systemName: "gear")
                Text("Settings")
            }.tag(AppState.MainTab.Index.settings)
        }
        .edgesIgnoringSafeArea(.top)
        .overlaySheet(isPresented: pokemonListBinding.selectionState.panelPresented) {
            if self.selectedPanelIndex != nil && self.pokemonList.pokemons != nil {
                PokemonInfoPanel(
                    model: self.pokemonList.pokemons![self.selectedPanelIndex!]!
                )
            }
        }
    }
}

struct MainTab_Previews: PreviewProvider {
    static var previews: some View {
        MainTab()
    }
}
