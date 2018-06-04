//
//  PlayerDetailViewExtension.swift
//  Podcast
//
//  Created by ashim Dahal on 6/3/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import UIKit

extension PlayerDetailView {
    
    @objc func handlePan(gesture : UIPanGestureRecognizer){
        
        if gesture.state == .changed {
            handlePanChange(gesture)
        }else if gesture.state == .ended {
            handlePanEnded(gesture)
        }
    }
 
     fileprivate func handlePanEnded(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        let velocity = gesture.velocity(in: self.superview)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.transform = .identity
            if translation.y < -200 || velocity.y < -800 {
                
                UIApplication.mainTabBarController()?.maximizePlayerDetails(epishod: nil)
               
            }else {
                
                self.miniPlayerView.alpha = 1
                self.maximizedStackView.alpha = 0
            }
        })
    }
  
   fileprivate func handlePanChange(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self.superview)
        self.transform = CGAffineTransform(translationX: 0, y: translation.y)
        self.miniPlayerView.alpha = 1 + translation.y / 200
        self.maximizedStackView.alpha = -translation.y / 200
    }
    
    
    @objc func handleTapMaximize(){
        
     UIApplication.mainTabBarController()?.minimizePlayerDetails()
       
    }
    
}
