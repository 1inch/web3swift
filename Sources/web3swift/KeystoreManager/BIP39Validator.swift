//
//  BIP39Validator.swift
//  web3swift
//
//  Created by Andrew Podkovyrin on 13.08.2020.
//  Copyright © 2020 Matter Labs. All rights reserved.
//

import Foundation

public final class BIP39Validator {
    private let allWords: Set<String>
    
    public init() {
        let languages = BIP39Language.allCases
        allWords = Set(languages.map { $0.words }.flatMap { $0 })
    }
    
    public func isWordValid(_ word: String) -> Bool {
        allWords.contains(word)
    }
}
