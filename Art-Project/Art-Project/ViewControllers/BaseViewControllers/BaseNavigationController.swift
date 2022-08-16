//
//  BaseNavigationController.swift
//  TableGit
//
//  Created by MINERVA on 12/08/2022.
//

import UIKit

enum BasicNavigationBarStyles {
    
    case noHeader
    case aLeftItem(leftItem: UIView)
    case aLeftItem_title(leftItem: UIView, title: UIView)
    case aLeftItem_title_aRightItem(leftItem: UIView, title: UIView, rightItem: UIView)
    case aLeftItem_title_TwoRightItems(leftItem: UIView, title: UIView, rightItem: UIView)
    case aLeftItem_title_ThreeRightItems(leftItem: UIView, title: UIView, rightItem: UIView)
    case twoLeftItems(leftItem: UIView)
    case twoLeftItems_title(leftItem: UIView, title: UIView)
    case twoLeftItems_title_aRightItem(leftItem: UIView, title: UIView, rightItem: UIView)
    case twoLeftItems_title_TwoRightItem(leftItem: UIView, title: UIView, rightItem: UIView)
    case twoLeftItems_title_ThreeRightItem(leftItem: UIView, title: UIView, rightItem: UIView)
    case title_aRightItem(title: UIView, rightItem: UIView)
    case title_TwoRightItems(title: UIView, rightItem: UIView)
    case title_ThreeRightItems(title: UIView, rightItem: UIView)
    
}

enum NavigationIcons {
    
    case hamburgerIcon
    case backIcon
    case defaultIcon
    
    var icon: UIImage? {
        switch self {
        case .hamburgerIcon:
            return UIImage(named: "icons8-menu")
            
        case .backIcon:
            return UIImage(named: "icons8-back")
            
        case .defaultIcon:
            return UIImage(named: "default-avatar")
        }
    }
    
    var additionalTitle: String? {
        switch self {
        case .hamburgerIcon:
            return nil
            
        case .backIcon:
            return nil
            
        case .defaultIcon:
            return nil
            
        }
    }
    
}

enum NavigationTitles: String {
    
    case logInViewController
    case signUpViewController
    case homeViewController
    case recordInformationViewController
    case detailedNewsViewController
    case newsViewController
    case artAudioViewController
    case graphViewController
    case settingsViewController
    
}

class BaseNavigationController: UINavigationController {
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
    }
    
}

extension BaseNavigationController: UINavigationControllerDelegate{
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        viewController.navigationItem.setHidesBackButton(true, animated: false)
            
    }
    
}
