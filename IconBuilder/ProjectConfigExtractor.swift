//
//  ProjectConfigExtractor.swift
//  IconBuilder
//
//  Created by Andrei Vidrasco on 11/10/15.
//  Copyright © 2015 Andrei Vidrasco. All rights reserved.
//

import Foundation


func extractConfigFromProject(projectWrapperURL: NSURL) -> (Array<String>, String) {
    let pbxProjURL = projectWrapperURL.URLByAppendingPathComponent("project.pbxproj")
    guard let fileData = NSData(contentsOfURL: pbxProjURL), pbxProjPath = pbxProjURL.path else { return ([], "") }
    do {
        let projectPlist = try NSPropertyListSerialization.propertyListWithData(fileData, options:.Immutable, format: nil)
        return (configurationsFromPlist(projectPlist), pbxProjPath)
    } catch {
        return ([], "")
    }
}


func configurationsFromPlist(projectPlist: AnyObject) -> Array<String> {
    if let
        objects = projectPlist.objectForKey("objects"),
        rootObjectKey = projectPlist["rootObject"] as? String,
        rootObject = objects.objectForKey(rootObjectKey),
        buildConfigurationListID = rootObject["buildConfigurationList"] as? String
    {
           return configurationsFromDictionary(objects, buildConfigurationListID: buildConfigurationListID)
    }
    
    return []
}


func configurationsFromDictionary(objects: AnyObject, buildConfigurationListID: String) -> Array<String> {
    let buildConfigurationList = objects[buildConfigurationListID]
    let identifiers = buildConfigurationList!!["buildConfigurations"] as! Array<String>
    let projectBuildConfiguration = getArrayWithConfigutations(identifiers, source: objects as! NSDictionary)
    
    return buildSettingsByConfigurationForConfigurations(projectBuildConfiguration)
}


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