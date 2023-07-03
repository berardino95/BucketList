//
//  FileManager-DocumentsDirectory.swift
//  BucketList
//
//  Created by Berardino Chiarello on 29/06/23.
//

import Foundation

extension FileManager {
    static var documentsDirectory: URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
