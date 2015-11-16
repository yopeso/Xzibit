//
//  PBXProjEditor.swift
//  IconBuilder
//
//  Created by Andrei Vidrasco on 11/12/15.
//  Copyright © 2015 Andrei Vidrasco. All rights reserved.
//

import Foundation

class PBXProjEditor {
    func iconSetNameForConfigName(configName: String, list: Array<Configuration>) -> String {
        let filter = list.filter {
            return $0.configurationName == configName
        }
        if let first = filter.first {
            return first.title
        } else {
            return ""
        }
    }
    
    func isProductApplicationByType(productType: String) -> Bool {
        return productType == "com.apple.product-type.application"
    }
    
    func parseTarget(target: String, objects: AnyObject, list: Array<Configuration>) {
        if let configurationList = objects.objectForKey(target),
            buildConfigurationList = configurationList["buildConfigurationList"] as? String,
            buildConfigurations = objects[buildConfigurationList]!!["buildConfigurations"] as? Array<String>,
            productType = configurationList["productType"] as? String where isProductApplicationByType(productType) {
            for buildConfiguration in buildConfigurations {
                if let config = objects.objectForKey(buildConfiguration),
                    buildSettings = config["buildSettings"] as? NSMutableDictionary,
                    name = config["name"] as? String {
                        buildSettings["ASSETCATALOG_COMPILER_APPICON_NAME"] = "AppIcon-" + self.iconSetNameForConfigName(name, list: list)
                }
            }
        }
    }
    
    func appendConfigurationNameForAllAppIconSet(projectURL: String, list: Array<Configuration>) {
        let fileData = NSData(contentsOfFile:projectURL)
        if let fileData = fileData {
            do {
                let projectPlist = try NSPropertyListSerialization.propertyListWithData(fileData, options:.Immutable, format: nil)
                let plist = projectPlist
                if let objects = projectPlist.objectForKey("objects"),
                    rootObjectKey = projectPlist["rootObject"] as? String,
                    rootObject = objects.objectForKey(rootObjectKey),
                    targets = rootObject["targets"] as? Array<String> {
                        for target in targets {
                            parseTarget(target, objects: objects, list: list)
                        }
                        let projectData = try NSPropertyListSerialization.dataWithPropertyList(plist, format: .XMLFormat_v1_0, options:0)
                        projectData.writeToFile(projectURL, atomically: true)
                }
            } catch {
                
            }
        }
    }
}