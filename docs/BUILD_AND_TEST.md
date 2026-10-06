# Local Build and Test

Issue #25 bootstraps the native iOS/Swift foundation. GitHub Actions runtime is currently exhausted, so the maintainer's local Mac is the validation authority.

## Requirements

- macOS with Xcode 15 or newer
- Xcode command-line tools selected
- Swift toolchain bundled with Xcode

The production app target is native iOS SwiftUI. The core package also declares macOS support only so its UI-independent tests can run headlessly with `swift test`.

## Structure

```text
DietTracking.xcodeproj
└── DietTracking (native iOS SwiftUI app)
    └── local package: Packages/DietTrackingCore

Packages/DietTrackingCore
├── DietTrackingDomain
├── DietTrackingStorage   -> DietTrackingDomain
├── DietTrackingAnalysis  -> DietTrackingDomain
└── DietTrackingLogging   -> DietTrackingDomain + DietTrackingStorage
```

The SwiftUI app may depend on the core. Core targets must not import SwiftUI.

Issue #25 intentionally contains only module-boundary markers. It does not implement the Issue #5 domain model, Issue #6 storage contracts, Issue #11 logging behavior, temporal/scoring algorithms, persistence-framework choice, ads, or product UI.

## Headless core tests

From the repository root:

```sh
swift test --package-path Packages/DietTrackingCore
```

Expected: `CoreModuleWiringTests.testCoreModulesAreHeadlesslyWired` passes.

## Native iOS build

From the repository root:

```sh
xcodebuild \
  -project DietTracking.xcodeproj \
  -scheme DietTracking \
  -destination 'generic/platform=iOS Simulator' \
  CODE_SIGNING_ALLOWED=NO \
  build
```

This uses a generic simulator destination and does not depend on a particular installed simulator model.

## Architecture checks

Use standard `grep`, per repository policy:

```sh
grep -R -n --exclude-dir=.git "import SwiftUI" .
grep -R -n --exclude-dir=.git "import SwiftUI" Packages/DietTrackingCore/Sources || true
grep -R -n --exclude-dir=.git -E "React Native|Flutter|Kotlin Multiplatform|Electron" Packages DietTracking DietTracking.xcodeproj || true
```

Manual review requirement:

- `import SwiftUI` may appear only under `DietTracking/`.
- It must not appear under `Packages/DietTrackingCore/Sources`.
- No cross-platform production framework should be present.

## Xcode junk / secrets check

Before review:

```sh
git status --short
find . -name xcuserdata -o -name '*.xcuserstate' -o -name DerivedData
grep -R -n --exclude-dir=.git "/Users/" . || true
grep -R -n --exclude-dir=.git -E "(API_KEY|SECRET|PASSWORD|TOKEN)[[:space:]]*=" . || true
```

Do not commit machine-specific signing team IDs, absolute local paths, credentials, DerivedData, or user Xcode state.

## Validation status for the bootstrap PR

Maintainer local-Mac validation is complete and passing.

Confirmed results:

- SwiftPM/XCTest: **1 test, 0 failures**.
- Native iOS `xcodebuild`: **BUILD SUCCEEDED**.
- Core SwiftUI grep: **no matches**.
- SwiftUI imports are confined to the app layer.

The exact validation commands above were executed on the maintainer's local Mac and their actual results are recorded on PR #27.
