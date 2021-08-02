//
//  UIViewController+Ext.swift
//  3205Test
//
//  Created by Macbook Pro on 29.07.2021.
//

import UIKit

fileprivate var aView: UIView?

extension UIViewController {
    static func instantiate<T>(storyboardName: String = "Main") -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "\(T.self)") as! T
        return viewController
    }
    
    func customizeNavBarController(clear: Bool = false) {
        let backArrowImage = UIImage(named: "backArrow")
        navigationController?.navigationBar.backIndicatorImage = backArrowImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backArrowImage
        navigationController?.navigationBar.backItem?.title = ""
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style:.plain, target:nil, action:nil)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = clear
        navigationController?.navigationBar.tintColor = clear ? .white : .black
        navigationController?.view.backgroundColor = .white
        if clear { navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default) }
    }
    
    func callErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { action in
            self.dismiss(animated: true, completion: nil)
        })
        present(alert, animated: true)
    }
    
    //MARK: - Show activity Indicator
    func showActivityIndicator(alpha: CGFloat = 0) {
        aView = UIView(frame: self.view.bounds)
        aView?.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: alpha)
        
        var activityIndicator = UIActivityIndicatorView()
        if #available(iOS 13.0, *) {
            activityIndicator = UIActivityIndicatorView(style: .large)
        } else {
            activityIndicator = UIActivityIndicatorView()
        }
        activityIndicator.color = .mainColor
        activityIndicator.center = aView!.center
        activityIndicator.startAnimating()
        aView?.addSubview(activityIndicator)
        self.view.addSubview(aView!)
    }
    
    //MARK: - Hide activity Indicator
    func hideActivityIndicator() {
        aView?.removeFromSuperview()
        aView = nil
    }
}
