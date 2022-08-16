//
//  BaseTabBarController.swift
//  TableGit
//
//  Created by MINERVA on 21/07/2022.
//

import UIKit

enum TabItem: String, CaseIterable {
    case home
    case news
    case audio
    case graph
    case settings
    
    var rawValue: String {
        get {
            switch self {
            case .home:
                return LocalizableManager.getLocalizableString(key: .text_home)
                
            case .news:
                return LocalizableManager.getLocalizableString(key: .text_news)
                
            case .audio:
                return LocalizableManager.getLocalizableString(key: .text_audio)
                
            case .graph:
                return LocalizableManager.getLocalizableString(key: .text_graph)
                
            case .settings:
                return LocalizableManager.getLocalizableString(key: .text_settings)
                
            }
        }
    }

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
    private var tabbarItems = [TabItem]()
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadTabBar()
        self.observeLanguagesChange()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(LocalizableManager.LCLLanguageChangeNotification), object: nil)
    }
    
    //MARK: Helpers
    func loadTabBar() {
                
        let tabbarItems: [TabItem] = [.home, .news, .audio, .graph, .settings]
        self.tabbarItems = tabbarItems
        
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

//MARK: Languages changes
extension BaseTabBarController {
    private func observeLanguagesChange() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.translateLanguagesInBaseTabBarController), name: Notification.Name(LocalizableManager.LCLLanguageChangeNotification), object: nil)
        
    }
    
    @objc private func translateLanguagesInBaseTabBarController() {
        
        self.customTabBar?.translateNameForTabItemLabel(items: self.tabbarItems)
                
    }
    
}

