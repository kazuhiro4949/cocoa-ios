//
//  TabBarController.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2021/12/31.
//

import UIKit
import SwiftUI

class TabBarController: UITabBarController {
    let homeViewController: UIHostingController<Home> = {
        let vc = UIHostingController(rootView: Home())
        vc.tabBarItem = UITabBarItem(
            title: "ホーム",
            image: UIImage(systemName: "house"),
            selectedImage: UIImage(systemName: "house.fill"))
        return vc
    }()
    
    let othersViewController: UIHostingController<Others> = {
        let vc = UIHostingController(rootView: Others())
        vc.tabBarItem = UITabBarItem(
            title: "その他",
            image: UIImage(systemName: "line.3.horizontal.circle"),
            selectedImage: UIImage(systemName: "line.3.horizontal.circle.fill"))
        return vc
    }()
    
    let inqueryViewController: UIHostingController<Inquery> = {
        let vc = UIHostingController(rootView: Inquery())
        vc.tabBarItem = UITabBarItem(
            title: "お問い合わせ",
            image: UIImage(systemName: "envelope"),
            selectedImage: UIImage(systemName: "envelope.fill"))
        return vc
    }()
    
    let usageViewController: UIHostingController<Usage> = {
        let vc = UIHostingController(rootView: Usage())
        vc.tabBarItem = UITabBarItem(
            title: "使い方",
            image: UIImage(systemName: "lightbulb"),
            selectedImage: UIImage(systemName: "lightbulb.fill"))
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 15.0, *) {
            let tabBarAppearance = UITabBarAppearance()
            tabBarAppearance.configureWithDefaultBackground()
            tabBarAppearance.backgroundColor = .white
            tabBar.standardAppearance = tabBarAppearance
            tabBar.scrollEdgeAppearance = tabBarAppearance
        }
        
        setViewControllers([
            homeViewController,
            usageViewController,
            inqueryViewController,
            othersViewController], animated: false)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
