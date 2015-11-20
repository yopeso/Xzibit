//
//  YamlHandler.swift
//  IconBuilder
//
//  Created by Dan Ursu on 20/11/15.
//  Copyright © 2015 Andrei Vidrasco. All rights reserved.
//

import Foundation

class YamlHandler {
    
    class func configurationsFromFileAtPath(path: String) -> [Configuration]? {
        guard let contentsOfFile = fileContentsAtPath(path) else { return nil }
        let configurationStrings = contentsOfFile.componentsSeparatedByString("\n")
        
        return configurationStrings.flatMap({ (configurationString) -> Configuration? in
            return Configuration(dataString:configurationString)
        })
    }
    
    
    class func createYamlFileAtPath(path: String, configurations: Array<Configuration>) throws {
        let configurationString = stringForAllConfigurations(configurations)
        try configurationString.writeToFile(path.stringByExpandingTildeInPath(), atomically: true, encoding: NSUTF8StringEncoding)
    }
    
    
    class func stringForAllConfigurations(configurations: Array<Configuration>) -> String {
        return configurations.reduce("") { (wholeString, configuration) -> String in
            return  wholeString + configuration.stringRepresentation() + "\n"
        }
    }
    
    

    
    
}


func fileContentsAtPath(path: String) -> String? {
    let location = path.stringByExpandingTildeInPath()
    do {
        let fileContent = try NSString(contentsOfFile: location, encoding: NSUTF8StringEncoding)
        
        return fileContent as String
    } catch {
        return nil
    }
}


extension String {
    func stringByExpandingTildeInPath() -> String {
        let expandedPath = (self as NSString).stringByExpandingTildeInPath
        return expandedPath as String
    }
}