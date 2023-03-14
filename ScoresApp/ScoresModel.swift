//
//  ScoresModel.swift
//  ScoresApp
//
//  Created by Adrian Iraizos Mendoza on 13/3/23.
//

import Foundation

struct Score:Hashable,Codable {
    let id:Int
    let title:String
    let composer:String
    let year:Int
    let length:Double
    let cover:String
    let tracks:[String]
    
}

extension Score {
    var yearString:String {
        "\(year.formatted(.number.precision(.integerLength(4))))"
    }
    
    var lengthString:String {
        "\(length.formatted(.number.precision(.integerAndFractionLength(integer: 2, fraction: 1))))"
    }
    
}
