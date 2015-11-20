//
//  YamlDefaultInitializer.swift
//  IconBuilder
//
//  Created by Dan Ursu on 20/11/15.
//  Copyright © 2015 Andrei Vidrasco. All rights reserved.
//

import XCTest

@testable import IconBuilder

class YamlDefaultInitializer: XCTestCase {

    func testYamlHandlerCreatesYamlFileWithAllSchemasAndColours() {
        let configurations = [Configuration(configurationName: "Alpha"), Configuration(configurationName: "Beta")]
        let expectedFileContents = "Alpha Alpha red yellow true\nBeta Beta red yellow true\n"
        let filePath = "~/Desktop/configuration.yaml"
        do {
            try YamlHandler.createYamlFileAtPath(filePath, configurations: configurations)
            XCTAssertTrue(expectedFileContents == fileContentsAtPath(filePath))
        } catch {
            XCTFail()
        }
    }
    
    
    func testYamlHandlerReadsConfigurationFileIntoArrayOfConfigurationObjects() {
        let configurations = YamlHandler.configurationsFromFileAtPath(pathOfFileWithName("testConfiguration")!)
        let expectedConfigurations = [Configuration(configurationName: "Alpha"), Configuration(configurationName: "Beta")]
        XCTAssertTrue(configurations! == expectedConfigurations)
    }
    

    
    func pathOfFileWithName(filename: String) -> String? {
        let bundle = NSBundle(forClass: ProjectConfigExtractorTests.self)
        return bundle.pathForResource(filename, ofType: "yaml")
    }
}
