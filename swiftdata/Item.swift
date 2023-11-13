//
//  Item.swift
//  swiftdata
//
//  Created by Lazar Otasevic on 13.11.23..
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
