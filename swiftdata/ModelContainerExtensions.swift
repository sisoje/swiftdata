//
//  ModelContainerExtensions.swift
//  swiftdata
//
//  Created by Lazar Otasevic on 13.11.23..
//

import SwiftData

extension ModelContainer {
    static func makeModel() -> ModelContainer {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }
}
