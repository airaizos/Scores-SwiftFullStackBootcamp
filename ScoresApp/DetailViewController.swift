//
//  DetailViewController.swift
//  ScoresApp
//
//  Created by Adrian Iraizos Mendoza on 13/3/23.
//

import UIKit

final class DetailViewController: UITableViewController {
    let viewLogic = ViewLogic.shared
    let modelLogic = ModelLogic.shared
    var selectedScore:Score?
    
    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var composer: UITextField!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var length: UITextField!
    @IBOutlet weak var cover: UIImageView!
    
    //Mejor outlet en lugar de action. para poner el menu
    @IBOutlet weak var changeComposer: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titulo.text = selectedScore?.title
        composer.text = selectedScore?.composer
        year.text = selectedScore?.yearString
        length.text = selectedScore?.lengthString
        cover.image = UIImage(named: selectedScore?.cover ?? "")
        
        changeComposerButton()
    }
    
    //mejor en logica de vista
        //Cuáles son los compositores que hay en la lista
        func changeComposerButton() {
            var actions:[UIAction] = []
            for name in modelLogic.composers {
                let action = UIAction(title: name) { _ in
                    self.composer.text = name
                }
                actions.append(action)
            }
            changeComposer.menu = UIMenu(title: "Choose a composer", children: actions)
        }

    /*
    func newChangeComposerButton() {
        let actions = viewLogic.getMenuComposerActions(composerText: composer)
        changeComposer.menu = UIMenu(title:"Choose a composer", children: actions)
    }
     */
    
   
    @IBAction func saveScore(_ sender: UIBarButtonItem) {
        guard let selectedScore,
              let newTitle = titulo.text,
              let newComposer = composer.text,
              let newYearText = year.text,
              let newYearStr = Int(newYearText.clearNumber),
              let newLengthText = length.text,
              let newLengthDouble = Double(newLengthText)
              else { return }
        
        let newScore = Score(id: selectedScore.id, title: newTitle, composer: newComposer, year: newYearStr, length: newLengthDouble, cover: selectedScore.cover, tracks: selectedScore.tracks)
        
        modelLogic.updateScore(score: newScore)
        performSegue(withIdentifier: "saveBack", sender: nil)
    }
    
    @IBAction func changeCover(_ sender: UIButton) {
    }
    
}
