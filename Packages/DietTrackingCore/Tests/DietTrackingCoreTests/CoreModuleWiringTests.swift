import XCTest
import DietTrackingAnalysis
import DietTrackingDomain
import DietTrackingLogging
import DietTrackingStorage

final class CoreModuleWiringTests: XCTestCase {
    func testCoreModulesAreHeadlesslyWired() {
        XCTAssertEqual(DietTrackingDomainModule.identifier, "DietTrackingDomain")
        XCTAssertEqual(
            DietTrackingStorageModule.domainIdentifier,
            DietTrackingDomainModule.identifier
        )
        XCTAssertEqual(
            DietTrackingAnalysisModule.domainIdentifier,
            DietTrackingDomainModule.identifier
        )
        XCTAssertEqual(
            DietTrackingLoggingModule.dependencyIdentifiers,
            [
                DietTrackingDomainModule.identifier,
                DietTrackingStorageModule.identifier
            ]
        )
    }
}
