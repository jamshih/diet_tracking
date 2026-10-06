import DietTrackingDomain

/// Namespace marker for the analysis boundary.
///
/// Temporal exposure and scoring behavior are intentionally deferred to their
/// dedicated RFCs/issues.
public enum DietTrackingAnalysisModule {
    public static let identifier = "DietTrackingAnalysis"

    public static var domainIdentifier: String {
        DietTrackingDomainModule.identifier
    }
}
