import XCTest
import SnapshotTesting
@testable import Tracker

final class TrackersViewControllerSnapshotTests: XCTestCase {
    
    // MARK: - Test Data Setup
    private func createMockTrackerService() -> MockTrackerService {
        let service = MockTrackerService()
        return service
    }
    
    private func createTrackersViewController() -> TrackersViewController {
        let mockService = createMockTrackerService()
        let viewModel = TrackersViewModel(trackerService: mockService)
        let viewController = TrackersViewController(viewModel: viewModel, trackerService: mockService)
        DispatchQueue.main.sync {
            
            viewController.view.frame = CGRect(x: 0, y: 0, width: 375, height: 812)
            viewController.loadViewIfNeeded()
            viewController.viewDidLoad()
        }
        
        return viewController
    }
    
    // MARK: - Basic Test
    func testBasicEmptyState() throws {
        let mockService = createMockTrackerService()
        let viewModel = TrackersViewModel(trackerService: mockService)
        let viewController = TrackersViewController(viewModel: viewModel, trackerService: mockService)
        
        assertSnapshots(of: viewController, as:[
            .image(traits: .init(userInterfaceStyle: .light)),
            .image(traits: .init(userInterfaceStyle: .dark))
        ])
    }
    
    func testSimpleView() throws {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 812))
        view.backgroundColor = .systemBlue
        
        let label = UILabel(frame: CGRect(x: 20, y: 100, width: 335, height: 50))
        label.text = "Test View"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        view.addSubview(label)
        
        assertSnapshots(of: view, as:[
            .image(traits: .init(userInterfaceStyle: .light)),
            .image(traits: .init(userInterfaceStyle: .dark))
        ])
    }
}

// MARK: - Mock Tracker Service
private class MockTrackerService: TrackerServiceProtocol {
    var mockTrackers: [Tracker] = []
    var mockRecords: [TrackerRecord] = []
    
    func fetchAllTrackers() -> [Tracker] {
        return mockTrackers
    }
    
    func completedDays(for tracker: Tracker) -> Int {
        return mockRecords.filter { $0.trackerId == tracker.id }.count
    }
    
    func isCompleted(on date: Date, tracker: Tracker) -> Bool {
        return mockRecords.contains { record in
            record.trackerId == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: date)
        }
    }
    
    func addTracker(_ tracker: Tracker) {
        mockTrackers.append(tracker)
    }
    
    func updateTracker(_ tracker: Tracker) {
        if let index = mockTrackers.firstIndex(where: { $0.id == tracker.id }) {
            mockTrackers[index] = tracker
        }
    }
    
    func deleteTracker(_ tracker: Tracker) {
        mockTrackers.removeAll { $0.id == tracker.id }
    }
    
    func addRecord(for tracker: Tracker, on date: Date) {
        let record = TrackerRecord(trackerId: tracker.id, date: date)
        mockRecords.append(record)
    }
    
    func removeRecord(for tracker: Tracker, on date: Date) {
        mockRecords.removeAll { record in
            record.trackerId == tracker.id && Calendar.current.isDate(record.date, inSameDayAs: date)
        }
    }
}
