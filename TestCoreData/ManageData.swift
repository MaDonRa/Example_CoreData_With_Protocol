//
//  ManageData.swift
//  TestCoreData
//
//  Created by Sakkaphong Luaengvilai on 12/1/2560 BE.
//  Copyright © 2560 MaDonRa. All rights reserved.
//

import UIKit
import CoreData

typealias DataReadWrite = DataReader & DataWriter & DataFinder

typealias DataFullAccess = DataReader & DataWriter & DataFinder & DataRemoveAll & DataRemoveFromKey

protocol DataReader {
    func read(Sort_ID_ASC : Bool) -> [UserName]
}

protocol DataFinder {
    func find(id : String) -> [UserName]
}

protocol DataWriter {
    func write(name: String , age : Int , image : UIImage)
}

protocol DataRemoveAll {
    func removeAll()
}

protocol DataRemoveFromKey {
    func removeKey(ID:Int)
}

class FileData: DataReader , DataFinder , DataWriter , DataRemoveAll , DataRemoveFromKey {
    
    func ManageData() -> NSManagedObjectContext?
    {
        
        guard let appDel = UIApplication.shared.delegate as? AppDelegate else { return nil }
        return appDel.persistentContainer.viewContext
        
    }

    func read(Sort_ID_ASC : Bool) -> [UserName] {
        
        guard let Manage = ManageData() else { return [] }
        let request = NSFetchRequest<UserName>(entityName: "UserName")
        
        //request.predicate = NSPredicate(format: "id = %@", "5") // Find Row Same "Where" in MySQL
        
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: Sort_ID_ASC) // Order by ASC - DESC
        let sortDescriptors = [sortDescriptor]
        request.sortDescriptors = sortDescriptors
        
        
        
        do {
            
            let results:[UserName] = try Manage.fetch(request)
            
            //print("Amount \(results.count)")
  
//            for res in results
//            {
//
//                return "\(res.id) , \(res.names ?? "") , \(res.age)"
//
//            }
            
            return (results)
            
        }
        catch let error
        {
            
            print("Error Core Data \(error)")
            
        }
        
        print("Can't not load")
        
        return []
    }
    
    func find(id : String) -> [UserName] {
        
        guard let Manage = ManageData() else { return [] }
        let request = NSFetchRequest<UserName>(entityName: "UserName")
        
        request.predicate = NSPredicate(format: "id = %@", "\(id)") // Find Row Same "Where" in MySQL

        do {
            
            let results:[UserName] = try Manage.fetch(request)
            
            //            for res in results
            //            {
            //
            //                return "\(res.id) , \(res.names ?? "") , \(res.age)"
            //
            //            }
            
            return results
            
        }
        catch let error
        {
            
            print("Error Core Data \(error)")
            
        }
        
        print("Can't not load")
        
        return []
    }
    
    func write(name: String , age : Int , image : UIImage) {
        
        guard let Manage = ManageData() else { return }
        let newCal = NSEntityDescription.insertNewObject(forEntityName: "UserName", into: Manage)
        
        newCal.setValue(name, forKey: "names")
        newCal.setValue(age, forKey: "age")
        
        if let data:Data = UIImagePNGRepresentation(image) {
            newCal.setValue(data, forKey: "photo")
        } else if let data:Data = UIImageJPEGRepresentation(image, 1.0) {
            newCal.setValue(data, forKey: "photo")
        }
        
        newCal.setValue((LastID() ?? 0)+1, forKey: "id")
        
        //        let newad = NSEntityDescription.insertNewObject(forEntityName: "Address", into: context)
        //
        //        newad.setValue("bababa", forKey: "name")
        //        newad.setValue(5, forKey: "user_id")
        
        do {
            try Manage.save()
        }
        catch let error
        {
            
            print("Error Save Core Data \(error)")
            
        }
        
        print("Save")
        
    }
    
    func LastID() -> Int?
    {
        
        guard let Manage = ManageData() else { return nil }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserName")
        
        guard let results:NSArray = try? Manage.fetch(request) as NSArray else { return nil }
        
        //print("LoadLast")
        
        return results.count
    }
    
    func removeAll() {
        // Clear DATA
        guard let Manage = ManageData() else { return }
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "DB_Beacon")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try Manage.execute(deleteRequest)
            try Manage.save()
        } catch {
            print ("There was an error \(error)")
        }
        
        print("Remove ALL")
    }
    
    func removeKey(ID:Int)
    {
        // Clear DATA
        guard let Manage = ManageData() else { return }
        
        let request = NSFetchRequest<UserName>(entityName: "UserName")

        request.predicate = NSPredicate(format: "id = %@", "\(removeKey)") // Delete Each Row
        
        do {
            
            let results:[UserName] = try Manage.fetch(request)
            
            //print("Amount \(results.count)")
            
            for res in results
            {
                
                Manage.delete(res)
                
            }
            
        }
        catch let error
        {
            
            print("Error Remove Core Data \(error)")
            
        }
        
        do {
            try Manage.save()
        }
        catch _ {
        }
        
        print("Remove ALL")
        
    }
    
}

