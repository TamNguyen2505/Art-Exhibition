//
//  Timer.swift
//  TableGit
//
//  Created by MINERVA on 18/07/2022.
//

import UIKit

public struct SessionTimer {
    //MARK: Properties
    public static let share = SessionTimer()
    public static var timer: Timer?
    public static var timeOut = false
    
    //MARK: Features
    public func setupTimer() {
        
        SessionTimer.timer?.invalidate()
        SessionTimer.timer = Timer.scheduledTimer(withTimeInterval: 5*60, repeats: false) { _ in
            
            postNotification()
            
        }
        
    }
    
    public func disableTimer() {
        
        SessionTimer.timer?.invalidate()
        
    }
    
    public func postNotification() {
        
        NotificationCenter.default.post(name: Notification.Name("SessionTimer"), object: nil)
        
    }
    
}
