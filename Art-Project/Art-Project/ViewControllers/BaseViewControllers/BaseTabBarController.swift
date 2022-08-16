//
//  BaseTabBarController.swift
//  TableGit
//
//  Created by MINERVA on 21/07/2022.
//

import UIKit

enum TabItem: String, CaseIterable {
    case home = "home"
    case news = "news"
    case audio = "audio"
    case graph = "graph"
    case settings = "settings"

    var viewController: UIViewController {
        switch self {
        case .home:
            
            let rootVC = HomeViewController()
            return BaseNavigationController(rootViewController: rootVC)
            
        case .news:
            let rootVC = NewsViewController()
            return UINavigationController(rootViewController: rootVC)
            
        case .settings:
            
            let rootVC = SettingsViewController()
            return UINavigationController(rootViewController: rootVC)
            
        case .graph:
            return GraphViewController()
            
        case .audio:
            let rootVC = ArtAudioViewController()
            return UINavigationController(rootViewController: rootVC)
            
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .home:
            return UIImage(named: "icons8-home")
            
        case .news:
            return UIImage(named: "icons8-news")
            
        case .settings:
            return UIImage(named: "icons8-settings")
            
        case .graph:
            return UIImage(named: "icons8-increase-profits")
            
        case .audio:
            return UIImage(named: "icons8-audio")
        }
    }
    
    var displayTitle: String {
        
        return self.rawValue.capitalized(with: nil)
        
    }
        
}

class BaseTabBarController: UITabBarController {
    //MARK: Properties
    var customTabBar: CustomTabBar?
    var tabBarHeight: CGFloat = 82.0
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadTabBar()
        
    }
    
    
    //MARK: Helpers
    func loadTabBar() {
                
        let tabbarItems: [TabItem] = [.home, .news, .audio, .graph, .settings]
        
        setupCustomTabMenu(tabbarItems) { [weak self] viewControllers in
            guard let self = self else {return}
            
            self.viewControllers = viewControllers
            
        }
        
    }
    
    func setupCustomTabMenu(_ menuItems: [TabItem], completion: @escaping ([UIViewController]) -> Void) {
        
        let frame = tabBar.frame
        var controllers = [UIViewController]()
        
        tabBar.isHidden = true
        
        let customTabBar = CustomTabBar(menuItems: menuItems, frame: frame)
        self.customTabBar = customTabBar
        
        customTabBar.clipsToBounds = true
        customTabBar.itemTapped = changeTab(tab:)
        
        view.backgroundColor = .clear
        view.addSubview(customTabBar)
        customTabBar.snp.makeConstraints{ make in
            
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(tabBarHeight)
            
        }
        
        menuItems.forEach{controllers.append($0.viewController)}
        
        view.layoutIfNeeded()
        completion(controllers)
        
    }

    func changeTab(tab: Int) {
        
        self.selectedIndex = tab
        
    }
 
}

