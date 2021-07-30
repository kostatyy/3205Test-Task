//
//  UIViewController+Ext.swift
//  3205Test
//
//  Created by Macbook Pro on 29.07.2021.
//

import UIKit

extension UIViewController {
    static func instantiate<T>(storyboardName: String = "Main") -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "\(T.self)") as! T
        return viewController
    }
    
    func customizeNavBarController() {
        let backArrowImage = UIImage(named: "backArrow")
        navigationController?.navigationBar.backIndicatorImage = backArrowImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backArrowImage
        navigationController?.navigationBar.backItem?.title = ""
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:.plain, target:nil, action:nil)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .black
        navigationController?.view.backgroundColor = .white
    }
    
    func callErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
        })
        present(alert, animated: true)
    }
}
