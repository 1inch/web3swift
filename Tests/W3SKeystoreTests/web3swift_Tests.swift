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
    
    func testECRecover() throws {
        let signature = "0x5532e2d3a043cae3dd7827c528981642e64e104021bbb77b7b6bbc77d329354c01b8ea05b16f17f5971b230bd61aa0085ebe61edf1c53930c917dc6fbf11383f1c"
        let message = "0x4920616d206e6f742074686520706572736f6e206f7220656e7469746965732077686f2072657369646520696e2c2061726520636974697a656e73206f662c2061726520696e636f72706f726174656420696e2c206f72206861766520612072656769737465726564206f666669636520696e2074686520556e6974656420537461746573206f6620416d6572696361206f7220616e792050726f68696269746564204c6f63616c69746965732c20617320646566696e656420696e20746865205465726d73206f66205573652e0a492077696c6c206e6f7420696e20746865206675747572652061636365737320746869732073697465206f72207573652031696e63682064417070207768696c65206c6f63617465642077697468696e2074686520556e697465642053746174657320616e792050726f68696269746564204c6f63616c69746965732c20617320646566696e656420696e20746865205465726d73206f66205573652e0a4920616d206e6f74207573696e672c20616e642077696c6c206e6f7420696e2074686520667574757265207573652c20612056504e20746f206d61736b206d7920706879736963616c206c6f636174696f6e2066726f6d20612072657374726963746564207465727269746f72792e0a4920616d206c617766756c6c79207065726d697474656420746f206163636573732074686973207369746520616e64207573652031696e6368206441707020756e64657220746865206c617773206f6620746865206a7572697364696374696f6e206f6e20776869636820492072657369646520616e6420616d206c6f63617465642e0a4920756e6465727374616e6420746865207269736b73206173736f636961746564207769746820656e746572696e6720696e746f207573696e672031696e6368204e6574776f726b2070726f746f636f6c732e"
        
        let signatureData = Data(hex: signature)
        let messageData = Data(hex: message)
                
        let address = try XCTUnwrap(Utils.ecRecover(signature: signatureData, message: messageData))
        let addressString = address.hex(eip55: true)
        XCTAssertEqual(addressString, "0x1d23118D0Dd260547610b5326C2E62bE7F5f6fAa")
    }
    
    func testDerivationPathSplit() throws {
        let pathes1 = "m/44'/60'/0'/0/5".splitParentPath(depth: 3)
        XCTAssertNotNil(pathes1)
        XCTAssertEqual(pathes1!.0, "m/44'/60'/0'")
        XCTAssertEqual(pathes1!.1, "0/5")
        
        let pathes2 = "m/44'/60'/0'/0/5".splitParentPath(depth: 8)
        XCTAssertNil(pathes2)
    }
}

