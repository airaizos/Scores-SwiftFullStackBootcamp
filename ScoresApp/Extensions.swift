//
//  Extensions.swift
//  ScoresApp
//
//  Created by Adrian Iraizos Mendoza on 14/3/23.
//

import UIKit
import CoreGraphics

extension NumberFormatter {
    static let formateador: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.locale = Locale.current
        return nf
    }()
}

extension String {
    var clearNumber:String {
        let numbers:Set<Character> = Set("0123456789")
        return filter { numbers.contains($0) }
        //  CharacterSet.decimalDigits
    }
}

extension UIImage {
    // Hacer más pequeña la imagen. También disminuye la memoria que usa la app
    //hay método síncrono, asincrono completion handler y con asynawait. ios16
    
    ///**A partir 15**
    func resizeImage(width:CGFloat) -> UIImage? {
        let scale:CGFloat = width / self.size.width
        let height:CGFloat = self.size.height * scale
        return self.preparingThumbnail(of: CGSize(width: width, height: height))
    }
    
    ///**Para iOs 14 y anteriores**
    func resizeImageOld(newWidth:CGFloat) -> UIImage? {
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(origin: CGPoint.zero, size: CGSize(width: newWidth, height: newHeight)))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
