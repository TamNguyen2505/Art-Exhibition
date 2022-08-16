//
//  PublicFunction.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 22/06/2022.
//

import UIKit

public func durationMeasurement(_ block: () -> ()) {
    let startTime = CFAbsoluteTimeGetCurrent()
    block()
    print(CFAbsoluteTimeGetCurrent() - startTime)
}
