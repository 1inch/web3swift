//
//  web3swift_BIP39_Tests.swift
//  Tests
//
//  Created by Andrew Podkovyrin on 13.08.2020.
//  Copyright © 2020 Matter Labs. All rights reserved.
//

import XCTest

@testable import W3SKeystore

class web3swift_BIP39_Tests: XCTestCase {
    func testValidation1() throws {
        let mnemonic = "123 %^&* fruit wave dwarf ba(*%#^%nana earth journey\ntattoo true farm silk olive fence\n $%^& \n"
        
        let words = BIP39.mnemonicToWords(mnemonic)
        XCTAssert(BIP39.isMnemonicWordsValid(words))
        XCTAssert(BIP39.languageOf(words: words)! == .english)
    }

    func testWordsValidator() throws {
        let validator = BIP39Validator()
        
        XCTAssert(validator.isWordValid("wave"))
        XCTAssert(validator.isWordValid("はけん"))
        
        XCTAssertFalse(validator.isWordValid("zombie"))
        XCTAssertFalse(validator.isWordValid("みつ"))
    }
    
    func testWordsJoining() throws {
        let mnemonic = "てほどき　たたく　きおう　むのう　はけん　ひみつ　ていど　こくとう　へいわ　ろこつ　なおす　せんせい" // used ideomatic spaces
        let words = BIP39.mnemonicToWords(mnemonic)
        XCTAssert(BIP39.isMnemonicWordsValid(words))
        XCTAssert(BIP39.languageOf(words: words)! == .japanese)
        
        let joined = BIP39.wordsToMnemonic(words)
        XCTAssert(joined == mnemonic)
    }

    func testWordsCount() throws {
        let englishWords = BIP39Language.english.words
        let simplifiedchineseWords = BIP39Language.chinese_simplified.words
        let traditionalchineseWords = BIP39Language.chinese_traditional.words
        let japaneseWords = BIP39Language.japanese.words
        let koreanWords = BIP39Language.korean.words
        let frenchWords = BIP39Language.french.words
        let italianWords = BIP39Language.italian.words
        let spanishWords = BIP39Language.spanish.words

        let allWords = [
            englishWords,
            simplifiedchineseWords,
            traditionalchineseWords,
            japaneseWords,
            koreanWords,
            frenchWords,
            italianWords,
            spanishWords,
        ]

        let count = englishWords.count
        XCTAssertEqual(count, 2048)

        for wordsList in allWords {
            XCTAssertEqual(count, wordsList.count)
        }
    }
}




