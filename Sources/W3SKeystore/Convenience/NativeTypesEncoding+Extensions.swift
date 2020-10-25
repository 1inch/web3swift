//  web3swift
//
//  Created by Alex Vlasov.
//  Copyright © 2018 Alex Vlasov. All rights reserved.
//

import Foundation
import BigInt

extension Data {
    func setLengthLeft(_ toBytes: UInt64, isNegative:Bool = false ) -> Data? {
        let existingLength: UInt64 = UInt64(self.count)
        if (existingLength == toBytes) {
            return self
        } else if (existingLength > toBytes) {
            return nil
        }
        var data:Data
        if (isNegative) {
            data = Data(repeating: UInt8(255), count: Int(toBytes - existingLength))
        } else {
            data = Data(repeating: UInt8(0), count: Int(toBytes - existingLength))
        }
        data.append(self)
        return data
    }
    
    func setLengthRight(_ toBytes: UInt64, isNegative:Bool = false ) -> Data? {
        let existingLength = UInt64(self.count)
        if (existingLength == toBytes) {
            return self
        } else if (existingLength > toBytes) {
            return nil
        }
        var data:Data = Data()
        data.append(self)
        if (isNegative) {
            data.append(Data(repeating: UInt8(255), count: Int(toBytes - existingLength)))
        } else {
            data.append(Data(repeating: UInt8(0), count:Int(toBytes - existingLength)))
        }
        return data
    }
}
