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

class BaseNavigationController: UINavigationController {
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
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        setupUI()
        
    }
    
    //MARK: Actions
    @objc func handleEventFromLeftItem(_ sender: UIButton) {
        
        self.popViewController(animated: true)
        
    }
    
    @objc func handleEventFromRightItem(_ sender: UIButton) {
        
    }
    
    //MARK: Helpers
    private func setupHeader(accordingTo viewController: UIViewController) {
        
        let viewControllerName = viewController.className
        
        hHeaderStackView.subviews.forEach{$0.removeFromSuperview()}
        
        if viewControllerName == SignUpViewController.className {
            
            let backButton = setupUIForLeftItem(leftImageName: "icons8-back")
            constraintHeaderStack(accordingTo: .aLeftItem(leftItem: backButton))
            
        }
        
        if viewControllerName == HomeViewController.className {
            
            let sideMenuButton = setupUIForLeftItem(leftImageName: "icons8-menu")
            let title = setupUIForTitle(attribuedTitle: createCommonAttributedString())
            let rightButton = setupUIForRightItem(rightImageName: "default-avatar")
            constraintHeaderStack(accordingTo: .aLeftItem_title_aRightItem(leftItem: sideMenuButton, title: title, rightItem: rightButton))
            
        }
        
        if viewControllerName == RecordInformationViewController.className {
            
            let backButton = setupUIForLeftItem(leftImageName: "icons8-back")
            let title = setupUIForTitle(titleName: "Artist Pictures")
            constraintHeaderStack(accordingTo: .aLeftItem_title(leftItem: backButton, title: title))
            
        }
        
        
    }
    
    private func setupUI() {
        
        self.navigationBar.addSubview(headerView)
        headerView.snp.makeConstraints{ make in
            
            make.edges.equalToSuperview()
            
        }
        
        headerView.addSubview(hHeaderStackView)
        hHeaderStackView.snp.makeConstraints{ make in
            
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
        
    }
    
    private func constraintHeaderStack(accordingTo cases: BasicNavigationBarStyles) {
        
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
    
    private func setupUIForLeftItem(leftImageName: String, leftTitle: String? = nil , tag: Int = 0) -> UIView {
        
        let leftItem = UIButton()
        leftItem.addTarget(self, action: #selector(handleEventFromLeftItem(_:)), for: .allEvents)
        leftItem.setImage(.init(named: leftImageName)?.resize(targetSize: .init(width: 40, height: 40)), for: .normal)
        leftItem.setTitle(leftTitle, for: .normal)
        leftItem.setTitleColor(UIColor.systemRed, for: .normal)
        leftItem.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        leftItem.tag = tag
        
        return leftItem
        
    }
    
    private func setupUIForTitle(titleName: String? = nil, attribuedTitle: NSMutableAttributedString? = nil) -> UIView {
        
        let title = UILabel()
        title.textAlignment = .center
        title.numberOfLines = 0
        
        if let attribuedTitle = attribuedTitle {
            
            title.attributedText = attribuedTitle
            return title
            
        } else {
            
            title.text = titleName
            title.font = UIFont.boldSystemFont(ofSize: 18)
            return title
            
        }
        
    }
    
    private func setupUIForRightItem(rightImageName: String, rightTitlte: String? = nil, tag: Int = 0) -> UIView {
        
        let rightItem = UIButton()
        rightItem.addTarget(self, action: #selector(handleEventFromRightItem(_:)), for: .allEvents)
        rightItem.setImage(.init(named: rightImageName)?.resize(targetSize: .init(width: 40, height: 40)), for: .normal)
        rightItem.setTitle(rightTitlte, for: .normal)
        rightItem.setTitleColor(UIColor.systemRed, for: .normal)
        rightItem.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return rightItem
        
    }
    
    private func setupStackForItems(views: [UIView]) -> UIView {
        
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        
        return stackView
        
    }
    
    private func createCommonAttributedString() -> NSMutableAttributedString {
        
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

extension BaseNavigationController: UINavigationControllerDelegate{
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        viewController.navigationItem.setHidesBackButton(true, animated: false)
        
        setupHeader(accordingTo: viewController)
        
    }
    
}
