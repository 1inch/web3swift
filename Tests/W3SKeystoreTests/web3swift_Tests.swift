//  web3swift
//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//


import XCTest
import CryptoSwift
import BigInt

@testable import W3SKeystore

class web3swift_Tests: XCTestCase {
    
    func testBitFunctions () {
        let data = Data([0xf0, 0x02, 0x03])
        let firstBit = data.bitsInRange(0,1)
        XCTAssert(firstBit == 1)
        let first4bits = data.bitsInRange(0,4)
        XCTAssert(first4bits == 0x0f)
    }
    
    func testCombiningPublicKeys() {
        let priv1 = Data(repeating: 0x01, count: 32)
        let pub1 = Utils.privateToPublic(priv1, compressed: true)!
        let priv2 = Data(repeating: 0x02, count: 32)
        let pub2 = Utils.privateToPublic(priv2, compressed: true)!
        let combined = SECP256K1.combineSerializedPublicKeys(keys: [pub1, pub2], outputCompressed: true)
        let compinedPriv = Data(repeating: 0x03, count: 32)
        let compinedPub = Utils.privateToPublic(compinedPriv, compressed: true)
        XCTAssert(compinedPub == combined)
    }
    
    func testBigUIntFromHex() {
        let hexRepresentation = "0x1c31de57e49fc00".stripHexPrefix()
        let biguint = BigUInt(hexRepresentation, radix: 16)!
        XCTAssert(biguint == BigUInt("126978086000000000"))
    }
    
    func testMakePrivateKey() {
        let privKey = SECP256K1.generatePrivateKey()
        XCTAssert(privKey != nil, "Failed to create new private key")
    }
}

