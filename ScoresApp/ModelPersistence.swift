//
//  ModelPersistence.swift
//  ScoresApp
//
//  Created by Adrian Iraizos Mendoza on 13/3/23.
//

import UIKit

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
        
        if FileManager.default.fileExists(atPath: scoresDocuments.path()) {
            let data = try Data(contentsOf: scoresDocuments)
            return try JSONDecoder().decode([Score].self, from: data)
        } else {
            let data = try Data(contentsOf: scoresBundleURL)
            return try JSONDecoder().decode([Score].self, from: data)
        }
    }
        
        func saveScores(scores:[Score]) throws {
            //       let encoder = JSONEncoder()
            //     encoder.outputFormatting = .prettyPrinted Ocupa más espacio
            let data = try JSONEncoder().encode(scores)
            try data.write(to:scoresDocuments, options: .atomic)
        }
    
    
    func saveImage(id:Int, image:UIImage) throws {
        let urlImage = URL.documentsDirectory.appending(path: "\(id)_cover.jpg")
        if let data = image.jpegData(compressionQuality: 0.7) {
            try data.write(to: urlImage, options: .atomic)
        }
    }
    
    func loadImage(id:Int) throws -> UIImage? {
        let urlImage = URL.documentsDirectory.appending(path: "\(id)_cover.jpg")
        if FileManager.default.fileExists(atPath: urlImage.path()) {
            let data = try Data(contentsOf: urlImage)
            return UIImage(data: data)
        } else {
            return nil
        }
    }
}
