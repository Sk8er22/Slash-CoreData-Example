//
//  Song.swift
//  swifttest
//
//  Created by PEDRO ARMANDO MANFREDI on 30/5/17.
//  Copyright © 2017 Slash Mobility S.L. All rights reserved.
//

import Foundation
import CoreData

class Song : NSManagedObject {
    @NSManaged var trackId : Int16
    @NSManaged var trackName : String
    @NSManaged var collectionCensoredName : String
    @NSManaged var country : String
    
}
