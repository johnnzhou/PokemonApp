//
//  ContentView.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/16/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        let contentView = MainTab().environmentObject(Store())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
