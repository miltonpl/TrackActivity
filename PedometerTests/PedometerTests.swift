//
//  PedometerTests.swift
//  PedometerTests
//
//  Created by Milton Palaguachi on 2/20/21.
//

import XCTest
@testable import TrackActivity
class PedometerTests: XCTestCase {
    var pedometor: PedometerHandler?

    override func setUpWithError() throws {
        try super.setUpWithError()
        self.pedometor = PedometerHandler()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        self.pedometor = nil
    }

    func testExample() throws {
    }
}
