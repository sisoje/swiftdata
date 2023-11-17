//
//  swiftdataTests.swift
//  swiftdataTests
//
//  Created by Lazar Otasevic on 13.11.23..
//

import SwiftData
@testable import swiftdata
import SwiftUI
import ViewInspector
import ViewModelify
import XCTest
import Combine

extension Inspection: InspectionEmissary { }

@MainActor final class swiftdataTests: XCTestCase {
    let modelContainer: ModelContainer = .makeModel()

    func testSwiftData() throws {
        var model = SwiftDataModel()
        let exp = model.on(\.didAppear) { view in
            let model = try view.actualView()
            XCTAssertEqual(model.items.count, 0)
            model.addItem()
            XCTAssertEqual(model.items.count, 1)
            model.deleteItems(offsets: .init(integer: 0))
            XCTAssertEqual(model.items.count, 0)
        }
        ViewHosting.host(
            view: model.environment(\.modelContext, modelContainer.mainContext)
        )
        wait(for: [exp], timeout: 1)
    }
}
