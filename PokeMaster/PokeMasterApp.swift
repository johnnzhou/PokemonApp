//
//  PokeMasterApp.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/14/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import SwiftUI

@main
struct PokeMasterApp: App {
    var body: some Scene {
        WindowGroup {
            MainTab().environmentObject(Store())
        }
    }
}
