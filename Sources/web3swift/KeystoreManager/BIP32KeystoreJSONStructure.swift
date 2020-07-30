//  web3swift
//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation

public struct KeystoreParamsBIP32: Identifiable, Decodable, Encodable {
    public private(set) var id: String
    
    var crypto: CryptoParamsV3
    var version: Int = 32
    var isHDWallet: Bool
    var pathToAddress: [String:String]
    var rootPath: String?
    
    public init(crypto cr: CryptoParamsV3, id i: String, version ver: Int, rootPath: String? = nil) {
        crypto = cr
        id = i
        version = ver
        isHDWallet = true
        pathToAddress = [String:String]()
        self.rootPath = rootPath
    }
    
}
