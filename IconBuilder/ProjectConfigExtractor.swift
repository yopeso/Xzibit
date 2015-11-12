//
//  ProjectConfigExtractor.swift
//  IconBuilder
//
//  Created by Andrei Vidrasco on 11/10/15.
//  Copyright © 2015 Andrei Vidrasco. All rights reserved.
//

import Foundation

func getArrayWithConfigutations(let identifiers: Array<String>, source: NSDictionary) -> Array<Dictionary<String, AnyObject>> {
    let filtered = identifiers.map { identifier -> Dictionary<String, AnyObject> in
        return source[identifier] as! Dictionary<String, AnyObject>
    }
    
    return filtered
}


func buildSettingsByConfigurationForConfigurations(let configurations: Array<Dictionary<String, AnyObject>>) -> Array<String> {
    return configurations.map({ (projectBuildConfiguration: [String : AnyObject]) -> String in
        return projectBuildConfiguration["name"] as! String
    })
}


func extractConfigFromProject(projectWrapperURL: NSURL) -> (Array<String>, String) {
    let projectFileURL = projectWrapperURL.URLByAppendingPathComponent("project.pbxproj")
    let fileData = NSData(contentsOfURL: projectFileURL)
    if let fileData = fileData {
        do {
            
            let projectPlist = try NSPropertyListSerialization.propertyListWithData(fileData, options:.Immutable, format: nil)
            let objects = projectPlist.objectForKey("objects")
            if let objects = objects {
                let rootObjectKey = projectPlist["rootObject"] as? String
                if let rootObjectKey = rootObjectKey {
                    let rootObject = objects.objectForKey(rootObjectKey)
                    let buildConfigurationListID = rootObject?["buildConfigurationList"] as? String
                    if let buildConfigurationListID = buildConfigurationListID {
                        let buildConfigurationList = objects[buildConfigurationListID]
                        let identifiers = buildConfigurationList!!["buildConfigurations"] as! Array<String>
                        
                        let projectBuildConfiguration = getArrayWithConfigutations(identifiers, source: objects as! NSDictionary)
                        
                        return (buildSettingsByConfigurationForConfigurations(projectBuildConfiguration), projectFileURL.path!)
                    }
                }
            }
        } catch {
            
        }
    }
    
    return ([], "")
}