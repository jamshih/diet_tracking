import Foundation
import XCTest
import DietTrackingDomain

final class DomainContractTests: XCTestCase {
    private let utc = TimeZoneContext(timeZone: TimeZone(secondsFromGMT: 0)!)

    func testSeverityBoundariesAccepted() throws {
        XCTAssertEqual(try SymptomSeverity(0).value, 0)
        XCTAssertEqual(try SymptomSeverity(10).value, 10)
    }

    func testSeverityOutsideRangeRejected() {
        XCTAssertThrowsError(try SymptomSeverity(-1)) { error in
            XCTAssertEqual(
                error as? DomainValidationError,
                .invalidScore(field: "severity", value: -1)
            )
        }
        XCTAssertThrowsError(try SymptomSeverity(11))
    }

    func testDailyDiscomfortBoundaries() throws {
        XCTAssertEqual(try DailyDiscomfortScore(0).value, 0)
        XCTAssertEqual(try DailyDiscomfortScore(10).value, 10)
        XCTAssertThrowsError(try DailyDiscomfortScore(-1))
        XCTAssertThrowsError(try DailyDiscomfortScore(11))
    }

    func testStressBoundaries() throws {
        XCTAssertEqual(try StressScore(0).value, 0)
        XCTAssertEqual(try StressScore(10).value, 10)
        XCTAssertThrowsError(try StressScore(-1))
        XCTAssertThrowsError(try StressScore(11))
    }

    func testMentalWellbeingBoundaries() throws {
        XCTAssertEqual(try MentalWellbeingScore(0).value, 0)
        XCTAssertEqual(try MentalWellbeingScore(10).value, 10)
        XCTAssertThrowsError(try MentalWellbeingScore(-1))
        XCTAssertThrowsError(try MentalWellbeingScore(11))
    }

    func testValidSymptomOnsetIntervalPreservesBothBounds() throws {
        let lower = Date(timeIntervalSince1970: 1_000)
        let upper = Date(timeIntervalSince1970: 4_600)
        let episode = try SymptomEpisode(
            onsetWindowLowerBound: lower,
            onsetWindowUpperBound: upper,
            timeZone: utc,
            severity: try SymptomSeverity(7)
        )

        XCTAssertEqual(episode.onsetWindowLowerBound, lower)
        XCTAssertEqual(episode.onsetWindowUpperBound, upper)
    }

    func testInvertedSymptomIntervalRejected() throws {
        XCTAssertThrowsError(
            try SymptomEpisode(
                onsetWindowLowerBound: Date(timeIntervalSince1970: 2_000),
                onsetWindowUpperBound: Date(timeIntervalSince1970: 1_000),
                timeZone: utc,
                severity: try SymptomSeverity(5)
            )
        )
    }

    func testExactSymptomOnsetIsRepresentableWithoutInventingDuration() throws {
        let instant = Date(timeIntervalSince1970: 1_000)
        let episode = try SymptomEpisode(
            onsetWindowLowerBound: instant,
            onsetWindowUpperBound: instant,
            timeZone: utc,
            severity: try SymptomSeverity(4)
        )
        XCTAssertEqual(episode.onsetWindowLowerBound, episode.onsetWindowUpperBound)
    }

    func testEmptyMealRejected() {
        XCTAssertThrowsError(
            try MealLog(
                foods: [],
                timestamp: Date(timeIntervalSince1970: 1_000),
                timeZone: utc,
                mealType: .lunch,
                isSpicy: false
            )
        )
    }

    func testOneFoodMealAccepted() throws {
        let food = try FoodItem(displayName: "Rice")
        let id = UUID(uuidString: "00000000-0000-0000-0000-000000000111")!
        let meal = try MealLog(
            id: id,
            foods: [food],
            timestamp: Date(timeIntervalSince1970: 1_000),
            timeZone: utc,
            mealType: .lunch,
            isSpicy: true
        )
        XCTAssertEqual(meal.id, id)
        XCTAssertEqual(meal.foods, [food])
        XCTAssertTrue(meal.isSpicy)
    }

    func testFoodNormalizationIsDeterministicAndTransparent() throws {
        let first = try FoodItem(displayName: "  Fried\t Chicken  ")
        let second = try FoodItem(displayName: "fried   chicken")
        let distinct = try FoodItem(displayName: "chicken")

        XCTAssertEqual(first.displayName, "Fried Chicken")
        XCTAssertEqual(first.normalizedName, "fried chicken")
        XCTAssertEqual(first.id, second.id)
        XCTAssertEqual(first, second)
        XCTAssertNotEqual(first.id, distinct.id)
    }

