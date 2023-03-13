//
//  DetailViewController.swift
//  ScoresApp
//
//  Created by Adrian Iraizos Mendoza on 13/3/23.
//

import UIKit

final class DetailViewController: UITableViewController {
    
    var selectedScore:Score?
    
  
    @IBOutlet weak var scoreTitle: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreTitle.text = selectedScore?.title
    }
}
