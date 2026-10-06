import Foundation

/// A symptom observation whose onset may be uncertain.
///
/// The lower/upper bounds describe *when onset may have occurred*. They are not
/// symptom duration or a symptom end time, and no midpoint is synthesized.
public struct SymptomEpisode: Hashable, Sendable {
    public let id: UUID
    public let onsetWindowLowerBound: Date
    public let onsetWindowUpperBound: Date
    public let timeZone: TimeZoneContext
    public let severity: SymptomSeverity

    public init(
        id: UUID = UUID(),
        onsetWindowLowerBound: Date,
        onsetWindowUpperBound: Date,
        timeZone: TimeZoneContext,
        severity: SymptomSeverity
    ) throws {
        guard onsetWindowLowerBound <= onsetWindowUpperBound else {
            throw DomainValidationError.invalidSymptomOnsetWindow
        }

        self.id = id
        self.onsetWindowLowerBound = onsetWindowLowerBound
        self.onsetWindowUpperBound = onsetWindowUpperBound
        self.timeZone = timeZone
        self.severity = severity
    }
}

/// Optional daily context observations. These values are stored as observations
/// only; this type makes no causal or ranking assumption about stress/well-being.
public struct DailyContextCheckIn: Hashable, Sendable {
    public let id: UUID
    public let localDate: LocalDate
    public let timeZone: TimeZoneContext
    public let overallDiscomfort: DailyDiscomfortScore?
    public let stress: StressScore?
    public let mentalWellbeing: MentalWellbeingScore?

    public init(
        id: UUID = UUID(),
        localDate: LocalDate,
        timeZone: TimeZoneContext,
        overallDiscomfort: DailyDiscomfortScore? = nil,
        stress: StressScore? = nil,
        mentalWellbeing: MentalWellbeingScore? = nil
    ) {
        self.id = id
        self.localDate = localDate
        self.timeZone = timeZone
        self.overallDiscomfort = overallDiscomfort
        self.stress = stress
        self.mentalWellbeing = mentalWellbeing
    }
}
