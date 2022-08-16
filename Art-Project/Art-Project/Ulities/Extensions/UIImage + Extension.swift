//
//  UIImage + Extension.swift
//  TableGit
//
//  Created by MINERVA on 01/07/2022.
//

import UIKit

extension UIImage {
    
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
    func rotate(radians: CGFloat) -> UIImage {
        
        let transform = CGAffineTransform(rotationAngle: radians)
        let rotatedSize = CGRect(origin: .zero, size: size).applying(transform).integral.size
        
        UIGraphicsBeginImageContextWithOptions(rotatedSize, false, 0)
        
        guard let context = UIGraphicsGetCurrentContext() else {return self}
        let origin = CGPoint(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        
        context.translateBy(x: origin.x, y: origin.y)
        context.rotate(by: radians)
        
        let rect = CGRect(x: -origin.y, y: -origin.x, width: size.width, height: size.height)
        draw(in: rect)
        
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rotatedImage ?? self
        
    }
    
    class func delayForImageAtIndex(_ index: Int, source: CGImageSource) -> Double {
        var delay = 0.1
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        let gifProperties: CFDictionary = unsafeBitCast(
            CFDictionaryGetValue(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()),
            to: CFDictionary.self)
        
        var delayObject: AnyObject = unsafeBitCast(
            CFDictionaryGetValue(gifProperties,
                                 Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()),
            to: AnyObject.self)
        
        if delayObject.doubleValue == 0 {
            
            delayObject = unsafeBitCast(
                CFDictionaryGetValue(gifProperties,
                                     Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()),
                to: AnyObject.self)
            
        }
        
        delay = delayObject as! Double
        
        if delay < 0.1 {
            
            delay = 0.1
            
        }
        
        return delay
        
    }
    
    class func gcdForPair(_ a: Int?, _ b: Int?) -> Int {
        var a = a
        var b = b
        if b == nil || a == nil {
            if b != nil {
                return b!
            } else if a != nil {
                return a!
            } else {
                return 0
            }
        }
        
        if a! < b! {
            let c = a
            a = b
            b = c
        }
        
        var rest: Int
        while true {
            rest = a! % b!
            
            if rest == 0 {
                return b!
            } else {
                a = b
                b = rest
            }
        }
    }
    
    class func gcdForArray(_ array: Array<Int>) -> Int {
        if array.isEmpty {
            return 1
        }
        
        var gcd = array[0]
        
        for val in array {
            gcd = UIImage.gcdForPair(val, gcd)
        }
        
        return gcd
    }
    
    class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        
        let count = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        for i in 0..<count {
            guard let image = CGImageSourceCreateImageAtIndex(source, i, nil) else {return nil}
            
            images.append(image)
            
            let delaySeconds = UIImage.delayForImageAtIndex(i, source: source)
            
            delays.append(Int(delaySeconds * 1000.0))
            
        }
        
        let duration: Int = {
            var sum = 0
            
            for val: Int in delays {
                
                sum += val
                
            }
            
            return sum
            
        }()
        
        let gcd = gcdForArray(delays)
        
        var frames = [UIImage]()
        var frame: UIImage
        var frameCount: Int
        for i in 0..<count {
            
            frame = UIImage(cgImage: images[i])
            frameCount = Int(delays[i] / gcd)
            
            for _ in 0..<frameCount {
                
                frames.append(frame)
                
            }
            
        }
        
        let animation = UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
        
        return animation
        
    }
    
    public class func gifImageWithData(_ data: Data) -> UIImage? {
        
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {return nil}
        
        return UIImage.animatedImageWithSource(source)
        
    }
    
    public class func gifImageWithName(_ name: String) -> UIImage? {
        
        guard let bundleURL = Bundle.main.url(forResource: name, withExtension: "gif") else {return nil}
        guard let imageData = try? Data(contentsOf: bundleURL) else {return nil}
        
        return gifImageWithData(imageData)
        
    }
    
}
