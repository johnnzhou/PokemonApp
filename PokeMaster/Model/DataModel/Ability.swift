//
//  Ability.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/24/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import Foundation

struct Ability: Codable {
    struct Name: Codable, LanguageTextEntry {
        let language: Language
        let name: String

        var text: String { name }
    }

    struct FlavorTextEntry: Codable, LanguageTextEntry {
        let language: Language
        let flavorText: String

        var text: String { flavorText }
    }

    let id: Int

    let names: [Name]
    let flavorTextEntries: [FlavorTextEntry]
}
