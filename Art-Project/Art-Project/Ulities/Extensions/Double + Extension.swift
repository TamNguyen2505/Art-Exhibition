//
//  Double + Extension.swift
//  TableGit
//
//  Created by MINERVA on 08/08/2022.
//

import Foundation

extension Double {
    
    func convertMilisecondToMinute() -> Double {
        
        return self / 60 / 1000
        
    }
    
    func convertMinuteToMilisecond() -> Double {
        
        return self*60*1000
        
    }
    
}
