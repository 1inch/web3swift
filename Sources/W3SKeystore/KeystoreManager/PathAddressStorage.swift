//
//  PathAddressStorage.swift
//  web3swift
//
//  Created by Andrew Podkovyrin on 08.08.2020.
//  Copyright © 2020 Matter Labs. All rights reserved.
//

import Foundation
import Web3

public struct PathAddressStorage {
    private(set) var addresses: [EthereumAddress]
    private(set) var paths: [String]
    
    init() {
        addresses = []
        paths = []
    }
    
    mutating func add(address: EthereumAddress, for path: String) {
        addresses.append(address)
        paths.append(path)
    }
    
    func path(by address: EthereumAddress) -> String? {
        guard let index = addresses.firstIndex(of: address) else { return nil }
        return paths[index]
    }
}

extension PathAddressStorage {
    init(pathAddressPairs: [PathAddressPair]) {
        var addresses = [EthereumAddress]()
        var paths = [String]()
        for pair in pathAddressPairs {
            guard let address = try? EthereumAddress(hex: pair.address, eip55: false) else { continue }
            addresses.append(address)
            paths.append(pair.path)
        }
        
        assert(addresses.count == paths.count)
        
        self.addresses = addresses
        self.paths = paths
    }
    
    func toPathAddressPairs() -> [PathAddressPair] {
        var pathAddressPairs = [PathAddressPair]()
        for (index, path) in paths.enumerated() {
            let address = addresses[index]
            let pair = PathAddressPair(path: path, address: address.hex(eip55: true))
            pathAddressPairs.append(pair)
        }
        return pathAddressPairs
    }
}
