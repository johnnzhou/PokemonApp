//
//  PokemonInfoPanelAbilityList.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/16/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import SwiftUI

extension PokemonInfoPanel {
    struct AbilityList: View {
        let model: PokemonViewModel
        let abilityModels: [AbilityViewModel]?
        
        var body: some View {
            VStack(alignment: .leading, spacing: 12) {
                Text("Skill")
                    .font(.headline)
                    .fontWeight(.bold)
                if abilityModels != nil {
                    ForEach(abilityModels!) { ability in
                        Text(ability.name)
                            .font(.subheadline)
                            .foregroundColor(model.color)
                        Text(ability.descriptionText)
                            .font(.footnote)
                            .foregroundColor(Color(hex: 0xAAAAAA))
                            .fixedSize(horizontal: false, vertical: false)
                            
                    }
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
