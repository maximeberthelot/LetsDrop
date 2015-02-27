//
//  Messages.swift
//  LetsDrop
//
//  Created by Maxime Berthelot on 26/02/2015.
//  Copyright (c) 2015 Maxime Berthelot. All rights reserved.
//

import Foundation
import CoreData

class Messages: NSManagedObject {

    @NSManaged var locate: String
    @NSManaged var title: String
    @NSManaged var message: String

}
