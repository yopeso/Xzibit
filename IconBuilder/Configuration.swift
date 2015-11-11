//
//  Configuration.swift
//  IconBuilder
//
//  Created by Andrei Vidrasco on 11/11/15.
//  Copyright © 2015 Andrei Vidrasco. All rights reserved.
//

import Foundation

class Configuration {
    var enable: Bool = true;
    var configurationName: String
    var title: String
    var ribbonColor: String = "red"
    var textColor: String = "yellow"
    
    init(configurationName: String) {
        self.configurationName = configurationName
        title = configurationName
    }
    
}