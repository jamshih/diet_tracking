import Foundation

/// Centralized failures for semantic domain invariants.
public enum DomainValidationError: Error, Equatable, Sendable {
    case emptyFoodName
    case emptyMealType
    case invalidScore(field: String, value: Int)
    case invalidSymptomOnsetWindow
    case emptyMeal
    case invalidTimeZoneIdentifier(String)
    case invalidLocalDate(year: Int, month: Int, day: Int)
    case duplicatePairMember(FoodItem.ID)
    case negativeEvidenceCount(field: String, value: Int)
    case nonFiniteAnalysisMetric(field: String)
    case emptyAnalysisVersion
    case analysisVersionMismatch
    case duplicateCandidateID(CandidateSignal.ID)
}

@inline(__always)
private func validateTenPointScore(_ value: Int, field: String) throws -> Int {
    guard (0...10).contains(value) else {
        throw DomainValidationError.invalidScore(field: field, value: value)
    }
    return value
}

/// Symptom severity on the product's 0...10 scale; higher means worse.
public struct SymptomSeverity: Hashable, Sendable {
    public let value: Int

    public init(_ value: Int) throws {
        self.value = try validateTenPointScore(value, field: "severity")
    }
}

/// Daily overall stomach discomfort on the 0...10 scale; higher means worse.
public struct DailyDiscomfortScore: Hashable, Sendable {
    public let value: Int

    public init(_ value: Int) throws {
        self.value = try validateTenPointScore(value, field: "overallDiscomfort")
    }
}

/// Daily stress on the 0...10 scale; higher means more stressed.
public struct StressScore: Hashable, Sendable {
    public let value: Int

    public init(_ value: Int) throws {
        self.value = try validateTenPointScore(value, field: "stress")
    }
}

/// Daily overall mental well-being on the 0...10 scale; higher means better.
public struct MentalWellbeingScore: Hashable, Sendable {
    public let value: Int

    public init(_ value: Int) throws {
        self.value = try validateTenPointScore(value, field: "mentalWellbeing")
    }
}
