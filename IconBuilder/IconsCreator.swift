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
    func closure(task: NSTask) {
        self.createContectJsonInEachAppIconset(resultsPath)
    }
    
    func createImages(list: Array<Configuration>, imagepath: String) {
        let shURL = NSBundle.mainBundle().URLForResource("create", withExtension: "sh")
        let shPath = shURL?.URLByDeletingLastPathComponent?.path
        resultsPath = shPath! + "/results"
        print(shPath)
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(resultsPath, withIntermediateDirectories: true, attributes: nil)
        } catch {
            
        }
        for config in list {
            if !config.enable {
                config.ribbonColor = "transparent"
                config.textColor = "transparent"
            }
            let task = NSTask()
            task.launchPath = "/bin/sh"
            task.arguments = [NSBundle.mainBundle().pathForResource("create", ofType: "sh")!, imagepath, config.title, "Arial", config.ribbonColor, config.textColor, resultsPath]
            task.terminationHandler = closure
            task.launch()
        }
        let task = NSTask()
        task.launchPath = "/usr/bin/open"
        task.arguments = [resultsPath]
        task.terminationHandler = closure
        task.launch()
    }
    
}