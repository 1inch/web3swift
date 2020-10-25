//
//  Utils.swift
//  
//
//  Created by Andrew Podkovyrin on 24.10.2020.
//

import Foundation
import Web3

enum Utils {
    /// Convert the private key (32 bytes of Data) to compressed (33 bytes) or non-compressed (65 bytes) public key.
    static func privateToPublic(_ privateKey: Data, compressed: Bool = false) -> Data? {
        guard let publicKey = SECP256K1.privateToPublic(privateKey:  privateKey, compressed: compressed) else {return nil}
        return publicKey
    }
    
    /// Convert a public key to the corresponding EthereumAddress. Accepts public keys in compressed (33 bytes), non-compressed (65 bytes)
    /// or raw concat(X,Y) (64 bytes) format.
    ///
    /// Returns the EthereumAddress object.
    static func publicToAddress(_ publicKey: Data) -> EthereumAddress? {
        var resultPublicKey = publicKey
        if publicKey.count == 33 {
            guard let decompressedKey = SECP256K1.combineSerializedPublicKeys(keys: [publicKey], outputCompressed: false) else {
                return nil
            }
            resultPublicKey = decompressedKey
        }
        guard let pk = try? EthereumPublicKey(resultPublicKey) else {
            return nil
        }
        return pk.address
    }
}
