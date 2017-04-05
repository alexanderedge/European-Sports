//
//  TokenParserTests.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 05/04/2017.
//  Copyright © 2017 Alexander Edge. All rights reserved.
//

import XCTest
@testable import EurosportKit

class TokenTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.



    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testParsesToken() {

        let token = try! TokenParser.parse(jsonFromBundle(fileName: "token"))

        XCTAssertEqual(token.duration, 600)
        XCTAssertEqual(token.startDate, utcDate(year: 2017, month: 4, day: 5, hour: 11, minute: 47, second: 43))
        XCTAssertEqual(token.expiryDate, utcDate(year: 2017, month: 4, day: 5, hour: 11, minute: 58, second: 43))
        XCTAssertEqual(token.hdnts, "st=1491392863~exp=1491393523~acl=*~hmac=68620d1989d1266a7db78b6216326022bd8ce06feaff1b424d9f28529b349987")

    }

    func testIsNotExpired() {

        let start = Date()
        let end = Date(timeInterval: 600, since: start)
        let token = Token(token: "token", hdnts: "hdnts", startDate: start, expiryDate: end, duration: 600)

        XCTAssertFalse(token.isExpired)

    }

    func testIsExpired() {

        let start = Date(timeIntervalSinceNow: -601)
        let end = Date(timeInterval: 600, since: start)
        let token = Token(token: "token", hdnts: "hdnts", startDate: start, expiryDate: end, duration: 600)

        XCTAssertTrue(token.isExpired)
        
    }
    
}
