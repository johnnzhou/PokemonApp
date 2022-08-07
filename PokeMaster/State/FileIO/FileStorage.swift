//
//  FileStorage.swift
//  PokeMaster
//
//  Created by Zhennan Zhou on 2/24/22.
//  Copyright © 2022 Zhennan Zhou. All rights reserved.
//

import Foundation

@propertyWrapper
struct FileStorage<T: Codable> {
    var value: T?
    
    let directory: FileManager.SearchPathDirectory
    let fileName: String

    init(directory: FileManager.SearchPathDirectory, fileName: String) {
        value = try? FileHelper.loadJSON(from: directory, fileName: fileName)
        self.directory = directory
        self.fileName = fileName
    }
    
    var wrappedValue: T? {
        set {
            value = newValue
            if let value = newValue {
                try? FileHelper.writeJSON(value, to: directory, fileName: fileName)
                #if DEBUG
                print("write \(fileName) to \(directory)")
                #endif
            } else {
                try? FileHelper.delete(from: directory, fileName: fileName)
                #if DEBUG
                print("delete \(fileName) to \(directory)")
                #endif
            }
        }
        
        get {
            value
        }
    }
}
