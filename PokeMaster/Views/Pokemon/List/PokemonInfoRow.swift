//
//  PokemonInfoRow.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/14/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import SwiftUI
import Kingfisher

struct PokemonInfoRow: View {
    @EnvironmentObject var store: Store
    
    @State private var showAlert = false
    
    let model: PokemonViewModel
    let expanded: Bool
    var body: some View {
        VStack {
            HStack {
                KFImage(model.iconImageURL)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .aspectRatio(contentMode: .fit)
                    .shadow(radius: 4)
                Spacer()
                VStack(alignment: .trailing) {
                    Text(model.name)
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    Text(model.nameEN)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding(.top, 12)
            }.padding(.top, 12)
            Spacer() // make two HStacks more stable during shrinking and expanding
            HStack(spacing: expanded ? 20 : -30) {
                Spacer()
                
                Button(action: {
                    showAlert = store.appState.settings.loginUser == nil
                }) {
                    Image(systemName: "star")
                        .modifier(ButtonModifier())
                }.alert("Need an account", isPresented: $showAlert) {
                    Button(role: .cancel) {showAlert = false} label: {
                        Text("Cancel")
                    }
                    
                    Button("Log in") {
                        store.dispatch(.switchTab(tabItem: .settings))
                    }
                }
                Button(action: {
                    let target = !store.appState.pokemonList.selectionState.panelPresented
                    self.store.dispatch(.togglePanelPresenting(presenting: target))
                }) {
                    Image(systemName: "chart.bar")
                        .modifier(ButtonModifier())
                }
                
                Button {
                    store.dispatch(.openSafariView)
                } label: {
                    Image(systemName: "info.circle").modifier(ButtonModifier())
                }.sheet(isPresented: expanded ? $store.appState.pokemonList.isSFViewActive : .constant(false)) {
                    SafariView(url: model.detailPageURL) {
                        self.store.dispatch(.closeSafariView)
                    }
                }
            }.padding(.bottom, 12).opacity(expanded ? 1.0 : 0.0).frame(maxHeight: expanded ? .infinity : 0)
        }
        .frame(height: expanded ? 120 : 80)
        .padding(.leading, 23)
        .padding(.trailing, 15)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(model.color, style: StrokeStyle(lineWidth: 4))
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(gradient: Gradient(colors: [.white, model.color]), startPoint: .leading, endPoint: .trailing)
                    )
            }
        )
        .padding(.horizontal)
    }
}

struct PokemonInfoRow_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PokemonInfoRow(model: .sample(id: 1), expanded: false)
            PokemonInfoRow(model: .sample(id: 21), expanded: true)
            PokemonInfoRow(model: .sample(id: 25), expanded: false)
        }
    }
}

struct ButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.system(size: 25))
            .foregroundColor(.white)
            .frame(width: 30, height: 30)
    }
}
