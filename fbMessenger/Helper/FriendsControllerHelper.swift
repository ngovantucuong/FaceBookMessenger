//
//  FriendsControllerHelper.swift
//  fbMessenger
//
//  Created by ngovantucuong on 10/14/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import CoreData

extension FriendsController {
    func setupData() {
        let mark = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: AppDelegate.managerObjectContext!) as! FriendMO
        mark.name = "Mark Zuckerberg"
        mark.profileImageName = "zuckprofile"
        
        let messageZuc = NSEntityDescription.insertNewObject(forEntityName: "Message", into: AppDelegate.managerObjectContext!) as! MessageMO
        messageZuc.friends = mark
        messageZuc.text = "Hello, my name is Mark. Nice to meet you"
        messageZuc.date = NSDate()
        
        let steve = NSEntityDescription.insertNewObject(forEntityName: "Friend", into: AppDelegate.managerObjectContext!) as! FriendMO
        steve.name = "Steve Jobs"
        steve.profileImageName = "steve_profile"
        
        let messageSteve = NSEntityDescription.insertNewObject(forEntityName: "Message", into: AppDelegate.managerObjectContext!) as! MessageMO
        messageSteve.friends = steve
        messageSteve.text = "Apple cretes great IOS device for..."
        messageSteve.date = NSDate()
        
        loadData()
    }
    
    func loadData() {
       let context = AppDelegate.managerObjectContext!
        do {
            let result = try context.fetch(MessageMO.fetchRequest()) as! [MessageMO]
            messages = result
        } catch let err {
            print(err)
        }
    }
    
    func clearData() {
        let context = AppDelegate.managerObjectContext!
        do {
            let messages = try context.fetch(MessageMO.fetchRequest()) as! [MessageMO]
            for message in messages {
                context.delete(message)
            }
            
            try context.save()
            
        } catch let err {
            print(err)
        }
    }
}
