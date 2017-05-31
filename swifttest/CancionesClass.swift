//
//  CancionesClass.swift
//  swifttest
//
//  Created by PEDRO ARMANDO MANFREDI on 30/5/17.
//  Copyright © 2017 Slash Mobility S.L. All rights reserved.
//

import Foundation
import CoreData

class CancionesClass {
    let trackId : Int16
    let trackName : String
    let collectionCensoredName : String
    let country : String
    
    init(dictionary : [String : AnyObject]) {
        trackId = dictionary["trackId"] as? Int16 ?? 0
        trackName = dictionary["trackName"] as? String ?? ""
        collectionCensoredName = dictionary["collectionCensoredName"] as? String ?? ""
        country = dictionary["country"] as? String ?? ""
    }
    
    init(song: Song) {
        trackId = song.trackId as Int16
        trackName = song.trackName as String
        collectionCensoredName = song.collectionCensoredName as String
        country = song.country as String
        
    }
}
