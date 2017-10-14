//
//  ChatLogController.swift
//  fbMessenger
//
//  Created by ngovantucuong on 10/14/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var messages: [MessageMO]?
    var cellID = "cellID"
    
    var friends: FriendMO? {
        didSet {
            navigationItem.title = friends?.name
            
            messages = friends?.messages?.allObjects as? [MessageMO]
            messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedDescending})
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.backgroundColor = UIColor.white
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? ChatLogMessageCell
        cell?.messageTextView.text = messages?[indexPath.item].text
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }

}


class ChatLogMessageCell: BaseCell {
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        return textView
    }()
    
    override func setupView() {
        super.setupView()
        
        addSubview(messageTextView)
        addConstraintWithFormat(format: "H:|[v0]|", views: messageTextView)
        addConstraintWithFormat(format: "V:|[v0]|", views: messageTextView)
    }
}
