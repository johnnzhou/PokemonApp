//
//  SettingRootView.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/17/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import SwiftUI

struct SettingRootView: View {
    var body: some View {
        NavigationView {
            SettingView().navigationTitle("Settings").navigationBarTitleDisplayMode(.large)
        }
    }
}

struct SettingRootView_Previews: PreviewProvider {
    static var previews: some View {
        SettingRootView()
    }
}
