//
//  DragFileView.swift
//  IconBuilder
//
//  Created by Andrei Vidrasco on 11/10/15.
//  Copyright © 2015 Andrei Vidrasco. All rights reserved.
//

import Foundation
import Cocoa

protocol DragViewResponseDelegate {
    func didFetchURL(view: DragFileView, fileURL: NSURL);
}

extension NSString {
    class func projectBundleTypeIdentifier(type: String) -> String {
        return preferredTypeIdentifierForFileExtension(type)
    }
    
    class func preferredTypeIdentifierForFileExtension(string: String) -> String {
        return UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, string as CFStringRef, nil)!.takeRetainedValue() as String
    }
}

extension NSPasteboard {
    func canReadXcodeProjectFileURL(type: String) -> Bool {
        let classArray : Array<AnyClass> = [NSURL.self]

        return canReadObjectForClasses(classArray, options: [NSPasteboardURLReadingFileURLsOnlyKey: NSNumber(bool: true),
            NSPasteboardURLReadingContentsConformToTypesKey: [NSString.projectBundleTypeIdentifier(type)]])
    }
    
    func readXcodeProjectFileURL(type: String) -> NSURL {
        let classArray : Array<AnyClass> = [NSURL.self]

        let objects = readObjectsForClasses(classArray, options: [NSPasteboardURLReadingFileURLsOnlyKey: true,
            NSPasteboardURLReadingContentsConformToTypesKey: [NSString.projectBundleTypeIdentifier(type)]])
        
        return objects?.first as! NSURL
        
    }
}

class DragFileView: NSView {
    var fileURL: NSURL?
    var delegate: DragViewResponseDelegate?
    var type = "xcodeproj"
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    
    func commonInit() {
        wantsLayer = true
        setHighlight(false)
        layer?.cornerRadius = 20.0
        registerForDraggedTypes([kUTTypeFileURL as String])
    }
    
    
    override func draggingEntered(sender: NSDraggingInfo) -> NSDragOperation {
        let canRead = sender.draggingPasteboard().canReadXcodeProjectFileURL(type)
        if canRead {
            setHighlight(true)
            return .Generic
        } else {
            return .None
        }
        
    }
    func setHighlight(flag: Bool) {
        if flag {
            layer?.backgroundColor = NSColor(calibratedRed: 0.56, green: 0.7, blue: 0.81, alpha: 1).CGColor
        } else {
            layer?.backgroundColor = NSColor(calibratedRed: 0.7, green: 0.85, blue: 1.0, alpha: 1).CGColor
        }
    }
    
    
    override func draggingExited(sender: NSDraggingInfo?) {
        setHighlight(false)
    }
    
    
    override func prepareForDragOperation(sender: NSDraggingInfo) -> Bool {
        return sender.draggingPasteboard().canReadXcodeProjectFileURL(type)
    }
    
    
    override func performDragOperation(sender: NSDraggingInfo) -> Bool {
        fileURL = sender.draggingPasteboard().readXcodeProjectFileURL(type)
        
        return fileURL != nil
    }
    
    
    override func concludeDragOperation(sender: NSDraggingInfo?) {
        setHighlight(false)
        if let fileURL = fileURL {
            delegate?.didFetchURL(self, fileURL: fileURL)
        }
    }
}