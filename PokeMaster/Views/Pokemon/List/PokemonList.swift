//
//  PokemonList.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/14/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import SwiftUI

struct PokemonList: View {
    @EnvironmentObject var store: Store
//    @State var expandingIndex: Int?
    
    var body: some View {
        if let _ = store.appState.pokemonList.loadingError {
            Button {
                store.dispatch(.loadPokemons)
            } label: {
                HStack {
                    Image(systemName: "arrow.clockwise")
                    Text("Retry")
                }
            }
        } else {
            ScrollView {
                LazyVStack{
                    TextField("Search", text: $store.appState.pokemonList.searchText.animation(nil))
                        .frame(height: 40)
                        .padding(.horizontal, 25)
                    ForEach(store.appState.pokemonList.displayPokemons(with: store.appState.settings)) { pokemon in
                        PokemonInfoRow(model: pokemon, expanded: store.appState.pokemonList.selectionState.isExpanding(pokemon.id))
                            .onTapGesture {
                                withAnimation(.spring(response: 0.55, dampingFraction: 0.425, blendDuration: 0)) {
                                    store.dispatch(.toggleListSelection(index: pokemon.id))
                                    store.dispatch(.loadAbilities(pokemon: pokemon.pokemon))
                                }
                            }
                    }
                }
            }
            Spacer().frame(height: 8)
        }
    }
}

struct PokemonList_Previews: PreviewProvider {
    static var previews: some View {
        PokemonList()
    }
}
