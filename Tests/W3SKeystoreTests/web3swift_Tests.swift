//  web3swift
//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//


import XCTest
import CryptoSwift
import BigInt
import Web3

@testable import W3SKeystore

class web3swift_Tests: XCTestCase {
    
    func testBitFunctions () {
        let data = Data([0xf0, 0x02, 0x03])
        let firstBit = data.bitsInRange(0,1)
        XCTAssert(firstBit == 1)
        let first4bits = data.bitsInRange(0,4)
        XCTAssert(first4bits == 0x0f)
    }
}

