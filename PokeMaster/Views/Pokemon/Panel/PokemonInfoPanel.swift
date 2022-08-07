//
//  PokemonInfoPanel.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/16/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import SwiftUI

struct PokemonInfoPanel: View {

    @EnvironmentObject var store: Store

    @Environment(\.colorScheme) var colorScheme

    let model: PokemonViewModel
    var abilities: [AbilityViewModel]? {
        store.appState.pokemonList.abilityViewModels(for: model.pokemon)
    }

    var topIndicator: some View {
        RoundedRectangle(cornerRadius: 3)
            .frame(width: 40, height: 6)
            .opacity(0.2)
    }

    var pokemonDescription: some View {
        Text(model.descriptionText)
        .font(.callout)
        .foregroundColor(
            colorScheme == .light ? Color(hex: 0x666666) : Color(hex: 0xAAAAAA)
        )
        .fixedSize(horizontal: false, vertical: true)
    }

    var body: some View {
        VStack(spacing: 20) {
            topIndicator
            Group {
                Header(model: model)
                pokemonDescription
            }.animation(nil) // Fix for text animation which causes it round cornered...
            Divider()
            HStack(spacing: 20) {
                AbilityList(
                    model: model,
                    abilityModels: abilities
                )
//                RadarView(
//                    values: model.pokemon.stats.map { $0.baseStat },
//                    color: model.color,
//                    max: 120,
//                    progress: CGFloat(store.appState.pokemonList.selectionState.radarProgress),
//                    shouldAnimate: store.appState.pokemonList.selectionState.shouldAnimate
//                )
//                    .frame(width: 100, height: 100)
                RadarView(
                    values: model.pokemon.stats.map { $0.baseStat },
                    color: model.color,
                    max: 120,
                    progress: CGFloat(store.appState.pokemonList.selectionState.radarProgress),
                    shouldAnimate: store.appState.pokemonList.selectionState.radarShouldAnimate
                )
                .frame(width: 100, height: 100)
            }
        }
        .padding(.top, 12)
        .padding(.bottom, 30)
        .padding(.horizontal, 30)
        .blurBackground(style: .systemMaterial)
        .cornerRadius(20)
        .fixedSize(horizontal: false, vertical: true)
    }
}

//struct PokemonInfoPanel: View {
//
//    @EnvironmentObject var store: Store
//
//    var model: PokemonViewModel
//    var abilities: [AbilityViewModel]? {
//        store.appState.pokemonList.abilityViewModels(for: model.pokemon)
//    }
//
//    var topIndicator: some View {
//        RoundedRectangle(cornerRadius: 3)
//            .frame(width: 40, height: 6)
//            .opacity(0.2)
//    }
//
//    var pokemonDescription: some View {
//        Text(model.descriptionTextEN)
//            .font(.callout)
//            .foregroundColor(Color(hex: 0x666666))
//            .fixedSize(horizontal: false, vertical: false)
//    }
//
//
////    var body: some View {
////        VStack(spacing: 20) {
////            topIndicator
////            Group {
////                Header(model: model)
////                pokemonDescription
////            }.animation(nil, value: 0)
////            Divider()
////            HStack(spacing: 20) {
////                AbilityList(model: model, abilityModels: abilities)
////                RadarView(values: model.pokemon.stats.map {$0.baseStat},
////                          color: model.color,
////                          max: 120,
////                          progress: CGFloat(store.appState.pokemonList.selectionState.radarProgress),
////                          shouldAnimate: store.appState.pokemonList.selectionState.shouldAnimate
////                )
////                    .frame(width: 100, height: 100)
////            }
////        }
////        .padding(.top, 12)
////        .padding(.bottom, 30)
////        .padding(.horizontal, 30)
////        .blurBackground(style: .systemMaterial)
////        .cornerRadius(20)
////        .fixedSize(horizontal: false, vertical: true)
////    }
//
//    var body: some View {
//        VStack(spacing: 20) {
//            topIndicator
//            Group {
//                Header(model: model)
//                pokemonDescription
//            }.animation(nil) // Fix for text animation which causes it round cornered...
//            Divider()
//            HStack(spacing: 20) {
//                AbilityList(
//                    model: model,
//                    abilityModels: abilities
//                )
//                RadarView(
//                    values: model.pokemon.stats.map { $0.baseStat },
//                    color: model.color,
//                    max: 120,
//                    progress: CGFloat(store.appState.pokemonList.selectionState.radarProgress),
//                    shouldAnimate: store.appState.pokemonList.selectionState.shouldAnimate
//                )
//                    .frame(width: 100, height: 100)
//            }
//        }
//        .padding(.top, 12)
//        .padding(.bottom, 30)
//        .padding(.horizontal, 30)
//        .blurBackground(style: .systemMaterial)
//        .cornerRadius(20)
//        .fixedSize(horizontal: false, vertical: true)
//    }
//}

extension PokemonInfoPanel {
    struct Header: View {
        let model: PokemonViewModel
        
        var pokemonIcon: some View {
            Image("Pokemon-\(model.id)")
                .resizable()
                .frame(width: 68, height: 68)
        }
        
        var nameSpecies: some View {
            VStack(spacing: 10) {
                VStack {
                    Text(model.name)
                        .foregroundColor(model.color)
                        .font(.system(size: 22))
                        .fontWeight(.bold)
                    Text(model.nameEN)
                        .foregroundColor(model.color)
                        .font(.system(size: 13))
                        .fontWeight(.bold)
                        
                }
                Text(model.genusEN)
                    .foregroundColor(.gray)
                    .font(.system(size: 13))
                    .fontWeight(.bold)
            }
        }
        
        var verticalDivider: some View {
            RoundedRectangle(cornerRadius: 1)
                .frame(width: 1, height: 44)
                .foregroundColor(Color(hex: 0))
                .opacity(0.1)
        }
        
        var bodyStatus: some View {
            VStack {
                HStack {
                    Text("Height")
                        .foregroundColor(.gray)
                        .font(.system(size: 11))
                    Text(model.height)
                        .font(.system(size: 11))
                        .foregroundColor(model.color)
                }
                HStack {
                    Text("Weight")
                        .foregroundColor(.gray)
                        .font(.system(size: 11))
                    Text(model.weight)
                        .foregroundColor(model.color)
                        .font(.system(size: 11))
                }
            }
        }
        
        var typeInfo: some View {
            HStack {
                ForEach(model.types) { type in
                    ZStack {
                        RoundedRectangle(cornerRadius: 7)
                            .fill(type.color)
                            .frame(width: 36, height: 14)
                        Text(type.name)
                            .font(.system(size: 10))
                            .foregroundColor(.white)
                    }
                    
                }
            }
        
        }
        
        var body: some View {
            HStack(spacing: 18) {
                pokemonIcon
                nameSpecies
                verticalDivider
                VStack(spacing: 12) {
                    bodyStatus
                    typeInfo
                }
                
            }
        }
    }
}

struct PokemonInfoPanel_Previews: PreviewProvider {
    static var previews: some View {
        PokemonInfoPanel(model: .sample(id: 1))
    }
}
