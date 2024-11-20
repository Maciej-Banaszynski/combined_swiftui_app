//
//  DataE2ETests.swift
//  combined_swiftui_appTests
//
//  Created by Maciej Banaszyński on 18/11/2024.
//

import XCTest
import SwiftData

final class DataE2ETests: XCTestCase {
    var dao: SwiftDataUserDAO!
    let iterations = 10 
    
    @MainActor override func setUp() {
        super.setUp()
        if let modelContainer = try? ModelContainer(for: User.self) {
            let modelContext = modelContainer.mainContext
            dao = SwiftDataUserDAO(modelContext: modelContext)
        } else {
            XCTFail("Failed to initialize ModelContainer")
        }
    }
    
    @MainActor override func tearDown() {
        dao = nil
        super.tearDown()
    }
    
    func testCRUDForThousandUsers() throws {
        try performCRUDTests(for: .thousand)
    }
    
    func testCRUDForTenThousandUsers() throws {
        try performCRUDTests(for: .tenThousand)
    }
    
    func testCRUDForThirtyThousandUsers() throws {
        try performCRUDTests(for: .thirtyThousand)
    }
    
    private func performCRUDTests(for countCase: GeneratedUsersCount) throws {
        guard let users = try loadUsers(from: countCase), !users.isEmpty else {
            XCTFail("Failed to load users for \(countCase.displayName)")
            return
        }
        
        let csvHeader = "Iteration,Operation,Clock Time (ms),CPU Usage (%),Memory Usage (MB)\n"
        var csvRows: [String] = [csvHeader]
        var datasetResults: [String: [(clockTime: Double, cpuUsage: Double, memoryUsage: Double)]] = [:]
        
        // Perform tests
        datasetResults["Insert", default: []] = performMetrics(iterationCount: iterations, operation: "Insert") {
            try dao.insertMultiple(users: users)
        }
        
        datasetResults["Fetch", default: []] = performMetrics(iterationCount: iterations, operation: "Fetch") {
            _ = users.filter { $0.position.contains("Lead") }
        }
        
        datasetResults["Update", default: []] = performMetrics(iterationCount: iterations, operation: "Update") {
            var usersCopy = users
            usersCopy.forEach { $0.position += " Updated" }
        }
        
        datasetResults["Delete", default: []] = performMetrics(iterationCount: iterations, operation: "Delete") {
            var usersCopy = users
            usersCopy.removeAll()
        }
        
        // Append results to CSV
        for (operation, results) in datasetResults {
            for (index, result) in results.enumerated() {
                csvRows.append("\(index + 1),\(operation),\(result.clockTime),\(result.cpuUsage),\(result.memoryUsage)")
            }
            
            // Calculate averages
            let avgClockTime = results.map { $0.clockTime }.reduce(0, +) / Double(results.count)
            let avgCPU = results.map { $0.cpuUsage }.reduce(0, +) / Double(results.count)
            let avgMemory = results.map { $0.memoryUsage }.reduce(0, +) / Double(results.count)
            
            csvRows.append("Average,\(operation),\(avgClockTime),\(avgCPU),\(avgMemory)")
        }
        
        saveToCSV(for: countCase, content: csvRows.joined(separator: "\n"))
    }
    
    private func performMetrics(iterationCount: Int, operation: String, block: () throws -> Void) -> [(clockTime: Double, cpuUsage: Double, memoryUsage: Double)] {
        var results: [(clockTime: Double, cpuUsage: Double, memoryUsage: Double)] = []
        
        for iteration in 1...iterationCount {
            let cpuBefore = ProcessInfo.processInfo.systemUptime
            let memoryBefore = memoryUsageInMB()
            
            let startTime = DispatchTime.now()
            do {
                try block()
            } catch {
                XCTFail("Error during \(operation): \(error)")
            }
            let endTime = DispatchTime.now()
            
            let cpuAfter = ProcessInfo.processInfo.systemUptime
            let memoryAfter = memoryUsageInMB()
            
            let clockTime = Double(endTime.uptimeNanoseconds - startTime.uptimeNanoseconds) / 1_000_000
            let cpuUsage = cpuAfter - cpuBefore
            let memoryUsage = memoryAfter - memoryBefore
            
            results.append((clockTime: clockTime, cpuUsage: cpuUsage, memoryUsage: memoryUsage))
            print("Iteration \(iteration), \(operation): Clock Time \(clockTime) ms, CPU \(cpuUsage) %, Memory \(memoryUsage) MB")
        }
        
        return results
    }
    
    private func saveToCSV(for countCase: GeneratedUsersCount, content: String) {
        let fileName = "\(countCase.displayName)_metrics.csv"
        let filePath = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        do {
            try content.write(to: filePath, atomically: true, encoding: .utf8)
            print("Metrics saved to CSV for \(countCase.displayName) at: \(filePath.path)")
        } catch {
            XCTFail("Failed to save metrics to CSV: \(error)")
        }
    }
    
    private func loadUsers(from count: GeneratedUsersCount) throws -> [User]? {
        guard let filePath = Bundle.main.path(forResource: count.displayName, ofType: "csv") else {
            XCTFail("File not found: \(count.displayName).csv")
            return nil
        }
        
        let csvString = try String(contentsOfFile: filePath, encoding: .utf8)
        let rows = csvString.components(separatedBy: "\n").dropFirst()
        let users = rows.compactMap { row -> User? in
            let columns = row.split(separator: ",").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            guard columns.count >= 7 else { return nil }
            return User(
                firstName: columns[0],
                lastName: columns[1],
                birthday: ISO8601DateFormatter().date(from: columns[2]) ?? Date(),
                address: columns[3],
                phoneNumber: columns[4],
                position: columns[5],
                company: columns[6]
            )
        }
        
        return users
    }
    
    private func memoryUsageInMB() -> Double {
        let taskInfo = mach_task_basic_info()
        let memoryInBytes = taskInfo.resident_size
        return Double(memoryInBytes) / 1_000_000
    }
    
    private func getMachTaskInfo() -> mach_task_basic_info {
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size / MemoryLayout<natural_t>.size)
        var info = mach_task_basic_info()
        let result: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }
        guard result == KERN_SUCCESS else {
            fatalError("Error retrieving task info: \(result)")
        }
        return info
    }

}
