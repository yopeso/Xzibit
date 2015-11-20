//
//  main.swift
//  Xzibit
//
//  Created by Dan Ursu on 16/11/15.
//  Copyright © 2015 Dan Ursu. All rights reserved.
//

import Foundation
let defaultYamlPath = NSBundle.mainBundle().executablePath! + "configuration.yaml"

var fileURL:NSURL?
var imageURL: String?

switch Process.arguments[1] {
case "init":
    let projectURL = NSURL(fileURLWithPath:Process.arguments[2])
    let (configurationStrings, _) = extractConfigFromProject(projectURL)
    let configurations = configurationStrings.map { identifier -> Configuration in
        return Configuration(configurationName: identifier)
    }
    do {
        try YamlHandler.createYamlFileAtPath(defaultYamlPath, configurations: configurations)
        print("Succesfully created configuration file at \(defaultYamlPath)")
    } catch {
        print("Couldnt create default yaml file")
    }
    
case "generate":
    if let configurations = YamlHandler.configurationsFromFileAtPath(defaultYamlPath) {
        let projectURL = NSURL(fileURLWithPath:Process.arguments[2])
        let imageURL = Process.arguments[3]
        let (_, pbxProjURL) = extractConfigFromProject(projectURL)
        IconsCreator().createImages(configurations, imagepath: imageURL, projectURL: pbxProjURL)
        print("Succesfully tagged app icons")
    } else {
        print("Couldnt read default yaml file")
    }
    
default:
    print("Invalid arguments. First call ./Xzibit init projectPath then call ./Xzibit generate projectPath appIcon");
}


if let
    fileURL = fileURL,
    imageURL = imageURL
{
    let (configuration, pbxProjURL) = extractConfigFromProject(fileURL)
    let configurations = configuration.map { identifier -> Configuration in
        return Configuration(configurationName: identifier)
    }
    
    IconsCreator().createImages(configurations, imagepath: imageURL, projectURL: pbxProjURL)
    
}
