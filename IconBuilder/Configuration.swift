//
//  Configuration.swift
//  IconBuilder
//
//  Created by Andrei Vidrasco on 11/11/15.
//  Copyright © 2015 Andrei Vidrasco. All rights reserved.
//

import Foundation

struct Configuration: Equatable {
    static let defaultRibbonColor = "red"
    static let defaultTextCollor = "yellow"
    static let defaultEnableState = true
    var enable: Bool = defaultEnableState;
    var configurationName: String
    var title: String
    var ribbonColor: String = defaultRibbonColor
    var textColor: String = defaultTextCollor
    
    init(configurationName: String) {
        self.configurationName = configurationName
        title = configurationName
    }
    
     init?(dataString: String) {
        let values = dataString.componentsSeparatedByString(" ")
        if (values.count < 5)  { return nil }
        self.configurationName = values[0]
        self.title = values[1]
        self.ribbonColor = values[2]
        self.textColor = values[3]
        self.enable = NSString(string:values[4]).boolValue
    }
    
    func stringRepresentation() -> String {
        return "\(self.configurationName) \(self.title) \(self.ribbonColor) \(self.textColor) \(self.enable)"
    }
}

func ==(lhs: Configuration, rhs: Configuration) -> Bool {
    return lhs.title == rhs.title
        && lhs.configurationName == rhs.configurationName
        && lhs.enable == rhs.enable
        && lhs.ribbonColor == rhs.ribbonColor
        && lhs.textColor == rhs.textColor    
}