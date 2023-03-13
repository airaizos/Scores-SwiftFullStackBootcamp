//
//  ModelPersistence.swift
//  ScoresApp
//
//  Created by Adrian Iraizos Mendoza on 13/3/23.
//

import Foundation

final class ModelPersistence {
    // Agrupar todas las funcionalidades del modelo de persistencia,
    //Sirve para TDD para datos de prueba y datos reales.
    //Reales en shared y ficticios en otra instancia
    
    //En este caso  no le sacaremos toda la funcionalidad al singletone Shared
    
    static let shared = ModelPersistence()
    
    
    //De donde se carga la información
    let scoresBundleURL = Bundle.main.url(forResource: "scoresdata", withExtension: "json")!
    let scoresDocuments = URL.documentsDirectory.appending(path: "scoresdata.json")
    
    
    
    //Con throws los errores van hacia afuera, hacia a la pantalla
    func getScores() throws -> [Score] {
        let data = try Data(contentsOf: scoresBundleURL)
        return try JSONDecoder().decode([Score].self, from: data)
    }
    
    func saveScores(scores:[Score]) throws {
        let data = try JSONEncoder().encode(scores)
        try data.write(to:scoresDocuments, options: .atomic)
    }
}
