//
//  FriendMO+CoreDataProperties.swift
//  fbMessenger
//
//  Created by ngovantucuong on 10/14/17.
//  Copyright © 2017 apple. All rights reserved.
//
//

import Foundation
import CoreData


extension FriendMO {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FriendMO> {
        return NSFetchRequest<FriendMO>(entityName: "Friend")
    }

    @NSManaged public var name: String?
    @NSManaged public var profileImageName: String?
    @NSManaged public var messages: NSSet?

}

// MARK: Generated accessors for messages
extension FriendMO {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageMO)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageMO)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}
