//
//  ViewController.swift
//  IconBuilder
//
//  Created by Andrei Vidrasco on 11/10/15.
//  Copyright © 2015 Andrei Vidrasco. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate, DragViewResponseDelegate {
    
    @IBOutlet weak var tableView: NSTableView!
    var configurations: Array<Configuration>?
    @IBOutlet weak var dragView: DragFileView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dragView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    @IBAction func run(sender: AnyObject) {
        let path = NSBundle.mainBundle().pathForResource("create", ofType: "sh")
        let task = NSTask()
        task.launchPath = "/bin/sh"
        let newpath = path! + " Beta Arial red blue 150"
        let arguments = [newpath]
        task.arguments = arguments
        let pipe = NSPipe()
        task.standardOutput = pipe
        let file = pipe.fileHandleForReading
        task.launch()
        let data = file.readDataToEndOfFile()
        let string = String(data: data, encoding:NSUTF8StringEncoding)
        print(string)
    }
    
    func didFetchConfiguration(configuration: Array<String>) {
        
        configurations = configuration.map { identifier -> Configuration in
            return Configuration(configurationName: identifier)
        }
        
        tableView.reloadData();
    }
    
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        if let configurations = configurations {
            return configurations.count
        } else {
            return 0
        }
    }
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject? {
        if let identifier = tableColumn?.identifier {
            switch identifier {
            case "enable":
                let cell = NSButtonCell()
                cell.setButtonType(.SwitchButton)
                if configurations![row].enable {
                    cell.state = NSOnState;
                } else {
                    cell.state = NSOffState;
                }
                return cell
            case "configuration":
                let cell = NSTextFieldCell()
                cell.title = configurations![row].configurationName
                return cell
            case "title":
                let cell = NSTextFieldCell()
                cell.title = configurations![row].title
                return cell
            case "ribbonC":
                let cell = NSTextFieldCell()
                cell.title = configurations![row].ribbonColor
                return cell
            case "textC":
                let cell = NSTextFieldCell()
                cell.title = configurations![row].textColor
                return cell
            default:
                return nil
            }
        }
        return nil
    }
    func tableView(tableView: NSTableView, setObjectValue object: AnyObject?, forTableColumn tableColumn: NSTableColumn?, row: Int) {
        let config = configurations![row]
        if let identifier = tableColumn?.identifier {
            switch identifier {
            case "enable":
                config.enable = (object as? Bool)!
            case "configuration":
                break
            case "title":
                config.title = object as! String
            case "ribbonC":
                config.ribbonColor = object as! String
            case "textC":
                config.textColor = object as! String
            default:
                break
            }
        }
    }
}

