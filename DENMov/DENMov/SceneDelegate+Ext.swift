//
//  SceneDelegate+Ext.swift
//  DENMov
//
//  Created by DENAZMI on 20/07/24.
//

import UIKit

extension SceneDelegate {
    
    var hasNavigationController: Bool {
        return window?.topNavigationController != nil
    }
    
    func pushOnce(_ destinationViewController: UIViewController, animated: Bool = true) {
        guard let top = window?.topViewController, type(of: top) != type(of: destinationViewController) else {
            return
        }
        
        self.push(destinationViewController, animated: animated)
    }
    
    func push(_ destinationViewController: UIViewController, animated: Bool = true) {
        DispatchQueue.main.async {
            self.window?.topNavigationController?.pushViewController(
                destinationViewController,
                animated: animated
            )
        }
    }
    
    func presentOnce(_ destinationViewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let top = window?.topViewController, type(of: top) != type(of: destinationViewController) else {
            return
        }
        DispatchQueue.main.async {
            self.window?.topViewController?.present(
                destinationViewController,
                animated: animated,
                completion: completion
            )
        }
    }
    
    func pushOnceAndPopLast(_ destinationViewController: UIViewController, animated: Bool = true) {
        guard let top = window?.topViewController, type(of: top) != type(of: destinationViewController) else {
            return pushThenPopLast()
        }
        
        func pushThenPopLast() {
            pushViewControllerWithPresentFallback(destinationViewController, animated: animated)
            popViewControllerBeforeLast()
        }
        
        window?.topNavigationController?.pushViewController(destinationViewController, animated: animated)
    }
    
    func pushViewControllerWithPresentFallback(_ destinationViewController: UIViewController, animated: Bool = true) {
        if hasNavigationController {
            window?.topNavigationController?.pushViewController(destinationViewController, animated: animated)
        } else {
            let navigationController = UINavigationController(rootViewController: destinationViewController)
            navigationController.modalPresentationStyle = .fullScreen
            window?.topViewController?.present(navigationController, animated: animated)
        }
    }
    
    func dismissControllerWithPopFallback(animated: Bool = true, completion: (() -> Void)? = nil) {
        if hasNavigationController {
            if window?.topNavigationController?.presentingViewController != nil {
                window?.topNavigationController?.dismiss(animated: animated, completion: completion)
            } else {
                window?.topNavigationController?.popViewController(animated: animated)
                completion?()
            }
        } else {
            window?.topViewController?.dismiss(animated: animated, completion: completion)
        }
    }
    
    func dismiss(until topViewController: UIViewController.Type, animated: Bool = true, completion: (() -> Void)? = nil) {
        guard let top = window?.topViewController, type(of: top) != topViewController else {
            completion?()
            return
        }
        
        dismissControllerWithPopFallback(animated: animated) { [weak self] in
            self?.dismiss(until: topViewController)
        }
    }
    
    func popViewControllerBeforeLast() {
        if let navigationController = window?.topNavigationController {
            
            let viewControllers = navigationController.viewControllers
            
            guard let last = viewControllers.last, let lastIndex = viewControllers.firstIndex(of: last) else {
                return
            }
            
            let indexToRemove = lastIndex - 1
            
            if indexToRemove < viewControllers.count {
                var viewControllers = navigationController.viewControllers
                viewControllers.remove(at: indexToRemove)
                navigationController.viewControllers = viewControllers
            }
        }
    }
}

// MARK: UIWindow
var rootViewControllerKey: UInt8 = 0

extension UIWindow {
    
    var topNavigationController: UINavigationController?  {
        return topViewController?.navigationController
    }

    private class func topViewController(_ base: UIViewController?) -> UIViewController? {
        if let nav = base as? UINavigationController {
            let top = topViewController(nav.visibleViewController)
            return top
        }

        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                let top = topViewController(selected)
                return top
            }
        }

        if let presented = base?.presentedViewController {
            let top = topViewController(presented)
            return top
        }
        return base
    }
    
    var topViewController: UIViewController? {
        return UIWindow.topViewController(rootViewController)
    }
 
    func switchRootViewController(_ viewController: UIViewController,  animated: Bool = true, duration: TimeInterval = 0.5, options: UIView.AnimationOptions = .transitionFlipFromBottom, completion: (() -> Void)? = nil) {
        guard animated else {
            rootViewController = viewController
            return
        }
        
        UIView.transition(with: self, duration: duration, options: options, animations: {
            let oldState = UIView.areAnimationsEnabled
            UIView.setAnimationsEnabled(false)
            self.rootViewController = viewController
            UIView.setAnimationsEnabled(oldState)
        }) { _ in
            completion?()
        }
    }
    
    func switchRootWithPushTo(viewController: UIViewController, withAnimation animation: CATransitionSubtype = .fromRight) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = animation
        transition.isRemovedOnCompletion = true
        
        self.layer.add(transition, forKey: kCATransition)
        self.rootViewController = viewController
    }
}
