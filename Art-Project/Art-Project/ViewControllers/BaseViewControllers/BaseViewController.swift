//
//  BaseViewController.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 16/07/2022.
//

import UIKit

class BaseViewController: UIViewController {
    //MARK: Properties
    private let headerView: UIView = {
        let view = UIView()
        return view
    }()
    
    private let hHeaderStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .center
        return stack
    }()
    
    let networkMonitor = NetworkMonitor.shared
    var observations = [NSKeyValueObservation]()
    
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
    var hideTabBarController: Bool?
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        observeVM()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationStyle()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupVM()
        observeTimer()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        hHeaderStackView.subviews.forEach{$0.removeFromSuperview()}
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
    @objc func handleEventFromLeftNavigationItem(_ sender: UIButton) {
                
    }
    
    @objc func handleEventFromRightNavigationItem(_ sender: UIButton) {
        
    }
    
    //MARK: Helpers
    func setupUI() {
    
        view.backgroundColor = .white
        
    }
    
    func setupNavigationStyle() {
        
        guard let navigationController = self.navigationController else {return}
        
        navigationController.navigationBar.addSubview(headerView)
        headerView.snp.makeConstraints{ make in
            
            make.edges.equalToSuperview()
            
        }
        
        headerView.addSubview(hHeaderStackView)
        hHeaderStackView.snp.makeConstraints{ make in
            
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
        
    }
    
    func observeVM() {}
    
    func setupVM() {}
    
    func openSideBar() {
        
        let targetVC = SideBarViewController()
        
        slideInTransitioningDelegate.direction = .left
        targetVC.transitioningDelegate = slideInTransitioningDelegate
        targetVC.modalPresentationStyle = .custom
        targetVC.delegate = self
        
        self.present(targetVC, animated: true, completion: nil)
        
    }
    
    private func observeTimer() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("SessionTimer"), object: nil)
        
    }
    
    @objc private func methodOfReceivedNotification(notification: NotificationCenter) {
        
        AppDelegate.switchToLoginViewController()

    }
    
    private func hideBottomTabBarController() {
        
        guard let tabs = self.tabBarController as? BaseTabBarController, let hideTabBarController = hideTabBarController else {return}
        
        tabs.customTabBar?.isHidden = hideTabBarController
        self.hideTabBarController = nil
        
    }

}

//MARK: Functions used for navigation bar
extension BaseViewController {
    
    func constraintHeaderStack(accordingTo cases: BasicNavigationBarStyles) {
                
        switch cases {
        case .noHeader:
            break
            
        case .aLeftItem(let leftItem), .twoLeftItems(let leftItem):
            let spacer = UIView()
            
            hHeaderStackView.addArrangedSubview(leftItem)
            hHeaderStackView.addArrangedSubview(spacer)
            
            spacer.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
            spacer.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
            
            break
            
        case .aLeftItem_title(let leftItem, let title), .twoLeftItems_title(let leftItem, let title):
            let rightSpace = UIView()
            
            leftItem.setContentHuggingPriority(.required, for: .horizontal)
            
            hHeaderStackView.addArrangedSubview(leftItem)
            hHeaderStackView.addArrangedSubview(title)
            hHeaderStackView.addArrangedSubview(rightSpace)
            
            rightSpace.snp.makeConstraints { make in
                
                make.width.equalTo(leftItem.snp.width)
                
            }
            
            break
            
        case .aLeftItem_title_aRightItem(let leftItem, let title, let rightItem),
                .aLeftItem_title_TwoRightItems(let leftItem, let title, let rightItem),
                .aLeftItem_title_ThreeRightItems(let leftItem, let title, let rightItem),
                .twoLeftItems_title_aRightItem(let leftItem, let title, let rightItem),
                .twoLeftItems_title_TwoRightItem(let leftItem, let title, let rightItem),
                .twoLeftItems_title_ThreeRightItem(let leftItem, let title, let rightItem):
            let leftSpace = UIView()
            let rightSpace = UIView()
            
            let leftStack = UIStackView(arrangedSubviews: [leftItem, leftSpace])
            leftStack.axis = .horizontal
            
            leftItem.setContentHuggingPriority(.required, for: .horizontal)
            leftSpace.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
            leftSpace.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
            
            let rightStack = UIStackView(arrangedSubviews: [rightSpace, rightItem])
            rightStack.axis = .horizontal
            
            rightItem.setContentHuggingPriority(.required, for: .horizontal)
            rightSpace.setContentHuggingPriority(.fittingSizeLevel, for: .horizontal)
            rightSpace.setContentCompressionResistancePriority(.fittingSizeLevel, for: .horizontal)
            
            hHeaderStackView.addArrangedSubview(leftStack)
            hHeaderStackView.addArrangedSubview(title)
            hHeaderStackView.addArrangedSubview(rightStack)
            
            leftStack.snp.makeConstraints{ make in
                
                make.width.equalTo(rightStack.snp.width)
                
            }
            
            title.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            
            break
            
        case .title_aRightItem(title: let title, rightItem: let rightItem),
                .title_TwoRightItems(title: let title, rightItem: let rightItem),
                .title_ThreeRightItems(title: let title, rightItem: let rightItem) :
            let leftSpace = UIView()
            
            rightItem.setContentHuggingPriority(.required, for: .horizontal)
            
            hHeaderStackView.addArrangedSubview(leftSpace)
            hHeaderStackView.addArrangedSubview(title)
            hHeaderStackView.addArrangedSubview(rightItem)
            
            leftSpace.snp.makeConstraints{ make in
                
                make.width.equalTo(rightItem.snp.width)
                
            }
            
            break
        }
        
    }
    
    func setupUIForLeftItem(leftItemInfo: NavigationIcons, tag: Int = 0) -> UIView {
        
        let leftItem = UIButton()
        leftItem.addTarget(self, action: #selector(handleEventFromLeftNavigationItem(_:)), for: .allEvents)
        leftItem.setImage(leftItemInfo.icon?.resize(targetSize: .init(width: 40, height: 40)), for: .normal)
        leftItem.setTitle(leftItemInfo.additionalTitle, for: .normal)
        leftItem.setTitleColor(UIColor.systemRed, for: .normal)
        leftItem.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        leftItem.tag = tag
        
        return leftItem
        
    }
    
    func setupUIForTitle(titleName: NavigationTitles? = nil, attribuedTitle: NSMutableAttributedString? = nil) -> UIView {
        
        let title = UILabel()
        title.textAlignment = .center
        title.numberOfLines = 0
        
        if let attribuedTitle = attribuedTitle {
            
            title.attributedText = attribuedTitle
            return title
            
        } else {
            
            title.text = titleName?.rawValue
            title.font = UIFont.boldSystemFont(ofSize: 18)
            return title
            
        }
        
    }
    
    func setupUIForRightItem(rightItemInfo: NavigationIcons, tag: Int = 0) -> UIView {
        
        let rightItem = UIButton()
        rightItem.addTarget(self, action: #selector(handleEventFromRightNavigationItem(_:)), for: .allEvents)
        rightItem.setImage(rightItemInfo.icon?.resize(targetSize: .init(width: 40, height: 40)), for: .normal)
        rightItem.setTitle(rightItemInfo.additionalTitle, for: .normal)
        rightItem.setTitleColor(UIColor.systemRed, for: .normal)
        rightItem.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return rightItem
        
    }
    
    func setupStackForItems(views: [UIView]) -> UIView {
        
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        
        return stackView
        
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
