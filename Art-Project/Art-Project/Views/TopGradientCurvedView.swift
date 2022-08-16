//
//  TopGradientCurvedView.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 16/07/2022.
//

import UIKit

class TopGradientCurvedView: UIView {
    //MARK: Properties
    

    //MARK: View cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {return}
                
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        drawTopCurve(in: rect, context: context, colorSpace: colorSpace)
                
    }
    
    //MARK: Helpers
    private func setupUI() {
        
        backgroundColor = .white
        
    }
    
    private func drawTopCurve(in rect: CGRect, context: CGContext, colorSpace: CGColorSpace?) {
        
        context.saveGState()
        defer {context.restoreGState()}
        
        let baseColor = #colorLiteral(red: 0.9991063476, green: 0.4763298631, blue: 0.7005771995, alpha: 1)
        let middleStop = #colorLiteral(red: 0.9932780862, green: 0.7262821794, blue: 0.8526912332, alpha: 1)
        let farStop = #colorLiteral(red: 0.9823524356, green: 0.7392255664, blue: 0.4647747874, alpha: 1)
        
        let gradientColors = [baseColor.cgColor, middleStop.cgColor, farStop.cgColor]
        let locations: [CGFloat] = [0.0, 0.2, 0.5]
        
        guard let gradient = CGGradient(colorsSpace: colorSpace, colors: gradientColors as CFArray, locations: locations) else {return}
        
        let startPoint = CGPoint(x: rect.size.height / 2, y: 0)
        let endPoint = CGPoint(x: rect.size.height / 2, y: rect.size.width)
        
        let curvedEffect = CGMutablePath()
        
        curvedEffect.move(to: CGPoint(x: -5, y: rect.maxY - 50), transform: .identity)
        curvedEffect.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY - 50),
                                  control: CGPoint(x: rect.midX / 2, y: rect.maxY))
        curvedEffect.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY - 50),
                                  control: CGPoint(x: rect.midX + (rect.width / 4), y: rect.maxY))
        
        curvedEffect.closeSubpath()
        
        context.addRect(CGRect(x: 0, y: 0, width: rect.width, height: rect.maxY - 50))
        
        context.addPath(curvedEffect)
        context.clip()
        context.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: [])
        
        
    }
    

}
