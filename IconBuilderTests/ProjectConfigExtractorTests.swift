//
//  ProjectConfigExtractorTests.swift
//  IconBuilder
//
//  Created by Dan Ursu on 16/11/15.
//  Copyright © 2015 Andrei Vidrasco. All rights reserved.
//

import XCTest

@testable import IconBuilder
class ProjectConfigExtractorTests: XCTestCase {

    func testIfConfigExtractorCanFindPbxProjInsideXcodeProj() {
        guard let pathOfxcodeProj = pathOfFileWithName("SchemaTestProject") else { return }
        let (_, pathOfpbxproj) = extractConfigFromProject(NSURL(fileURLWithPath: pathOfxcodeProj))
        XCTAssertTrue(pathOfxcodeProj + "/project.pbxproj" == pathOfpbxproj)
    }
    
    
    func testIfConfigExtractorCanFindAllSchemasInsideXcodeProj() {
        guard let pathOfxcodeProj = pathOfFileWithName("SchemaTestProject") else { return }
        let (configurations, _) = extractConfigFromProject(NSURL(fileURLWithPath: pathOfxcodeProj))
        XCTAssertTrue(configurations[0] == "Debug")
        XCTAssertTrue(configurations[1] == "Release")
        XCTAssertTrue(configurations[2] == "Alpha")
        XCTAssertTrue(configurations[3] == "Beta")
    }
    
    
    func pathOfFileWithName(filename: String) -> String? {
        let bundle = NSBundle(forClass: ProjectConfigExtractorTests.self)
        return bundle.pathForResource(filename, ofType: "bin")
    }
}
