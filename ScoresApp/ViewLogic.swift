//
//  ViewLogic.swift
//  ScoresApp
//
//  Created by Adrian Iraizos Mendoza on 14/3/23.
//

import UIKit

final class ViewLogic {
    static let shared = ViewLogic()
    
    let modelLogic = ModelLogic.shared
    
    func cellForRowAt(indexPath: IndexPath) -> UIListContentConfiguration {

        let score = modelLogic.getScoreRow(indexPath: indexPath)
        
        var content = UIListContentConfiguration.cell()
        content.text = score.title
        content.secondaryText = score.composer
        content.image = UIImage(named: score.cover)
        content.imageProperties.cornerRadius = 20
        
       return content
        
    }
    
    func getScoreForSegue(tableView:UITableView, sender:Any?) ->Score? {
        guard let cell = sender as? UITableViewCell,
              let cellIndexPath = tableView.indexPath(for: cell) else { return nil }
        return modelLogic.getScoreRow(indexPath: cellIndexPath)
    }
    
    /*
    //Cuáles son los compositores que hay en la lista
    func getMenuComposerActions(composerText: UITextField) {
        var actions:[UIAction] = []
        for name in modelLogic.composers {
            let action = UIAction(title: name) { _ in
                self.composer.text = name
            }
            actions.append(action)
        }
     
    }
     */
    
    
}
