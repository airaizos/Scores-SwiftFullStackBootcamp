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
