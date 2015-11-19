//
//  main.swift
//  Xzibit
//
//  Created by Dan Ursu on 16/11/15.
//  Copyright © 2015 Dan Ursu. All rights reserved.
//

import Foundation
let fileURL:NSURL? = NSURL(fileURLWithPath: "/Users/danursu/Desktop/SchemaTestProject/SchemaTestProject.xcodeproj")
let imageURL: String? =  "/Users/danursu/Desktop/icon.png"



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






