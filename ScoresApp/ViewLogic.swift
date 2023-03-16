//
//  ViewLogic.swift
//  ScoresApp
//
//  Created by Adrian Iraizos Mendoza on 14/3/23.
//

import UIKit
import PhotosUI

final class ViewLogic {
    static let shared = ViewLogic()
    
    let modelLogic = ModelLogic.shared
    let persistence = ModelPersistence.shared
    
    func cellForRowAt(indexPath: IndexPath) -> UIListContentConfiguration {
        
        let score = modelLogic.getScoreRow(indexPath: indexPath)
        
        //Abstraer a ViewLogic
        var content = UIListContentConfiguration.cell()
        content.text = score.title
        content.secondaryText = score.composer
        content.image = getCover(score: score)
        content.imageProperties.cornerRadius = 20
        content.imageProperties.maximumSize = CGSize(width: 100, height: 100)
        
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
    
    func getCover(score:Score) -> UIImage? {
        if let cover = try? persistence.loadImage(id: score.id) {
            return cover
        } else {
            return UIImage(named: score.cover)
        }
    }
    
    func getImageFromLibrary(results:[PHPickerResult], callback: @escaping (UIImage) -> Void) {
        
        guard let provider = results.map(\.itemProvider).first else { return }
        if provider.canLoadObject(ofClass: UIImage.self) {
            provider.loadObject(ofClass: UIImage.self) { item, error in
                
                ///**Esto se va a cargar en segundo plano**
                ///
                guard error == nil,
                      let image = item as? UIImage,
                      //Hay que hacer más pequeña la imagen antes
                      let resized = image.resizeImage(width: 300)
                else { return }

  
                
                //para cargarlo hay que hacerlo desde el hilo principal
                    RunLoop.main.perform {
                        
                        callback(resized)
                    
                }
            }
        }
    }
    
  
}

///**GetFileFromLibrary**
extension ViewLogic {
    
    //MARK: DataImageFromLibrary
    
    ///**Cargar imagen HEIC o HEIF**
    func getDataImageFromLibrary(results: [PHPickerResult], callback: @escaping (UIImage?) -> Void) {
        guard let provider = results.first?.itemProvider else { return }
        
        if provider.hasItemConformingToTypeIdentifier("public.heic") || provider.hasItemConformingToTypeIdentifier("public.heif") {
            provider.loadFileRepresentation(forTypeIdentifier: "public.heic") { url, error in
                if let error = error {
                    print("Error al cargar la imagen HDR: \(error.localizedDescription)")
                    callback (nil)
                    return
                }
                do {
                    let imageData = try Data (contentsOf: url!)
                    
                    if let image = UIImage (data: imageData),
                       let resized = image.resizeImage(width: 300) {
                        RunLoop.main.perform {
                            callback (resized)
                        }
                    }
                } catch {
                    print("Error al convertir la imagen HDR: \(error.localizedDescription)")
                    callback(nil)
                }
            }
        } else {
            // Cargar imágenes JPEG normalmente
            getImageFromLibrary(results: results, callback: callback)
        }
    }
}
