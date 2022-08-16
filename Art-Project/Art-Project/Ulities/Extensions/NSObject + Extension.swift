//
//  NSObject + Extension.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 22/06/2022.
//

import UIKit

extension NSObject {
    public var className: String {
        return type(of: self).className
    }

    public static var className: String {
        return String.className(aClass: self)
    }
    
}
