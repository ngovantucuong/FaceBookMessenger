//
//  CustomTarBarController.swift
//  fbMessenger
//
//  Created by ngovantucuong on 10/14/17.
//  Copyright © 2017 apple. All rights reserved.
//

import UIKit

class CustomTarBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let layout = UICollectionViewFlowLayout()
        let friendsController = FriendsController(collectionViewLayout: layout)
        let recentMessageController = UINavigationController(rootViewController: friendsController)
        recentMessageController.tabBarItem.title = "Recent"
        recentMessageController.tabBarItem.image = UIImage(named: "recent")
        
        viewControllers = [recentMessageController, createDummyNavControllerWithTitle(title: "Calls", imageName: "calls"), createDummyNavControllerWithTitle(title: "Groups", imageName: "groups"), createDummyNavControllerWithTitle(title: "People", imageName: "people"), createDummyNavControllerWithTitle(title: "Settings", imageName: "settings")]
    }

    private func createDummyNavControllerWithTitle(title: String, imageName: String) -> UINavigationController {
        let controller = UIViewController()
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.tabBarItem.title = title
        navigationController.tabBarItem.image = UIImage(named: imageName)
        return navigationController
    }
    
}
