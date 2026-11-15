import 'package:flutter/foundation.dart';

/// Issue feedback (group-A rules) is an unvalidated prototype and must not
/// reach end users before the release gate (ACCEPTANCE_CRITERIA §8). It is on
/// in debug/profile builds and off in release builds unless built with
/// `--dart-define=EXPERIMENTAL_ISSUES=true` for an internal tester build.
const experimentalIssues =
    bool.fromEnvironment('EXPERIMENTAL_ISSUES', defaultValue: !kReleaseMode);
