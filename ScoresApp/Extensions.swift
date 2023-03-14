//
//  Extensions.swift
//  ScoresApp
//
//  Created by Adrian Iraizos Mendoza on 14/3/23.
//

import Foundation

extension NumberFormatter {
    static let formateador: NumberFormatter = {
       let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale.current
        return nf
    }()
}


extension String {
    var clearNumber:String {
        let numbers:Set<Character> = Set("0123456789")
        return filter { numbers.contains($0) }
   //  CharacterSet.decimalDigits
    }
}
