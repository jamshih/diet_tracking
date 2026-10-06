import DietTrackingDomain

/// Namespace marker for the storage boundary.
///
/// Concrete storage protocols and adapters belong to later storage work. This
/// marker only proves that the module can depend on Domain without choosing a
/// persistence framework.
public enum DietTrackingStorageModule {
    public static let identifier = "DietTrackingStorage"

    public static var domainIdentifier: String {
        DietTrackingDomainModule.identifier
    }
}
