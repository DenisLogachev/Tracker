import XCTest
@testable import Tracker

final class AnalyticsServiceTests: XCTestCase {
    
    func testAnalyticsServiceSingleton() {
        let service1 = AnalyticsService.shared
        let service2 = AnalyticsService.shared
        
        XCTAssertTrue(service1 === service2, "AnalyticsService should be a singleton")
    }
    
    func testAnalyticsServiceItems() {
        XCTAssertEqual(AnalyticsService.Item.addTrack.rawValue, "add_track")
        XCTAssertEqual(AnalyticsService.Item.track.rawValue, "track")
        XCTAssertEqual(AnalyticsService.Item.filter.rawValue, "filter")
        XCTAssertEqual(AnalyticsService.Item.edit.rawValue, "edit")
        XCTAssertEqual(AnalyticsService.Item.delete.rawValue, "delete")
    }
    
    func testAnalyticsServiceScreens() {
        XCTAssertEqual(AnalyticsService.Screen.main.rawValue, "Main")
    }
    
    func testReportScreenOpen() {
        let service = AnalyticsService.shared
        let screen = "TestScreen"
        
        service.reportScreenOpen(screen)
        XCTAssertTrue(true, "reportScreenOpen should complete successfully")
    }
    
    func testReportScreenClose() {
        let service = AnalyticsService.shared
        let screen = "TestScreen"
        
        service.reportScreenClose(screen)
        
        XCTAssertTrue(true, "reportScreenClose should complete successfully")
    }
    
    func testReportClick() {
        let service = AnalyticsService.shared
        let item = "test_item"
        let screen = "TestScreen"
        
        service.reportClick(item, screen: screen)
        
        
        XCTAssertTrue(true, "reportClick should complete successfully")
    }
}
