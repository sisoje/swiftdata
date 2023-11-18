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
import XCTest
import Combine

@MainActor final class swiftdataTests: XCTestCase {
    let modelContainer: ModelContainer = .makeModel()
    
    func testSwiftDataWithCombine() throws {
        let model = SwiftDataModel()
        let exp = model.inspection.inspect { view in
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

    func testSwiftDataWithAppear() throws {
        var model = SwiftDataModel()
        let exp = model.on(\.inspection.didAppear) { view in
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
