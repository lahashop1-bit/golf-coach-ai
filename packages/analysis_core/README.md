# analysis_core

Pure-Dart swing analysis shared by iOS and Android, so the same video gives
the same result on both platforms (docs/PLATFORM_DECISION.md).

| File | Purpose |
|---|---|
| `lib/src/keypoints.dart` | `.gckp` keypoints file (written by `packages/pose`), mirroring for left-handers |
| `lib/src/signals.dart` | Smoothed hand signal |
| `lib/src/phases.dart` | 8 swing phases + tempo (AI_ANALYSIS_SPEC §11b, §12) |
| `lib/src/issues.dart` | Group-A issue rules, provisional thresholds (AI_ANALYSIS_SPEC §10a) |
| `lib/src/focus.dart` | Priority issue selection (AI_ANALYSIS_SPEC §11) |
| `lib/testing.dart` | Synthetic swings with known timing and faults, for tests |

```sh
dart test
dart run tool/inspect.dart <file.gckp>                 # hand signal + phases
dart run tool/issues.dart <file.gckp> <face_on|down_the_line> [left]   # rule metrics
```
