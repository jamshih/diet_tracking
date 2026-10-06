import Foundation

/// The named timezone retained with locally-entered health and meal observations.
///
/// Chronological ordering uses absolute `Date` values. The timezone identifier is
/// preserved separately so local-day grouping and display do not silently depend on
/// whatever timezone the device happens to use later.
public struct TimeZoneContext: Hashable, Sendable {
    public let identifier: String

    public init(identifier: String) throws {
        guard TimeZone(identifier: identifier) != nil else {
            throw DomainValidationError.invalidTimeZoneIdentifier(identifier)
        }
        self.identifier = identifier
    }

    public init(timeZone: TimeZone) {
        self.identifier = timeZone.identifier
    }

    /// Reconstructs the Foundation timezone when the identifier is available in
    /// the current runtime's timezone database.
    public var foundationTimeZone: TimeZone? {
        TimeZone(identifier: identifier)
    }
}

/// A Gregorian local calendar date with no fabricated time-of-day.
public struct LocalDate: Hashable, Sendable, Comparable {
    public let year: Int
    public let month: Int
    public let day: Int

    public init(year: Int, month: Int, day: Int) throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let components = DateComponents(year: year, month: month, day: day)

        guard
            let date = calendar.date(from: components),
            calendar.component(.year, from: date) == year,
            calendar.component(.month, from: date) == month,
            calendar.component(.day, from: date) == day
        else {
            throw DomainValidationError.invalidLocalDate(year: year, month: month, day: day)
        }

        self.year = year
        self.month = month
        self.day = day
    }

    public static func < (lhs: LocalDate, rhs: LocalDate) -> Bool {
        if lhs.year != rhs.year { return lhs.year < rhs.year }
        if lhs.month != rhs.month { return lhs.month < rhs.month }
        return lhs.day < rhs.day
    }
}
