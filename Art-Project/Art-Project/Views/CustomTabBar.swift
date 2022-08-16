//
//  CustomTabBar.swift
//  TableGit
//
//  Created by MINERVA on 21/07/2022.
//

import UIKit

class CustomTabBar: UIView {
    //MARK: Properties
    var itemTapped: ((_ tab: Int) -> Void)?
    var activeItem: Int = 0
    private var imageArray = [UIImageView]()
    
    private var waveSubLayer = CAShapeLayer()
    private let duration = 0.4
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(menuItems: [TabItem], frame: CGRect) {
        self.init(frame: frame)
                
        for index in 0..<menuItems.count {
            
            let itemWidth = frame.width / CGFloat(menuItems.count)
            let offsetX = itemWidth * CGFloat(index)
            
            let itemView = createTabItem(item: menuItems[index])
            itemView.clipsToBounds = true
            itemView.tag = index
            
            addSubview(itemView)
            itemView.snp.makeConstraints{ make in
                
                make.width.equalTo(itemWidth)
                make.height.equalToSuperview()
                make.leading.equalToSuperview().offset(offsetX)
                make.top.equalToSuperview()
                
            }
            
        }
        
        setNeedsLayout()
        layoutIfNeeded()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupInitialLayer(tab: 0)
        
    }
    
    //MARK: Actions
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        guard let toTag = sender.view?.tag else {return}
        
        switchTab(from: activeItem, to: toTag)
        
    }
    
    //MARK: Helpers
    func createTabItem(item: TabItem) -> UIView {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        let tabBarItem = UIView()
        tabBarItem.layer.backgroundColor = UIColor.clear.cgColor
        tabBarItem.clipsToBounds = true
        tabBarItem.addGestureRecognizer(tap)
        
        let itemTitleLabel = UILabel()
        itemTitleLabel.text = item.displayTitle
        itemTitleLabel.textAlignment = .center
        itemTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        itemTitleLabel.textColor = .darkText
        
        let itemImageView = UIImageView()
        itemImageView.image = item.icon?.withRenderingMode(.automatic)
        itemImageView.clipsToBounds = true
        itemImageView.contentMode = .scaleAspectFit
        self.imageArray.append(itemImageView)

        tabBarItem.addSubview(itemTitleLabel)
        tabBarItem.addSubview(itemImageView)
        
        itemImageView.snp.makeConstraints{ make in
            
            make.height.width.equalTo(36)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(12)
            
        }
        
        itemTitleLabel.snp.makeConstraints{ make in
            
            make.top.equalTo(itemImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.greaterThanOrEqualToSuperview().inset(8)
            
        }
        
        return tabBarItem
        
    }
    
    func switchTab(from: Int, to: Int) {
        
        guard from != to else {return}
        
        DispatchQueue.main.async {[weak self] in
            guard let self = self else {return}
            
            UIView.animate(withDuration: self.duration, delay: 0.0, options: [.curveEaseInOut]) {
                
                self.moveCurve(to: to)
                self.highlightImageView(iv: self.imageArray[to])
                self.turnOffHighlightImageView(iv: self.imageArray[from])
                
            } completion: { _ in
                
                self.itemTapped?(to)
                self.activeItem = to
                
            }
            
        }
        
    }
    
    private func setupInitialLayer(tab: Int) {
        
        let tabToActive = subviews[tab]
        let imageToActive = self.imageArray[tab]
        
        self.waveSubLayer.name = "Active Border"
        self.waveSubLayer.path = createCurve(at: tabToActive.center.x, radius: 30, on: self).cgPath
        self.waveSubLayer.fillColor = #colorLiteral(red: 0.9823524356, green: 0.7392255664, blue: 0.4647747874, alpha: 1).cgColor
        self.layer.insertSublayer(self.waveSubLayer, at: 0)
        
        highlightImageView(iv: imageToActive)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
    }
    
    func moveCurve(to index: Int) {
        
        let endPath = createCurve(at: self.subviews[index].center.x, radius: 30, on: self)
        
        CATransaction.begin()
        CATransaction.setCompletionBlock { [weak self] in
            guard let self = self else {return}
            
            self.waveSubLayer.path = endPath.cgPath
            
        }
        
        let pathAnimation = CABasicAnimation(keyPath: "path")
        
        pathAnimation.fromValue = waveSubLayer.path
        pathAnimation.toValue = endPath.cgPath
        pathAnimation.duration = duration
        pathAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pathAnimation.isRemovedOnCompletion = false
        pathAnimation.fillMode = CAMediaTimingFillMode.forwards
        waveSubLayer.add(pathAnimation, forKey: "pathAnimation")
        
        CATransaction.commit()
        
    }
    
    func createCurve(at center: CGFloat, radius curve: CGFloat, on tabBar: UIView) -> UIBezierPath {
        
        let path = UIBezierPath()
        let offsetY = 10.0
        
        path.move(to: .init(x: 0, y: offsetY))
        path.addLine(to: CGPoint(x: center - (curve * 2), y: offsetY))
        path.addQuadCurve(to: CGPoint(x: center - curve, y: curve / 2 + offsetY), controlPoint: CGPoint(x: center - curve - curve / 7.5, y: offsetY))
        path.addCurve(to: CGPoint(x: center + curve, y: curve / 2 + offsetY),
                      controlPoint1: CGPoint(x: center - curve + curve / 4, y: curve + curve / 2 + offsetY),
                      controlPoint2: CGPoint(x: center + curve - curve / 4, y: curve + curve / 2 + offsetY))
        path.addQuadCurve(to: CGPoint(x: center + (curve * 2), y: offsetY), controlPoint: CGPoint(x: center + curve + curve / 7.5, y: offsetY))
        path.addLine(to: CGPoint(x: tabBar.bounds.width, y: offsetY))
        path.addLine(to: CGPoint(x: tabBar.bounds.width, y: tabBar.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: tabBar.bounds.height))
        path.close()
        
        return path
        
    }
    
    private func highlightImageView(iv: UIImageView) {
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseInOut]) {
            
            iv.transform = CGAffineTransform.init(translationX: 0, y: -10)
            iv.layer.cornerRadius = iv.frame.width / 2
            iv.layer.backgroundColor = #colorLiteral(red: 0.400059551, green: 0.6795784831, blue: 0.3747661114, alpha: 1).cgColor
            iv.layer.borderColor = #colorLiteral(red: 0.2170224165, green: 0.6795784831, blue: 0.1666197622, alpha: 1).cgColor
            iv.layer.borderWidth = 1
            
        }
        
    }
    
    private func turnOffHighlightImageView(iv: UIImageView) {
        
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut]) {
            
            iv.transform = .identity
            iv.layer.cornerRadius = 0
            iv.layer.backgroundColor = UIColor.clear.cgColor
            iv.layer.borderColor = UIColor.clear.cgColor
            iv.layer.borderWidth = 0
            
        }
        
    }
    
    
}
