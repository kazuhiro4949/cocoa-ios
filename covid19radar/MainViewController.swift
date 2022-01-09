//
//  MainViewController.swift
//  covid19radar
//
//  Created by kazuhiro2 on 2021/12/31.
//

import UIKit
import SwiftUI

@MainActor
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
                
                Task { @MainActor [weak self] in
                    try await ExposureManager.shared.activateENManager()
                    try await ExposureManager.shared.detectExposures()
                    
                    let success = try await UNUserNotificationCenter.current().backport.requestAuthorization(options: [.alert])
                    if !success {
                        let alertController = UIAlertController(title: "通知をご利用いただくために", message: "接触の通知をご利用いただくためには、本アプリのプッシュ通知を有効にしてください。", preferredStyle: .alert)
                        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                        self?.present(alertController, animated: true, completion: nil)
                    }
                }
            })
            
            tutorialViewController.view.frame = view.bounds
            tutorialViewController.view.translatesAutoresizingMaskIntoConstraints = true
            tutorialViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addChild(tutorialViewController)
            view.addSubview(tutorialViewController.view)
            
            UserDefaults.standard.set(true, forKey: "isTutorialLaunched")
        }
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? TabBarController {
            rootTabBarController = vc
        }
    }

}
