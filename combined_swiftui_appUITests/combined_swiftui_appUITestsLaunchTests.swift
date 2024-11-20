//
//  combined_swiftui_appUITestsLaunchTests.swift
//  combined_swiftui_appUITests
//
//  Created by Maciej Banaszyński on 19/11/2024.
//

import XCTest

final class combined_swiftui_appUITestsLaunchTests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Launch the app
        continueAfterFailure = false
        app.launch()
    }
    
//    func testButtonTapUpdatesLabel() throws {
//        let button = app.buttons["myButtonIdentifier"]
//        
//        XCTAssertTrue(button.exists, "The button does not exist")
//        
//        button.tap()
//        
//        let label = app.staticTexts["myLabelIdentifier"]
//        
//        XCTAssertEqual(label.label, "Button Tapped", "The label text did not update correctly")
//    }
}
