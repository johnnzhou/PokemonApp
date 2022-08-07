//
//  UserPreferences.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/25/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import Foundation

@propertyWrapper
struct UserPreferences<T> {
    
    let setter: (T) -> ()
    let getter: () -> (T)
    
    private init(setter: @escaping (T) -> (), getter: @escaping () -> T) {
        self.setter = setter
        self.getter = getter
    }
    
    var wrappedValue: T {
        set {
            setter(newValue)
        }
        get {
            getter()
        }
    }
}

extension UserPreferences {
    init(key: String, value: @escaping @autoclosure () -> T) {
        let getter: () -> T = {
            UserDefaults.standard.object(forKey: key) as? T ?? value()
        }
        
        let setter: (T) -> () = {newValue in
            #if DEBUG
            print("[NORMAL] write \(newValue) to replace \(value()) for [\(key)]")
            #endif
            UserDefaults.standard.set(newValue, forKey: key)
        }
        
        self.init(setter: setter, getter: getter)
    }
}

extension UserPreferences where T: RawRepresentable {
    
    init(key: String, value:@escaping @autoclosure () -> T) {
        let getter: () -> T = {
            (UserDefaults.standard.object(forKey: key) as? T.RawValue).flatMap {T.init(rawValue:$0)} ?? value()
        }
        
        let setter: (T) -> () = { newValue in
            #if DEBUG
            print("[RAWREPRESENTABLE] write \(newValue) to replace \(value()) for [\(key)]")
            #endif
            UserDefaults.standard.set(newValue.rawValue, forKey: key)
        }
        
        self.init(setter: setter, getter: getter)
    }
}
