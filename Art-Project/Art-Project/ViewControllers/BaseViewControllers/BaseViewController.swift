//
//  BaseViewController.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 16/07/2022.
//

import UIKit

class BaseViewController: UIViewController {
    //MARK: Properties
    let networkMonitor = NetworkMonitor.shared
    var observations = [NSKeyValueObservation]()

    enum HeaderType {
        
    case noHeader, headerWidthRightSlideBarAndMiddleTitleAndLeftAvatar, headerWidthRightSlideMenu, headerWithMiddleTitle
    
    }
    var headerType: HeaderType = .noHeader {
        didSet{
            setupUIForHeaderView()
        }
    }
    
    private lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
    var navigationTitle = ""
    var hideTabBarController: Bool?
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        observeVM()
        hideBottomTabBarController()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupUIForHeaderView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupVM()
        observeTimer()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hideBottomTabBarController()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        observations.removeAll()
        
    }
    
    deinit {
      NotificationCenter.default.removeObserver(self, name: Notification.Name("SessionTimer"), object: nil)
    }
    
    //MARK: Actions
    @objc func handleEventFromSideBar() {
        
        let targetVC = SideBarViewController()
        
        slideInTransitioningDelegate.direction = .left
        targetVC.transitioningDelegate = slideInTransitioningDelegate
        targetVC.modalPresentationStyle = .custom
        targetVC.delegate = self
        
        self.present(targetVC, animated: true, completion: nil)
        
    }
    
    //MARK: Helpers
    func setupUI() {
        
        view.backgroundColor = .white
        
    }
    
    func setupUIForHeaderView() {
        
        switch headerType {
            
        case .noHeader:
            break
            
        case .headerWidthRightSlideBarAndMiddleTitleAndLeftAvatar:
            setupUIForHeaderWidthRightSlideBarAndMiddleTitleAndLeftAvatar()
            break
            
        case .headerWidthRightSlideMenu:
            setupUIForHeaderWidthRightSlideMenu()
            break
            
        case .headerWithMiddleTitle:
            setupUIForHeaderWithMiddleTitle()
            break
            
        }
        
    }
    
    func observeVM() {}
    
    func setupVM() {}
    
    private func observeTimer() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("SessionTimer"), object: nil)
        
    }
    
    @objc private func methodOfReceivedNotification(notification: NotificationCenter) {
        
        AppDelegate.switchToLoginViewController()

    }
    
    private func hideBottomTabBarController() {
        
        guard let tabs = self.tabBarController as? BaseTabBarController, let hideTabBarController = hideTabBarController else {return}
        
        tabs.customTabBar?.isHidden = hideTabBarController
        self.hideTabBarController?.toggle()
        
    }

}

//MARK: Functions used for setupUIForHeaderView
extension BaseViewController {
    
    private func setupUIForHeaderWidthRightSlideBarAndMiddleTitleAndLeftAvatar() {
        
        setupUIForSlideBarImageView(onTheLeft: true)
        
        let titleNavigationLabel = UILabel()
        titleNavigationLabel.attributedText = createCommonAttributedString()
        titleNavigationLabel.textAlignment = .center
        titleNavigationLabel.numberOfLines = 0
        
        let avatarImageView = UIImageView()
        avatarImageView.image = UIImage(named: "default-avatar")?.resize(targetSize: .init(width: 40, height: 40))
        avatarImageView.contentMode = .scaleAspectFit
        
        self.navigationItem.titleView = titleNavigationLabel
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: avatarImageView)
        
    }
    
    private func setupUIForHeaderWidthRightSlideMenu() {
        
        setupUIForSlideBarImageView(onTheLeft: true)

        let titleNavigationLabel = UILabel()
        titleNavigationLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleNavigationLabel.textAlignment = .center
        titleNavigationLabel.text = navigationTitle
        
        self.navigationItem.titleView = titleNavigationLabel
                
    }
    
    private func setupUIForHeaderWithMiddleTitle() {
        
        let titleNavigationLabel = UILabel()
        titleNavigationLabel.attributedText = createCommonAttributedString()
        titleNavigationLabel.textAlignment = .center
        titleNavigationLabel.numberOfLines = 0
        
        self.navigationItem.titleView = titleNavigationLabel
        
    }
    
    //MARK: Reusable functions
    private func setupUIForSlideBarImageView(onTheLeft: Bool) {

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEventFromSideBar))
        
        let slideBarImageView = UIImageView()
        slideBarImageView.image = UIImage(named: "icons8-menu")?.resize(targetSize: .init(width: 40, height: 40))
        slideBarImageView.contentMode = .scaleAspectFit
        slideBarImageView.isUserInteractionEnabled = true
        slideBarImageView.addGestureRecognizer(tap)

        if onTheLeft {
            
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: slideBarImageView)
            
        } else {
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: slideBarImageView)
            
        }
        
        
    }
        
    func createCommonAttributedString() -> NSMutableAttributedString {
        
        let attributesLineOne: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14)]
        let lineOne = NSMutableAttributedString(string: "Welcome to\n", attributes: attributesLineOne)
        
        let attributesLineTwo: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 18),
                                                                .foregroundColor: UIColor.systemRed]
        let lineTwo = NSMutableAttributedString(string: "Art World", attributes: attributesLineTwo)
        
        let totalString: NSMutableAttributedString = lineOne
        totalString.append(lineTwo)
        
        return totalString
        
    }
    
}

//MARK: SideBarViewControllerDelegate
extension BaseViewController: SideBarViewControllerDelegate {
    
    func handleEventFromLogoutButton(from vc: SideBarViewController) {
        
        AppDelegate.switchToLoginViewController()
        
    }
    
}
