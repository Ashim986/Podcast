//
//  ExtensionCMTime.swift
//  Podcast
//
//  Created by ashim Dahal on 5/28/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import Foundation
import AVKit

extension CMTime{
    
    func toDisplayString()->String{
        
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"
        }
        
     let totalSeconds = Int(CMTimeGetSeconds(self))
        let seconds = totalSeconds % 60
        let minutes = totalSeconds / 60
        let hour = totalSeconds / 60 / 60
        if hour > 0 {
             let timeFormatString = String(format: "%02d:%02d:%02d",hour, minutes ,seconds)
             return timeFormatString
        }else {
            let timeFormatString = String(format: "%02d:%02d",minutes ,seconds)
            return timeFormatString
        }
        
        
       
    }
    
}
