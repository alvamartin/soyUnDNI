//
//  Dni.swift
//  miDNI
//
//  Created by Álvaro Martín on 08/09/15.
//  Copyright © 2015 Álvaro A. All rights reserved.
//

import Foundation

class Dni: NSObject, NSCoding {
    
    // MARK: Properties
    
    var numeroDNI: String
    var letra: Character {
        var l: Character
        l = "-"
        if numeroDNI != "" {
            let numDNIint = Int (numeroDNI)
            let indice = numDNIint! % 23
            
           // NSLog(indice.description)
           // NSLog("el número que me llega es " + numeroDNI)
            
            if  (indice > 0) {
                let tablaLetras = "TRWAGMYFPDXBNJZSQVHLCKE"
                //let indiceLetra = tablaLetras.index(indice)
                let indiceLetra = tablaLetras.characters.index(tablaLetras.characters.startIndex, offsetBy: indice)
                l = tablaLetras.characters[indiceLetra]
            }
        }
        return l
    }
    var created: NSDate
    var favorite: Bool
    var notas: String
    var nif: String {
        return numeroDNI + "\(letra)"
    }
    
    
    struct PropertyKey {
        static let numeroKey = "numeroDNI"
        static let createdKey = "created"
        static let favoriteKey = "favorite"
        static let notasKey = "notas"
    }
    
    // MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("dnis")
    
    // MARK: Init
    
    init (numeroDNI: String, created: NSDate, favorite: Bool, notas: String){
        self.numeroDNI = numeroDNI
        self.created = created
        self.favorite = favorite
        self.notas = notas
        super.init()
    }
    
    // MARK: NSCoding
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(numeroDNI, forKey: PropertyKey.numeroKey)
        aCoder.encode(created, forKey: PropertyKey.createdKey)
        aCoder.encode(favorite, forKey: PropertyKey.favoriteKey)
        aCoder.encode(notas, forKey: PropertyKey.notasKey)
    }

//    func encodeWithCoder(aCoder: NSCoder) {
//        aCoder.encode(numeroDNI, forKey: PropertyKey.numeroKey)
//        aCoder.encode(created, forKey: PropertyKey.createdKey)
//        aCoder.encode(favorite, forKey: PropertyKey.favoriteKey)
//        aCoder.encode(notas, forKey: PropertyKey.notasKey)
//    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        let numeroDNI = aDecoder.decodeObject(forKey: PropertyKey.numeroKey) as! String
        let created   = aDecoder.decodeObject(forKey: PropertyKey.createdKey) as! NSDate
        let favorite = aDecoder.decodeBool(forKey: PropertyKey.favoriteKey)
        let notas = aDecoder.decodeObject(forKey: PropertyKey.notasKey) as! String
    
        
        
        self.init (numeroDNI: numeroDNI, created:created, favorite:favorite, notas:notas)
    }
}
