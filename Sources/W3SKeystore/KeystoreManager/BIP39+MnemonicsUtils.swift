//
//  BIP39+PhraseUtils.swift
//  web3swift
//
//  Created by Andrew Podkovyrin on 13.08.2020.
//  Copyright © 2020 Matter Labs. All rights reserved.
//

import Foundation

public extension BIP39 {
    static func mnemonicToWords(_ mnemonic: String) -> [String] {
        let whitespaces = CharacterSet.whitespacesAndNewlines
        let invalidCharacters = CharacterSet.letters.union(whitespaces).inverted
        
        let trimmed = mnemonic.trimmingCharacters(in: whitespaces)
        let filtered = String(String.UnicodeScalarView(trimmed.unicodeScalars.filter { !invalidCharacters.contains($0) }))
        let words = filtered.components(separatedBy: whitespaces).filter { !$0.isEmpty }
        return words
    }
    
    static func wordsToMnemonic(_ words: [String]) -> String {
        let language = languageOf(words: words) ?? .english
        let joined = words.joined(separator: language.separator)
        return joined
    }
    
    static func isMnemonicWordsValid(_ words: [String]) -> Bool {
        languageOf(words: words) != nil
    }
    
    static func isMnemonicWordsValid(_ words: [String], for language: BIP39Language) -> Bool {
        mnemonicsToEntropy(words, language: language) != nil
    }
    
    static func languageOf(words: [String]) -> BIP39Language? {
        let languages = BIP39Language.allCases
        for language in languages {
            if isMnemonicWordsValid(words, for: language) {
                return language
            }
        }
        return nil
    }
}
