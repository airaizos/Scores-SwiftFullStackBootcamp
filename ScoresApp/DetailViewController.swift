//
//  DetailViewController.swift
//  ScoresApp
//
//  Created by Adrian Iraizos Mendoza on 13/3/23.
//

import UIKit
import PhotosUI

final class DetailViewController: UITableViewController, PHPickerViewControllerDelegate {

    let viewLogic = ViewLogic.shared
    let modelLogic = ModelLogic.shared
    
    var selectedScore:Score?
    var newCover:UIImage? {
        didSet {
            if let newCover {
                cover.image = newCover
            }
        }
    }
    
    @IBOutlet weak var titulo: UITextField!
    @IBOutlet weak var composer: UITextField!
    @IBOutlet weak var year: UITextField!
    @IBOutlet weak var length: UITextField!
    @IBOutlet weak var cover: UIImageView!
    
    //Para poner el menu, mejor outlet en lugar de action.
    @IBOutlet weak var changeComposer: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let selectedScore = selectedScore {
            titulo.text = selectedScore.title
            composer.text = selectedScore.composer
            year.text = selectedScore.yearString
            length.text = selectedScore.lengthString
            cover.image = viewLogic.getCover(score: selectedScore)
        }
        changeComposerButton()
      //  print(UIScreen.main.scale)
      //  print(view?.window?.windowScene?.screen.nativeScale)
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
        
        modelLogic.updateScore(score: newScore,newCover: newCover)
        performSegue(withIdentifier: "saveBack", sender: nil)
    }
    
    @IBAction func changeCover(_ sender: UIButton) {
        
        ///**Saca un viewController con el carrete
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selection = .ordered
        //configuration.preferredAssetRepresentationMode = .compatible
        configuration.selectionLimit = 1
        
        let photosPicker = PHPickerViewController(configuration: configuration)
        present(photosPicker, animated: true)
        
        photosPicker.delegate = self
    }
    
    //MARK: Photos picker delegate. Patrón delegate con un closure
    ///**Delegado para poder elegir la imagen. Cuando elija una imagen llamará a esta función
   
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        viewLogic.getDataImageFromLibrary(results: results) { image in
            RunLoop.main.perform {
                self.newCover = image
            }
        }
    }
   
}


extension DetailViewController {
    //Pasado al ViewLogic. así no se entera de como se hace la cargade la imagen
    
    ///NSItemProvider proveedor de items para conveniencia de datos para interncambiar ficheros. **Contenedor genérico que permite que distentas apps intercambian información**
       
    func pickerNoViewLogic(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        

        ///Como no se está capturando nada
        guard let provider = results.map(\.itemProvider).first else { return }
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { item, error in
                
                guard error == nil,
                      let image = item as? UIImage else { return }
                
              
                RunLoop.main.perform {
        
                    
                    self.cover.image = image
                }
            }
        }
    }
   
    //Tipo HEIC
    func pickerGetDataImagesFromLibrary(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        viewLogic.getDataImageFromLibrary(results: results) { image in
            RunLoop.main.perform {
                self.cover.image = image
            }
        }
    }
}
