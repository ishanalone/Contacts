//
//  Persistable.swift
//  Jet2Assignment
//
//  Created by Sushant Alone on 05/08/20.
//  Copyright © 2020 Ishan Alone. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public protocol Persistable {
    associatedtype ManagedObject : NSManagedObject
   
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject?
    func managedObject(_ object:ManagedObject) -> ManagedObject
}

extension Persistable{
    func context() -> NSManagedObjectContext? {
         guard let appDelegate =
           UIApplication.shared.delegate as? AppDelegate else {
           return nil
         }
        let managedContext =
        appDelegate.persistentContainer.viewContext
        return managedContext
        
    }
    
    func entity() -> NSEntityDescription? {
        if let context = context(){
            let entity = NSEntityDescription.entity(forEntityName: ManagedObject.className(), in: context)
            return entity
        }
        return nil
    }
}
