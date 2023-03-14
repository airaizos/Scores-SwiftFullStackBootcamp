//
//  ModelLogic.swift
//  ScoresApp
//
//  Created by Adrian Iraizos Mendoza on 13/3/23.
//

import Foundation

//Se van a compartir en las pantallas asi que es un patrón Singleton. Funciona cuando los datos son compartidos
final class ModelLogic {
    static let shared = ModelLogic()
    
    let persistance = ModelPersistence.shared
    
    var scores: [Score]
    var composers:[String] {
        Array(Set(scores.map(\.composer))).sorted()
    }
    
    
    init() {
        //control de los errores
        do {
            self.scores = try persistance.getScores()
           
        } catch {
            self.scores = []
        }
       
    }
    
    //Al enviar esta función, podría cambiar scores y solo lo tendría que cambiar aqui.
    func getRows() -> Int {
        scores.count
    }
    
    func getScoreRow(indexPath: IndexPath) -> Score {
        scores[indexPath.row]
    }
    
    func deleteScore(indexPath: IndexPath) {
        scores.remove(at: indexPath.row)
    }
    
    //Hay que tener cuidado con los cambios de seccion
    func moveScore(indexPath: IndexPath, to: IndexPath) {
        scores.swapAt(indexPath.row, to.row)
        
      //  let index = IndexSet(integer: <#T##IndexSet.Element#>)
        //scores.mode(fromOffsets: index, toOffset: to.row)
        
    }
    
    func updateScore(score: Score) {
        if let index = scores.firstIndex(where: { $0.id == score.id }) {
            scores[index] = score
        }
        
    }
    
    //indice de un score
    
    func indexScore(score:Score) -> Int? {
        scores.firstIndex(where: { $0.id == score.id }) 
    }
}
