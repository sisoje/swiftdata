//
//  swiftdataApp.swift
//  swiftdata
//
//  Created by Lazar Otasevic on 13.11.23..
//

import SwiftUI
import SwiftData

@main
struct swiftdataApp: App {
    var sharedModelContainer: ModelContainer = .makeModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
