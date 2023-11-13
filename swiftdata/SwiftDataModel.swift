//
//  SwiftDataModel.swift
//  swiftdata
//
//  Created by Lazar Otasevic on 13.11.23..
//

import ViewModelify
import SwiftData
import SwiftUI

@ViewModelify
@propertyWrapper struct SwiftDataModel: DynamicProperty {
    @Environment(\.modelContext) private var modelContext
    @Query var items: [Item]
    func addItem() throws {
        let newItem = Item(timestamp: Date())
        modelContext.insert(newItem)
        try modelContext.save()
    }
    func deleteItems(offsets: IndexSet) throws {
        for index in offsets {
            modelContext.delete(items[index])
        }
        try modelContext.save()
    }
}
