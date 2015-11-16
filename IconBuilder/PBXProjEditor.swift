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
    
    func appendConfigurationNameForAllAppIconSet(projectURL: String, list: Array<Configuration>) {
        let fileData = NSData(contentsOfFile:projectURL)
        if let fileData = fileData {
            do {
                // This needs to be refactored. See ProjectConfigExtractor for an example.
                let projectPlist = try NSPropertyListSerialization.propertyListWithData(fileData, options:.Immutable, format: nil)
                let plist = projectPlist
                    let objects = projectPlist.objectForKey("objects")
                    if let objects = objects {
                        let rootObjectKey = projectPlist["rootObject"] as? String
                        if let rootObjectKey = rootObjectKey {
                            let rootObject = objects.objectForKey(rootObjectKey)
                            let targets = rootObject!["targets"] as? Array<String>
                            if let targets = targets {
                                for target in targets {
                                    let configurationList = objects[target]
                                    if let configurationList = configurationList {
                                        let productType = configurationList!["productType"] as! String
                                        if productType == "com.apple.product-type.application" {
                                            let buildConfigurationList = configurationList!["buildConfigurationList"] as! String
                                            let buildConfigurations = objects[buildConfigurationList]!!["buildConfigurations"] as! Array<String>
                                            for buildConfiguration in buildConfigurations {
                                                let config = objects[buildConfiguration]!
                                                let  buildSettings = config!["buildSettings"] as! NSMutableDictionary
                                                let name = config!["name"] as! String
                                                buildSettings["ASSETCATALOG_COMPILER_APPICON_NAME"] = "AppIcon-" + self.iconSetNameForConfigName(name, list: list)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        let projectData = try NSPropertyListSerialization.dataWithPropertyList(plist, format: .XMLFormat_v1_0, options:0)
                        projectData.writeToFile(projectURL, atomically: true)
                }
            } catch {
                
            }
        }
    }
}