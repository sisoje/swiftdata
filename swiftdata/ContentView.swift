//
//  ContentView.swift
//  swiftdata
//
//  Created by Lazar Otasevic on 13.11.23..
//

import SwiftUI

struct ContentView: View {
    @SwiftDataModel var model

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(model.items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func addItem() {
        withAnimation {
            try? model.addItem()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            try? model.deleteItems(offsets: offsets)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
