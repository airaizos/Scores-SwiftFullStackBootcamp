//
//  ScoresTableViewController.swift
//  ScoresApp
//
//  Created by Adrian Iraizos Mendoza on 13/3/23.
//

import UIKit

final class ScoresTableViewController: UITableViewController {

    //Enganchamos la logica del modelo
    let modelLogic = ModelLogic.shared
    let viewLogic = ViewLogic.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
         self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }
    
    //Delegados. Sobrecargas de la misma función.
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows
        //No se pone modelLogic.scores.count, porque es de logica
        
        //Las partes no deben saber como se resuelve algo, por si hay que cambiar la estructura.
        modelLogic.getRows()
        
        
    }

    //Index path es un dato combinado de sección y fila.
    //Desencola una celda para pintarla de nuevo.
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "zelda", for: indexPath)
        let score = modelLogic.getScoreRow(indexPath: indexPath)
        
        var content = UIListContentConfiguration.cell()
        content.text = score.title
        content.secondaryText = score.composer
        content.image = UIImage(named: score.cover)
        content.imageProperties.cornerRadius = 20
        
       
        cell.contentConfiguration = content
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        
        //Marcar que las celdas editables. Verdadero  Falso
    
       true
    }
    

    
    //Tipos de edición
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            modelLogic.deleteScore(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .left)
            
       // } else if editingStyle == .insert {
            //Solo cuando quiero hacer una inserción de valor en la que voy a controlar manualmente todo.  Asi que NO se hace. Se hace en una tabla a parte.
            //Si queremos añadir más datos
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    //Rearreglo de la tabla
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        modelLogic.moveScore(indexPath: fromIndexPath, to: to)
    }
    

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    ///**Sender es quien ha pulsado la celda
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        //Se ejecuta cada vez que se invoca un segue en la pantalla.
        
        guard segue.identifier == "detalle",
              let detail = segue.destination as? DetailViewController,
              let cell = sender as? UITableViewCell,
              let cellIndexPath = tableView.indexPath(for: cell) else { return }
        let score = modelLogic.getScoreRow(indexPath: cellIndexPath)
        detail.selectedScore = score
       
    }
    
    //No se conecta. se deja vacio. segue de tipo unwind. No unido. Esto permite a la vista siguiente  hacer un outlet.
    
    // pero ha que conectar el storyboard siguiente al exit
    @IBAction func back(_ segue: UIStoryboardSegue) {
        //al salirse ejecuta esta funcion.
        //Como no es reactivo. hay que darle la reactividad
        
        //Dependencia inversa
        
        guard let source = segue.source as? DetailViewController,
              let selected = source.selectedScore,
              let index = modelLogic.indexScore(score: selected)
        else { return }
        let indexPath = IndexPath(row: index, section: 0)
        tableView.reloadRows(at: [indexPath], with: .none)
        }
}
