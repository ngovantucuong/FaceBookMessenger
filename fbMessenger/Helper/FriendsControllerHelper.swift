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
        
        createMessageWithText(text: "Good morning...", friend: steve, minutesAgo: 2, context: AppDelegate.managerObjectContext!)
        createMessageWithText(text: "Hello, How are you", friend: steve, minutesAgo: 1, context: AppDelegate.managerObjectContext!)
        createMessageWithText(text: "Are you interested in buying an Apple device", friend: steve, minutesAgo: 0, context: AppDelegate.managerObjectContext!)
        
        loadData()
    }
    
    private func createMessageWithText(text: String, friend: FriendMO, minutesAgo: Double, context: NSManagedObjectContext) {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! MessageMO
        message.friends = friend
        message.text = text
        message.date = NSDate().addingTimeInterval(minutesAgo * 60)
    }
    
    func loadData() {
       let context = AppDelegate.managerObjectContext!
        
        if let friends = fetchFriends() {
            var message = [MessageMO]()
            
            for friend in friends {
                
                let fetchRequestMessage = NSFetchRequest<MessageMO>(entityName: "Message")
                fetchRequestMessage.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
                fetchRequestMessage.predicate = NSPredicate(format: "friends.name = %@", friend.name!)
                fetchRequestMessage.fetchLimit = 1
                
                do {
                    let result = try context.fetch(fetchRequestMessage)
                    message.append(contentsOf: result)
                } catch let err {
                    print(err)
                }
            }
            messages = message.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedDescending})
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
    
    private func fetchFriends() -> [FriendMO]? {
        let context = AppDelegate.managerObjectContext
        do {
            return try context?.fetch(FriendMO.fetchRequest()) as? [FriendMO]
        } catch let err {
            print(err)
        }
        return nil
    }
}
