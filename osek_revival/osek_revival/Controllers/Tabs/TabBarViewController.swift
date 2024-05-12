//
//  TabBarViewController.swift
//  osek_recover
//
//  Created by Исмаил Орумбеков on 04.05.2024.
//

import Foundation
import UIKit

class TabBarViewController: UITabBarController{
    override func viewDidLoad() {
        setUpControllers()
        tabBar.tintColor = .white
    }
    
    func setUpControllers(){
        guard let email = UserDefaults.standard.string(forKey: "email") else{return}
        let homeVC = HomeViewController()
        homeVC.navigationItem.largeTitleDisplayMode = .always
        
        let profileVC = ProfileViewController(currentEmail: email)
        profileVC.navigationItem.largeTitleDisplayMode = .always
        
        let searchVC = SearchViewController()
        searchVC.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: homeVC)
        let nav2 = UINavigationController(rootViewController: profileVC)
        let nav3 = UINavigationController(rootViewController: searchVC)
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        
        nav1.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)
        nav3.tabBarItem = UITabBarItem(title: "Search", image: UIImage(systemName: "magnifyingglass"), tag: 3)
        
        setViewControllers([nav1, nav3, nav2], animated: true)
    }
}
