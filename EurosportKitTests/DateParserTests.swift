//
//  DateParserTests.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 05/04/2017.
//  Copyright © 2017 Alexander Edge. All rights reserved.
//

import XCTest
@testable import EurosportKit

class DateParserTests: XCTestCase {

    var json: [String: Any]!

    override func setUp() {
        super.setUp()

        json = jsonFromBundle(fileName: "date")

    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testParsesDate() {

        let date = cetDate(year: 2017, month: 1, day: 26, hour: 21, minute: 30, second: 00)
        XCTAssertEqual(try! DateParser.parse(json), date)


    }

}
