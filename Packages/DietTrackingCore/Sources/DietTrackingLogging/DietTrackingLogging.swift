import DietTrackingDomain
import DietTrackingStorage

/// Namespace marker for application/logging use cases.
///
/// Issue #11 will add logging commands after the domain contracts from Issue #5
/// exist. No user-data semantics are implemented in this bootstrap.
public enum DietTrackingLoggingModule {
    public static let identifier = "DietTrackingLogging"

    public static var dependencyIdentifiers: [String] {
        [
            DietTrackingDomainModule.identifier,
            DietTrackingStorageModule.identifier
        ]
    }
}
