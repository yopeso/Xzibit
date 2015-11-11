//
//  IconsCreator.swift
//  IconBuilder
//
//  Created by Andrei Vidrasco on 11/11/15.
//  Copyright © 2015 Andrei Vidrasco. All rights reserved.
//

import Foundation

class IconsCreator {
    func createImages(list: Array<Configuration>, imagepath: String) {
        let task = NSTask()
        task.launchPath = "/bin/sh"
        task.arguments = [NSBundle.mainBundle().pathForResource("create", ofType: "sh")!, imagepath, "Alpha", "Arial", "red", "blue"]
        let pipe = NSPipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = NSString(data: data, encoding: NSUTF8StringEncoding)
        
        print(output)
    }
}