//
//  StepsStore.swift
//  pedometer
//
//  Created by Fitz on 2019/1/31.
//  Copyright © 2019年 Facebook. All rights reserved.
//

import Foundation
import CoreData;

class StepsStore: NSObject {
  
  
  static  var persistentContainer: NSPersistentContainer = {
    
    
    let container = NSPersistentContainer(name:"StepModel");
    
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        
        /*
         Typical reasons for an error here include:
         * The parent directory does not exist, cannot be created, or disallows writing.
         * The persistent store is not accessible, due to permissions or data protection when the device is locked.
         * The device is out of space.
         * The store could not be migrated to the current model version.
         Check the error message to determine what the actual problem was.
         */
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
      
//      print(storeDescription)
    })
    return container
    
    
  }()
  
  
  func saveContext () {
    let context = StepsStore.persistentContainer.viewContext
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        // Replace this implementation with code to handle the error appropriately.
        // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        let nserror = error as NSError
        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }

  
  static func fetch(){
    
     let delegate =   StepsStore.persistentContainer.viewContext
    
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Steps");
    
    do {
      
      
      let fetched = try delegate.fetch(fetchRequest) as? [NSManagedObject];
      
      if let result = fetched {
        
        print(result)
        
      }
      
      
      
      
    }catch{}
    
    
  }
  
 
  
  
  static func insert(steps:Double){
    
    let context =  StepsStore.persistentContainer.viewContext;
    
    let entity = NSEntityDescription.entity(forEntityName: "Steps", in: context)
    
    
  }
  
  
  
  
}
