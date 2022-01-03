//
//  MainViewController.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2021/12/31.
//

import UIKit
import SwiftUI

class MainViewController: UIViewController {
    private var rootTabBarController: TabBarController!
    private var tutorialViewController: UIHostingController<Tutorial>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !UserDefaults.standard.bool(forKey: "isTutorialLaunched") {
            tutorialViewController = UIHostingController(rootView: Tutorial { [weak self] destination in
                self?.tutorialViewController.view.removeFromSuperview()
                self?.tutorialViewController.removeFromParent()
                self?.tutorialViewController.didMove(toParent: self)
                
                switch destination {
                case .home:
                    self?.rootTabBarController.selectedIndex = 0
                case .usage:
                    self?.rootTabBarController.selectedIndex = 1
                }
                
                Task {
                    try await ExposureManager.shared.activateENManager()
                    try await ExposureManager.shared.detectExposures()
                }
            })
            
            tutorialViewController.view.frame = view.bounds
            tutorialViewController.view.translatesAutoresizingMaskIntoConstraints = true
            tutorialViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addChild(tutorialViewController)
            view.addSubview(tutorialViewController.view)
            
            UserDefaults.standard.set(true, forKey: "isTutorialLaunched")
        }
        // Do any additional setup after loading the view.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TabBarController {
            rootTabBarController = vc
        }
    }

}
