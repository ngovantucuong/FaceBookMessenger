//
//  ChatLogController.swift
//  fbMessenger
//
//  Created by ngovantucuong on 10/14/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "Cell"

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {

//    var messages: [MessageMO]?
    var cellID = "cellID"
    
    var friends: FriendMO? {
        didSet {
            navigationItem.title = friends?.name
            
//            messages = friends?.messages?.allObjects as? [MessageMO]
//            messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending})
        }
    }
    
    let messageInputContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        return textField
    }()
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor.formatColorWith(red: 0, green: 137, blue: 249)
        button.setTitleColor(titleColor, for: .normal)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    @objc func handleSend() {
        let context = AppDelegate.managerObjectContext
        
        FriendsController.createMessageWithText(text: inputTextField.text!, friend: friends!, minutesAgo: 0, context: context!, isSender: true)
        
        do {
            try context?.save()
            
//            messages?.append(message)
//            let insertionIndexpath = (messages?.count)! - 1
//            let indexpath = NSIndexPath(item: insertionIndexpath, section: 0)
//            collectionView?.insertItems(at: [indexpath as IndexPath])
//            collectionView?.scrollToItem(at: indexpath as IndexPath, at: .bottom, animated: true)
            inputTextField.text = nil
        } catch let err {
            print(err)
        }
    }
    
    var bottomConstraint: NSLayoutConstraint?
    
    @objc func handleSimulater() {
       
        let context = AppDelegate.managerObjectContext!
        FriendsController.createMessageWithText(text: "Here's a message that was send a few minutes ago...", friend: friends!, minutesAgo: 1, context: context)
        
        do {
            try context.save()
            inputTextField.text = nil
            
//            messages?.append(message)
//            messages = messages?.sorted(by: {$0.date!.compare($1.date! as Date) == .orderedAscending})
//
//            if let index = messages?.index(of: message) {
//                let insertIndexPath = NSIndexPath(item: index, section: 0)
//                collectionView?.insertItems(at: [insertIndexPath as IndexPath])
//                collectionView?.scrollToItem(at: insertIndexPath as IndexPath, at: .bottom, animated: true)
//                inputTextField.text = nil
//            }
        } catch let err {
            print(err)
        }
    }
    
    lazy var fetchResultController: NSFetchedResultsController = { () -> NSFetchedResultsController<MessageMO> in
        let fetchRequest = NSFetchRequest<MessageMO>(entityName: "Message")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "friends.name = %@", self.friends!.name!)
        
        let rs = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.managerObjectContext!, sectionNameKeyPath: nil, cacheName: nil)
        return rs
    }()
    
    let blockOperation = [BlockOperation]()
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            collectionView?.insertItems(at: [newIndexPath!])
            collectionView?.scrollToItem(at: newIndexPath!, at: .bottom, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchResultController.performFetch()
        } catch let err {
            print(err)
        }
        
        tabBarController?.tabBar.isHidden = true
        collectionView?.alwaysBounceVertical = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulater", style: .plain, target: self, action: #selector(handleSimulater))
            
        // Register cell classes
        self.collectionView!.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.backgroundColor = UIColor.white
        
        view.addSubview(messageInputContainer)
        view.addConstraintWithFormat(format: "H:|[v0]|", views: messageInputContainer)
        view.addConstraintWithFormat(format: "V:[v0(48)]", views: messageInputContainer)
        
        bottomConstraint = NSLayoutConstraint(item: messageInputContainer, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        setupInputComponets()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification(notification:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardNotification(notification: NSNotification) {
        if let userInfor = notification.userInfo {
            let keyboardFrame = (userInfor[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            
            let isKeyboardShower = notification.name == .UIKeyboardWillShow
            
            bottomConstraint?.constant = isKeyboardShower ? -(keyboardFrame?.height)! : 0
            
            UIView.animateKeyframes(withDuration: 0, delay: 0, options: UIViewKeyframeAnimationOptions(), animations: {
                self.view.layoutIfNeeded()
            }, completion: { (complete) in
                if isKeyboardShower {
//                    let lastIndexPath = NSIndexPath(item: (self.messages?.count)! - 1, section: 0)
//                    self.collectionView?.scrollToItem(at: lastIndexPath as IndexPath, at: .bottom, animated: true)
                }
            })
        }
    }
    
    private func setupInputComponets() {
        let topBorder = UIView()
        topBorder.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        messageInputContainer.addSubview(inputTextField)
        messageInputContainer.addSubview(sendButton)
        messageInputContainer.addSubview(topBorder)
        
        messageInputContainer.addConstraintWithFormat(format: "H:|-8-[v0][v1(69)]|", views: inputTextField, sendButton)
        messageInputContainer.addConstraintWithFormat(format: "V:|[v0]|", views: inputTextField)
        messageInputContainer.addConstraintWithFormat(format: "V:|[v0]|", views: sendButton)
        
        messageInputContainer.addConstraintWithFormat(format: "H:|[v0]|", views: topBorder)
        messageInputContainer.addConstraintWithFormat(format: "V:|[v0(0.5)]", views: topBorder)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.view.endEditing(true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchResultController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? ChatLogMessageCell
        let message = fetchResultController.object(at: indexPath)
        
        cell?.messageTextView.text = message.text
        
        if let textMessage = message.text, let profileImageName = message.friends?.profileImageName {
            
            cell?.profileImageView.image = UIImage(named: profileImageName)
            
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimateString = NSString(string: textMessage).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            if !message.isSender {
                cell?.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimateString.width + 16, height: estimateString.height + 16)
                cell?.textBubleView.frame = CGRect(x: 48 - 10, y: 0, width: estimateString.width + 16 + 8 + 16, height: estimateString.height + 16)
                
                cell?.profileImageView.isHidden = false
                //cell?.textBubleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                cell?.messageTextView.textColor = UIColor.black
                cell?.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
                cell?.bubbleImageView.image = ChatLogMessageCell.grayBubbleImage
            } else {
                cell?.messageTextView.frame = CGRect(x: view.frame.width - estimateString.width - 16 - 8, y: 0, width: estimateString.width + 16, height: estimateString.height + 16)
                cell?.textBubleView.frame = CGRect(x: view.frame.width - estimateString.width - 16 - 8 - 16, y: 0, width: estimateString.width + 16, height: estimateString.height + 16)
                
                cell?.profileImageView.isHidden = true
                //cell?.textBubleView.backgroundColor = UIColor.formatColorWith(red: 0, green: 137, blue: 249)
                cell?.messageTextView.textColor = UIColor.white
                cell?.bubbleImageView.tintColor = UIColor.formatColorWith(red: 0, green: 137, blue: 249)
                cell?.bubbleImageView.image = ChatLogMessageCell.blueBubbleImage
            }
            
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = fetchResultController.object(at: indexPath)
        if let textMessage = message.text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let estimateString = NSString(string: textMessage).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)], context: nil)
            
            return CGSize(width: view.frame.width, height: estimateString.height + 20)
        }
        
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }

}


class ChatLogMessageCell: BaseCell {
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    let textBubleView: UIView = {
        let view = UIView()
        //view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    static let grayBubbleImage = UIImage(named: "bubble_gray")?.resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = UIImage(named: "bubble_blue")?.resizableImage(withCapInsets: UIEdgeInsetsMake(22, 26, 22, 26)).withRenderingMode(.alwaysTemplate)
    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor(white: 0.95, alpha: 1)
        return imageView
    }()
    
    override func setupView() {
        super.setupView()
        
        addSubview(textBubleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        
        addConstraintWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)
        addConstraintWithFormat(format: "V:[v0(30)]", views: profileImageView)
        
        textBubleView.addSubview(bubbleImageView)
        textBubleView.addConstraintWithFormat(format: "H:|[v0]|", views: bubbleImageView)
        textBubleView.addConstraintWithFormat(format: "V:|[v0]|", views: bubbleImageView)
    }
}
