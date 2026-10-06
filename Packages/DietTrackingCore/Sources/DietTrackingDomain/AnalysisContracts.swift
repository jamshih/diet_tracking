import Foundation

public enum CandidateKind: String, Hashable, Sendable {
    case item
    case pair
}

/// The normalized food identity (or unordered pair identity) evaluated by analysis.
///
/// Pair construction is canonical so A+B and B+A are the same subject. This is
/// identity semantics only; pair enumeration and eligibility remain Team B work.
public struct CandidateSubject: Hashable, Sendable {
    public let kind: CandidateKind
    public let memberFoodIDs: [FoodItem.ID]

    private init(kind: CandidateKind, memberFoodIDs: [FoodItem.ID]) {
        self.kind = kind
        self.memberFoodIDs = memberFoodIDs
    }

    public static func item(_ id: FoodItem.ID) -> CandidateSubject {
        CandidateSubject(kind: .item, memberFoodIDs: [id])
    }

    public static func pair(_ first: FoodItem.ID, _ second: FoodItem.ID) throws -> CandidateSubject {
        guard first != second else {
            throw DomainValidationError.duplicatePairMember(first)
        }

        let members = first < second ? [first, second] : [second, first]
        return CandidateSubject(kind: .pair, memberFoodIDs: members)
    }

    fileprivate var stableKey: String {
        switch kind {
        case .item:
            return "item:\(Self.component(memberFoodIDs[0]))"
        case .pair:
            return "pair:\(Self.component(memberFoodIDs[0]))\(Self.component(memberFoodIDs[1]))"
        }
    }

    private static func component(_ id: FoodItem.ID) -> String {
        let raw = id.rawValue
        return "\(raw.utf8.count):\(raw)"
    }
}

/// Evidence counts that can be produced without defining the ranking formula.
public struct CandidateEvidence: Hashable, Sendable {
    public let episodeSupportCount: Int
    public let comparisonCount: Int
    public let dailyFallbackSupportCount: Int

    public init(
        episodeSupportCount: Int,
        comparisonCount: Int,
        dailyFallbackSupportCount: Int = 0
    ) throws {
        self.episodeSupportCount = try Self.validateCount(
            episodeSupportCount,
            field: "episodeSupportCount"
        )
        self.comparisonCount = try Self.validateCount(
            comparisonCount,
            field: "comparisonCount"
        )
        self.dailyFallbackSupportCount = try Self.validateCount(
            dailyFallbackSupportCount,
            field: "dailyFallbackSupportCount"
        )
    }

    private static func validateCount(_ value: Int, field: String) throws -> Int {
        guard value >= 0 else {
            throw DomainValidationError.negativeEvidenceCount(field: field, value: value)
        }
        return value
    }
}

/// Identifier for a versioned analysis contract/configuration.
public struct AnalysisVersion: Hashable, Sendable {
    public let identifier: String

    public init(_ value: String) throws {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw DomainValidationError.emptyAnalysisVersion
        }
        self.identifier = trimmed
    }
}

/// Versioned candidate output shape for Team B.
///
/// Numeric summaries are optional and have no formula or scale imposed here beyond
/// being finite. Their exact meaning belongs to the referenced analysis version.
public struct CandidateSignal: Hashable, Sendable {
    public struct ID: Hashable, Sendable {
        public let rawValue: String

        fileprivate init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    public let id: ID
    public let subject: CandidateSubject
    public let evidence: CandidateEvidence
    public let severitySummary: Double?
    public let effectEstimate: Double?
    public let temporalConfidence: Double?
    public let reliability: Double?
    public let rankingScore: Double?
    public let evidenceTier: String?
    public let analysisVersion: AnalysisVersion

    public init(
        subject: CandidateSubject,
        evidence: CandidateEvidence,
        severitySummary: Double? = nil,
        effectEstimate: Double? = nil,
        temporalConfidence: Double? = nil,
        reliability: Double? = nil,
        rankingScore: Double? = nil,
        evidenceTier: String? = nil,
        analysisVersion: AnalysisVersion
    ) throws {
        try Self.validateFinite(severitySummary, field: "severitySummary")
        try Self.validateFinite(effectEstimate, field: "effectEstimate")
        try Self.validateFinite(temporalConfidence, field: "temporalConfidence")
        try Self.validateFinite(reliability, field: "reliability")
        try Self.validateFinite(rankingScore, field: "rankingScore")

        self.id = ID(rawValue: subject.stableKey)
        self.subject = subject
        self.evidence = evidence
        self.severitySummary = severitySummary
        self.effectEstimate = effectEstimate
        self.temporalConfidence = temporalConfidence
        self.reliability = reliability
        self.rankingScore = rankingScore
        self.evidenceTier = evidenceTier
        self.analysisVersion = analysisVersion
    }

    private static func validateFinite(_ value: Double?, field: String) throws {
        if let value, !value.isFinite {
            throw DomainValidationError.nonFiniteAnalysisMetric(field: field)
        }
    }
}

/// Domain-level output container. It version-binds every candidate in a report and
/// prevents duplicate candidate identities without defining how candidates rank.
public struct AnalysisReport: Hashable, Sendable {
    public let version: AnalysisVersion
    public let generatedAt: Date
    public let candidates: [CandidateSignal]

    public init(
        version: AnalysisVersion,
        generatedAt: Date,
        candidates: [CandidateSignal]
    ) throws {
        guard candidates.allSatisfy({ $0.analysisVersion == version }) else {
            throw DomainValidationError.analysisVersionMismatch
        }

        var ids = Set<CandidateSignal.ID>()
        for candidate in candidates where !ids.insert(candidate.id).inserted {
            throw DomainValidationError.duplicateCandidateID(candidate.id)
        }

        self.version = version
        self.generatedAt = generatedAt
        self.candidates = candidates
    }
}
