//
//  ExtensionString.swift
//  Podcast
//
//  Created by ashim Dahal on 5/22/18.
//  Copyright © 2018 ashim Dahal. All rights reserved.
//

import Foundation

extension String {
    
    func toSecureHTTPS() -> String {
        return self.contains("https") ? self : self.replacingOccurrences(of: "http", with: "https")
    }
}