    func testBlankFoodRejected() {
        XCTAssertThrowsError(try FoodItem(displayName: " \n\t "))
    }

    func testStableFoodExposureIdentity() throws {
        let mealID = UUID(uuidString: "00000000-0000-0000-0000-000000000123")!
        let food = try FoodItem(displayName: "Rice")
        let timestamp = Date(timeIntervalSince1970: 1_000)

        let first = FoodExposure(
            mealID: mealID,
            foodID: food.id,
            timestamp: timestamp,
            timeZone: utc,
            mealType: .dinner,
            isSpicy: false
        )
        let second = FoodExposure(
            mealID: mealID,
            foodID: food.id,
            timestamp: timestamp,
            timeZone: utc,
            mealType: .dinner,
            isSpicy: false
        )

        XCTAssertEqual(first.id, second.id)
    }

    func testPairCandidateIdentityIsOrderIndependent() throws {
        let rice = try FoodItem(displayName: "Rice")
        let beans = try FoodItem(displayName: "Beans")
        let a = try CandidateSubject.pair(rice.id, beans.id)
        let b = try CandidateSubject.pair(beans.id, rice.id)
        let version = try AnalysisVersion("v0")
        let evidence = try CandidateEvidence(episodeSupportCount: 2, comparisonCount: 3)

        let signalA = try CandidateSignal(
            subject: a,
            evidence: evidence,
            analysisVersion: version
        )
        let signalB = try CandidateSignal(
            subject: b,
            evidence: evidence,
            analysisVersion: version
        )

        XCTAssertEqual(a, b)
        XCTAssertEqual(signalA.id, signalB.id)
        XCTAssertEqual(signalA.subject.memberFoodIDs, signalB.subject.memberFoodIDs)
    }

    func testPairCannotContainSameFoodTwice() throws {
        let rice = try FoodItem(displayName: "Rice")
        XCTAssertThrowsError(try CandidateSubject.pair(rice.id, rice.id))
    }

    func testTimezoneContextIsExplicitAndRejectsUnknownIdentifier() throws {
        XCTAssertEqual(
            try TimeZoneContext(identifier: "Asia/Taipei").identifier,
            "Asia/Taipei"
        )
        XCTAssertThrowsError(
            try TimeZoneContext(identifier: "Definitely/Not_A_Timezone")
        )
    }

    func testLocalDateRejectsImpossibleCalendarDate() {
        XCTAssertThrowsError(try LocalDate(year: 2026, month: 2, day: 30))
    }

    func testDailyContextKeepsMetricDirectionTypesDistinct() throws {
        let id = UUID(uuidString: "00000000-0000-0000-0000-000000000456")!
        let context = DailyContextCheckIn(
            id: id,
            localDate: try LocalDate(year: 2026, month: 10, day: 6),
            timeZone: try TimeZoneContext(identifier: "Asia/Taipei"),
            overallDiscomfort: try DailyDiscomfortScore(8),
            stress: try StressScore(9),
            mentalWellbeing: try MentalWellbeingScore(2)
        )

        XCTAssertEqual(context.id, id)
        XCTAssertEqual(context.overallDiscomfort?.value, 8)
        XCTAssertEqual(context.stress?.value, 9)
        XCTAssertEqual(context.mentalWellbeing?.value, 2)
    }

    func testCandidateEvidenceRejectsNegativeCounts() {
        XCTAssertThrowsError(
            try CandidateEvidence(episodeSupportCount: -1, comparisonCount: 0)
        )
    }

    func testCandidateSignalRejectsNonFiniteMetrics() throws {
        let rice = try FoodItem(displayName: "Rice")
        let evidence = try CandidateEvidence(
            episodeSupportCount: 1,
            comparisonCount: 1
        )
        let version = try AnalysisVersion("v0")

        XCTAssertThrowsError(
            try CandidateSignal(
                subject: .item(rice.id),
                evidence: evidence,
                rankingScore: .nan,
                analysisVersion: version
            )
        )
    }

    func testAnalysisReportRejectsMixedVersions() throws {
        let rice = try FoodItem(displayName: "Rice")
        let evidence = try CandidateEvidence(
            episodeSupportCount: 1,
            comparisonCount: 1
        )
        let v0 = try AnalysisVersion("v0")
        let v1 = try AnalysisVersion("v1")
        let signal = try CandidateSignal(
            subject: .item(rice.id),
            evidence: evidence,
            analysisVersion: v0
        )

        XCTAssertThrowsError(
            try AnalysisReport(
                version: v1,
                generatedAt: Date(),
                candidates: [signal]
            )
        )
    }
}
