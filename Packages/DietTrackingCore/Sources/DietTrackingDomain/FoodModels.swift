import Foundation

/// Transparent normalization defined by RFC #3's current contract.
public enum FoodNormalizer {
    /// Trims only surrounding whitespace for presentation. Internal spelling,
    /// casing, and spacing remain user-facing rather than being rewritten.
    public static func displayText(from input: String) -> String {
        input.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Produces the stable identity key by trimming/collapsing whitespace and
    /// deterministic case folding. No fuzzy, AI, alias, stemming, or category
    /// merge is performed.
    public static func identityKey(from input: String) -> String {
        input
            .split(whereSeparator: { $0.isWhitespace })
            .joined(separator: " ")
            .lowercased()
    }
}

/// A normalized food identity plus user-facing display text.
public struct FoodItem: Sendable {
    public struct ID: Hashable, Sendable, Comparable {
        public let rawValue: String

        fileprivate init(rawValue: String) {
            self.rawValue = rawValue
        }

        public static func < (lhs: ID, rhs: ID) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
    }

    public let id: ID
    public let displayName: String
    public let normalizedName: String

    public init(displayName: String) throws {
        let display = FoodNormalizer.displayText(from: displayName)
        let normalized = FoodNormalizer.identityKey(from: displayName)
        guard !normalized.isEmpty else {
            throw DomainValidationError.emptyFoodName
        }

        self.id = ID(rawValue: normalized)
        self.displayName = display
        self.normalizedName = normalized
    }
}

extension FoodItem: Hashable {
    /// Food identity is normalized identity, not presentation casing/spacing.
    public static func == (lhs: FoodItem, rhs: FoodItem) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/// Product-level meal category.
///
/// The product requires a meal type but does not yet fix a closed taxonomy. The
/// standard values are conveniences, while the validated value type remains
/// extensible without a domain-schema migration.
public struct MealType: Hashable, Sendable {
    public let rawValue: String

    public init(_ rawValue: String) throws {
        let value = rawValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !value.isEmpty else {
            throw DomainValidationError.emptyMealType
        }
        self.rawValue = value
    }

    private init(knownValue: String) {
        self.rawValue = knownValue
    }

    public static let breakfast = MealType(knownValue: "breakfast")
    public static let lunch = MealType(knownValue: "lunch")
    public static let dinner = MealType(knownValue: "dinner")
    public static let snack = MealType(knownValue: "snack")
    public static let other = MealType(knownValue: "other")
}

public struct MealLog: Hashable, Sendable {
    public let id: UUID
    public let foods: [FoodItem]
    public let timestamp: Date
    public let timeZone: TimeZoneContext
    public let mealType: MealType
    public let isSpicy: Bool

    public init(
        id: UUID = UUID(),
        foods: [FoodItem],
        timestamp: Date,
        timeZone: TimeZoneContext,
        mealType: MealType,
        isSpicy: Bool
    ) throws {
        guard !foods.isEmpty else {
            throw DomainValidationError.emptyMeal
        }

        self.id = id
        self.foods = foods
        self.timestamp = timestamp
        self.timeZone = timeZone
        self.mealType = mealType
        self.isSpicy = isSpicy
    }
}

/// One normalized food occurrence anchored to a source meal and its time context.
///
/// This is an analysis-input representation only. It deliberately contains no lag
/// weighting, candidate eligibility, correlation, or scoring behavior.
public struct FoodExposure: Hashable, Sendable {
    public struct ID: Hashable, Sendable {
        public let rawValue: String

        fileprivate init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    public let id: ID
    public let mealID: UUID
    public let foodID: FoodItem.ID
    public let timestamp: Date
    public let timeZone: TimeZoneContext
    public let mealType: MealType
    public let isSpicy: Bool

    public init(
        mealID: UUID,
        foodID: FoodItem.ID,
        timestamp: Date,
        timeZone: TimeZoneContext,
        mealType: MealType,
        isSpicy: Bool
    ) {
        self.id = ID(rawValue: Self.makeStableID(mealID: mealID, foodID: foodID))
        self.mealID = mealID
        self.foodID = foodID
        self.timestamp = timestamp
        self.timeZone = timeZone
        self.mealType = mealType
        self.isSpicy = isSpicy
    }

    private static func makeStableID(mealID: UUID, foodID: FoodItem.ID) -> String {
        let food = foodID.rawValue
        return "meal:\(mealID.uuidString.lowercased())|food:\(food.utf8.count):\(food)"
    }
}
