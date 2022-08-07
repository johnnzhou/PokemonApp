//
//  User.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/22/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import Foundation

struct User: Codable {
    var email: String
    var favoritePokemonIDs: Set<Int>
    func isFavoritePokemon(id: Int) -> Bool {
        return favoritePokemonIDs.contains(id)
    }
}
