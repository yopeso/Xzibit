//
//  IconsCreator.swift
//  IconBuilder
//
//  Created by Andrei Vidrasco on 11/11/15.
//  Copyright © 2015 Andrei Vidrasco. All rights reserved.
//

import Foundation

class IconsCreator {
    var resultsPath: String = ""
    var projectPath: NSString = ""
    
    func createContectJsonInEachAppIconset(resultsPath: String) {
        do {
            let contents = try NSFileManager.defaultManager().subpathsOfDirectoryAtPath(resultsPath)
            for content in contents {
                if content.containsString("png") {
                    continue
                }
                let fileName = "Contents.json"
                let fullPathToFile = NSBundle.mainBundle().pathForResource(fileName, ofType: "")!
                let newPath = "\(resultsPath)/\(content)/\(fileName)"
                try NSFileManager.defaultManager().copyItemAtPath(fullPathToFile, toPath:  newPath)
            }
        } catch {
            
        }
    }
    
    
    func extractImageAssetsPathFromPbxprojURL(pbxprojURL: NSString) -> String? {
        let xcodeProjURL = pbxprojURL.stringByDeletingLastPathComponent as NSString
        let projectFolderURL = xcodeProjURL.stringByDeletingLastPathComponent
        let dirFiles = NSFileManager.defaultManager().subpathsAtPath(projectFolderURL)! as Array
        
        let assetsFiles = dirFiles.filter {
            return $0.hasSuffix(".xcassets")
        }
        if assetsFiles.count > 0 {
            return projectFolderURL + "/" + assetsFiles.first!
        } else {
            return nil
        }
    }
    
    
    func moveContentOfResultsFolderToAssets() {
        do {
            let contents = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(resultsPath)
            let projectAssetsPath = extractImageAssetsPathFromPbxprojURL(projectPath)
            if let projectAssetsPath = projectAssetsPath {
                for content in contents {
                    let fullPath = resultsPath + "/" + content
                    let newPath = projectAssetsPath + "/" + content
                    do {
                        try NSFileManager.defaultManager().removeItemAtPath(newPath)
                    } catch {
                        
                    }
                    try NSFileManager.defaultManager().moveItemAtPath(fullPath, toPath: newPath)
                }
            }
        } catch {
            
        }
    }
    
    
    func deleteTemporaryFolder() {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(resultsPath)
        } catch {
            
        }
    }
    
    func closure(task: NSTask) {
        createContectJsonInEachAppIconset(resultsPath)
        moveContentOfResultsFolderToAssets()
        deleteTemporaryFolder()
    }
    
    
    func createImages(list: Array<Configuration>, imagepath: String, projectURL: String) {
        projectPath = projectURL as NSString
        let shURL = NSBundle.mainBundle().URLForResource("create", withExtension: "sh")
        let shPath = shURL?.URLByDeletingLastPathComponent?.path
        resultsPath = shPath! + "/results"
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(resultsPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            
        }
        
        for index in 0..<list.count {
            let config = list[index]
            if !config.enable {
                config.ribbonColor = "transparent"
                config.textColor = "transparent"
            }
            let task = NSTask()
            task.launchPath = "/bin/sh"
            task.arguments = [NSBundle.mainBundle().pathForResource("create", ofType: "sh")!, imagepath, config.title, config.ribbonColor, config.textColor, resultsPath]
            if index == list.count - 1 {
                task.terminationHandler = self.closure
            }
            task.launch()
        }
        PBXProjEditor().appendConfigurationNameForAllAppIconSet(projectURL, list: list)
        
    }
    
}