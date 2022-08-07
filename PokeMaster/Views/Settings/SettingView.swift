//
//  SettingView.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/16/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import Foundation
import SwiftUI

struct SettingView: View {
//    @ObservedObject var settings = Settings()
    @EnvironmentObject var store: Store
    var settings: AppState.Settings {
        store.appState.settings
    }
    
    var settingsBinding: Binding<AppState.Settings> {
        $store.appState.settings
    }
    
    var accountSection: some View {
        Section() {
            if settings.loginUser == nil {
                Picker(selection: settingsBinding.checker.accountBehavior, label: Text("")) {
                    ForEach(AppState.Settings.AccountBehavior.allCases, id: \.self) {
                        Text($0.text)
                    }
                }.pickerStyle(.segmented)
                TextField("Email", text: settingsBinding.checker.email)
                    .foregroundColor(settings.isEmailValid ? .green : .red)
                SecureField("Password", text: settingsBinding.checker.password)
                if settings.checker.accountBehavior == .register {
                    SecureField("Confirm Password", text: settingsBinding.checker.verifyPassword)
                }
                
                if settings.loginRequesting {
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                } else {
                    Button(settings.checker.accountBehavior.text) {
                        switch settings.checker.accountBehavior {
                        case .login:
                            store.dispatch(.login(email: settings.checker.email, password: settings.checker.password))
                        case .register:
                            store.dispatch(.register(email: settings.checker.email, password: settings.checker.password))
                        }
                    
                    }
                    .disabled(!settings.canRegister)
                }
            } else {
                Text(settings.loginUser!.email)
                Button("Logout") {
                    store.dispatch(.logout)
                }
            }
        }
    }
    
    var optionSection: some View {
        Section(header: Text("Options")) {
            Toggle("Show English Names", isOn: settingsBinding.showEnglishName)
            Picker(selection: settingsBinding.sorting, label: Text("Sort By")) {
                ForEach(AppState.Settings.Sorting.allCases, id: \.self) {
                    Text($0.text)
                }
            }
            Toggle(isOn: settingsBinding.showFavoriteOnly) {
                Text("Show Favorite Only")
            }
        }
    }
    
    var actionSection: some View {
        Section {
            Button("Clear Cache", role: .destructive) {
                self.store.dispatch(.clearCache)
            }
        }
    }
    
    var body: some View {
        Form {
            accountSection
            optionSection
            actionSection
        }
        .alert(item: settingsBinding.loginError) { error in
            Alert(title: Text("Error"), message: Text(error.localizedDescription))
        }
    }
}

extension AppState.Settings.Sorting {
    var text: String {
        switch self {
        case .id: return "ID"
        case .name: return "Name"
        case .color: return "Color"
        case .favorite: return "Favorite"
        }
    }
}

extension AppState.Settings.AccountBehavior {
    var text: String {
        switch self {
            
        case .register:
            return "Register"
        case .login:
            return "Login"
        }
    }
}


struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        let store = Store()
        store.appState.settings.sorting = .color
        return SettingView().environmentObject(store)
    }
}
