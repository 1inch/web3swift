//
//  secp256k1.swift
//  secp256k1_swift
//
//  Created by Alexander Vlasov on 30.05.2018.
//  Copyright © 2018 Alexander Vlasov. All rights reserved.
//

import Foundation
import secp256k1

enum SECP256K1 {
    static let context = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN|SECP256K1_CONTEXT_VERIFY))
    
    public static func privateToPublic(privateKey: Data, compressed: Bool = false) -> Data? {
        if (privateKey.count != 32) {return nil}
        guard var publicKey = SECP256K1.privateKeyToPublicKey(privateKey: privateKey) else {return nil}
        guard let serializedKey = serializePublicKey(publicKey: &publicKey, compressed: compressed) else {return nil}
        return serializedKey
    }
    
    public static func combineSerializedPublicKeys(keys: [Data], outputCompressed: Bool = false) -> Data? {
        let numToCombine = keys.count
        guard numToCombine >= 1 else { return nil}
        var storage = ContiguousArray<secp256k1_pubkey>()
        let arrayOfPointers = UnsafeMutablePointer< UnsafePointer<secp256k1_pubkey>? >.allocate(capacity: numToCombine)
        defer {
            arrayOfPointers.deinitialize(count: numToCombine)
            arrayOfPointers.deallocate()
        }
        for i in 0 ..< numToCombine {
            let key = keys[i]
            guard let pubkey = SECP256K1.parsePublicKey(serializedKey: key) else {return nil}
            storage.append(pubkey)
        }
        for i in 0 ..< numToCombine {
            withUnsafePointer(to: &storage[i]) { (ptr) -> Void in
                arrayOfPointers.advanced(by: i).pointee = ptr
            }
        }
        let immutablePointer = UnsafePointer(arrayOfPointers)
        var publicKey: secp256k1_pubkey = secp256k1_pubkey()
        let result = withUnsafeMutablePointer(to: &publicKey) { (pubKeyPtr: UnsafeMutablePointer<secp256k1_pubkey>) -> Int32 in
            let res = secp256k1_ec_pubkey_combine(context!, pubKeyPtr, immutablePointer, numToCombine)
            return res
        }
        if result == 0 {
            return nil
        }
        let serializedKey = SECP256K1.serializePublicKey(publicKey: &publicKey, compressed: outputCompressed)
        return serializedKey
    }
        
    internal static func privateKeyToPublicKey(privateKey: Data) -> secp256k1_pubkey? {
        if (privateKey.count != 32) {return nil}
        var publicKey = secp256k1_pubkey()
        let result = privateKey.withUnsafeBytes { (pkRawBufferPointer: UnsafeRawBufferPointer) -> Int32? in
            if let pkRawPointer = pkRawBufferPointer.baseAddress, pkRawBufferPointer.count > 0 {
                let privateKeyPointer = pkRawPointer.assumingMemoryBound(to: UInt8.self)
                let res = withUnsafeMutablePointer(to: &publicKey) {
                    secp256k1_ec_pubkey_create(context!, $0, privateKeyPointer)
                }
                return res
            } else {
                return nil
            }
        }
        guard let res = result, res != 0 else {
            return nil
        }
        return publicKey
    }
    
    public static func serializePublicKey(publicKey: inout secp256k1_pubkey, compressed: Bool = false) -> Data? {
        var keyLength = compressed ? 33 : 65
        var serializedPubkey = Data(repeating: 0x00, count: keyLength)
        let result = serializedPubkey.withUnsafeMutableBytes { (serializedPubkeyRawBuffPointer) -> Int32? in
            if let serializedPkRawPointer = serializedPubkeyRawBuffPointer.baseAddress, serializedPubkeyRawBuffPointer.count > 0 {
                let serializedPubkeyPointer = serializedPkRawPointer.assumingMemoryBound(to: UInt8.self)
                return withUnsafeMutablePointer(to: &keyLength, { (keyPtr:UnsafeMutablePointer<Int>) -> Int32 in
                    withUnsafeMutablePointer(to: &publicKey, { (pubKeyPtr:UnsafeMutablePointer<secp256k1_pubkey>) -> Int32 in
                        let res = secp256k1_ec_pubkey_serialize(context!,
                                                                serializedPubkeyPointer,
                                                                keyPtr,
                                                                pubKeyPtr,
                                                                UInt32(compressed ? SECP256K1_EC_COMPRESSED : SECP256K1_EC_UNCOMPRESSED))
                        return res
                    })
                })
            } else {
                return nil
            }
        }
        guard let res = result, res != 0 else {
            return nil
        }
        return serializedPubkey
    }
    
    internal static func parsePublicKey(serializedKey: Data) -> secp256k1_pubkey? {
        guard serializedKey.count == 33 || serializedKey.count == 65 else {
            return nil
        }
        let keyLen: Int = Int(serializedKey.count)
        var publicKey = secp256k1_pubkey()
        let result = serializedKey.withUnsafeBytes { (serializedKeyRawBufferPointer: UnsafeRawBufferPointer) -> Int32? in
            if let serializedKeyRawPointer = serializedKeyRawBufferPointer.baseAddress, serializedKeyRawBufferPointer.count > 0 {
                let serializedKeyPointer = serializedKeyRawPointer.assumingMemoryBound(to: UInt8.self)
                let res = withUnsafeMutablePointer(to: &publicKey) {
                    secp256k1_ec_pubkey_parse(context!, $0, serializedKeyPointer, keyLen)
                }
                return res
            } else {
                return nil
            }
        }
        guard let res = result, res != 0 else {
            return nil
        }
        return publicKey
    }
    
    public static func verifyPrivateKey(privateKey: Data) -> Bool {
        if (privateKey.count != 32) {return false}
        let result = privateKey.withUnsafeBytes { (privateKeyRBPointer) -> Int32? in
            if let privateKeyRPointer = privateKeyRBPointer.baseAddress, privateKeyRBPointer.count > 0 {
                let privateKeyPointer = privateKeyRPointer.assumingMemoryBound(to: UInt8.self)
                let res = secp256k1_ec_seckey_verify(context!, privateKeyPointer)
                return res
            } else {
                return nil
            }
        }
        guard let res = result, res == 1 else {
            return false
        }
        return true
    }
    
    public static func generatePrivateKey() -> Data? {
        for _ in 0...1024 {
            guard let keyData = SECP256K1.randomBytes(length: 32) else {
                continue
            }
            guard SECP256K1.verifyPrivateKey(privateKey: keyData) else {
                continue
            }
            return keyData
        }
        return nil
    }
    
    internal static func randomBytes(length: Int) -> Data? {
        for _ in 0...1024 {
            var data = Data(repeating: 0, count: length)
            let result = data.withUnsafeMutableBytes { (mutableRBBytes) -> Int32? in
                if let mutableRBytes = mutableRBBytes.baseAddress, mutableRBBytes.count > 0 {
                    let mutableBytes = mutableRBytes.assumingMemoryBound(to: UInt8.self)
                    return SecRandomCopyBytes(kSecRandomDefault, 32, mutableBytes)
                } else {
                    return nil
                }
            }
            if let res = result, res == errSecSuccess {
                return data
            } else {
                continue
            }
        }
        return nil
    }
    
    /// Recover a public key from a message.
    /// - Parameter message: 32-byte message that was signed.
    /// - Parameter signature: 64-byte signature.
    /// - Returns: 33-byte compressed public key.
    public static func recover(message: Data, signature: Data) -> Data? {
        if signature.count < 65 {
            // Invalid signature
            return nil
        }
        
        let sig = UnsafeMutablePointer<secp256k1_ecdsa_recoverable_signature>.allocate(capacity: 1)
        defer { sig.deallocate() }
        
        var recid = Int32(signature[64]) // v
        if recid >= 27 {
            recid -= 27
        }
        
        let parseSuccess = signature.withUnsafeBytes { (signatureBytes) -> Bool in
            if let _bytes = signatureBytes.baseAddress, signatureBytes.count > 0 {
                let bytes = _bytes.assumingMemoryBound(to: UInt8.self)
                
                return secp256k1_ecdsa_recoverable_signature_parse_compact(context!, sig, bytes, recid) == 1
            }
            return false
        }
        
        guard parseSuccess else {
            return nil
        }
        
        let pubkey = UnsafeMutablePointer<secp256k1_pubkey>.allocate(capacity: 1)
        defer { pubkey.deallocate() }
        
        let recoverSuccess = message.withUnsafeBytes { (messageBytes) -> Bool in
            if let _bytes = messageBytes.baseAddress, messageBytes.count > 0 {
                let bytes = _bytes.assumingMemoryBound(to: UInt8.self)
                return secp256k1_ecdsa_recover(context!, pubkey, sig, bytes) == 1
            }
            return false
        }
        
        guard recoverSuccess else {
            return nil
        }
        return serializePublicKey(publicKey: &pubkey.pointee, compressed: true)
    }
    
    internal static func constantTimeComparison(_ lhs: Data, _ rhs:Data) -> Bool {
        guard lhs.count == rhs.count else {return false}
        var difference = UInt8(0x00)
        for i in 0..<lhs.count { // compare full length
            difference |= lhs[i] ^ rhs[i] //constant time
        }
        return difference == UInt8(0x00)
    }
}
