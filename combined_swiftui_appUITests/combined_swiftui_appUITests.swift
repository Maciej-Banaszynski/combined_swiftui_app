//
//  combined_swiftui_appUITests.swift
//  combined_swiftui_appUITests
//
//  Created by Maciej Banaszyński on 19/11/2024.
//

import XCTest

final class combined_swiftui_appUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        // Launch the app
        continueAfterFailure = false
        app.launch()
    }
    
    func testDataManagementTest() throws {
        measure(metrics: [XCTClockMetric()]) {
            let dataTab = app.tabBars.buttons["dataTab"]
//            XCTAssertTrue(dataTab.exists, "The Data tab does not exist")
            dataTab.tap()
            XCTAssertTrue(app.staticTexts["Data"].exists, "The Data screen is not displayed")
            
            let swiftDataManagementButton = app.buttons["swiftDataManagementButton"]
            let sqliteDataManagementButton = app.buttons["sqliteDataManagementButton"]
            
            XCTAssertTrue(swiftDataManagementButton.exists, "The Swift Data Management Button does not exists")
            XCTAssertTrue(sqliteDataManagementButton.exists, "The SQLite Data Management Button does not exists")
            
            swiftDataManagementButton.tap()
            
            XCTAssertTrue(app.staticTexts["Swift Data Managament"].exists, "The Swift Data Management Screen is not displayed")
            
            let add1000UsersButton = app.buttons[GeneratedUsersCount.thousand.accessibilityIdentifier]
            let add10000UsersButton = app.buttons[GeneratedUsersCount.tenThousand.accessibilityIdentifier]
            let add30000UsersButton = app.buttons[GeneratedUsersCount.thirtyThousand.accessibilityIdentifier]
            let deleteUsersButton = app.buttons["deleteAllUsersButton"]
            
            XCTAssertTrue(add1000UsersButton.exists, "The add 1000 users button does not exists")
            XCTAssertTrue(add10000UsersButton.exists, "The add 10000 users button does not exists")
            XCTAssertTrue(add30000UsersButton.exists, "The add 30000 users button does not exists")
            XCTAssertTrue(deleteUsersButton.exists, "The delete users button does not exists")
            
            deleteUsersButton.tap()
            
            XCTAssertTrue(app.staticTexts["User Count: 0"].exists, "There are still users left")
        }
    }
}
