import 'package:analysis_core/analysis_core.dart';
import 'package:capture/capture.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/analysis_repository.dart';
import '../data/db/database.dart';
import '../data/guide_repository.dart';
import '../data/profile_repository.dart';
import '../data/swing_repository.dart';
import '../data/video_store.dart';
import '../domain/enums.dart';

/// Overridden in main() after async init (and in tests).
final databaseProvider =
    Provider<AppDatabase>((ref) => throw UnimplementedError('override'));
final videoStoreProvider =
    Provider<VideoStore>((ref) => throw UnimplementedError('override'));
final captureProvider = Provider<Capture>((ref) => Capture());

final swingRepositoryProvider = Provider<SwingRepository>((ref) =>
    SwingRepository(ref.watch(databaseProvider), ref.watch(videoStoreProvider),
        ref.watch(captureProvider)));

final profileRepositoryProvider = Provider<ProfileRepository>((ref) =>
    ProfileRepository(ref.watch(databaseProvider), ref.watch(videoStoreProvider)));

final profileProvider = StreamProvider<UserProfile?>(
    (ref) => ref.watch(profileRepositoryProvider).watch());

final sessionsProvider = StreamProvider<List<SessionWithSwings>>(
    (ref) => ref.watch(swingRepositoryProvider).watchSessions());

final swingProvider = StreamProvider.family<Swing?, String>(
    (ref, id) => ref.watch(swingRepositoryProvider).watchSwing(id));

final sessionProvider = FutureProvider.family<SwingSession, String>(
    (ref, id) => ref.watch(swingRepositoryProvider).getSession(id));

final poseEngineProvider = Provider<PoseEngine>((ref) => MediaPipePoseEngine());

final guideRepositoryProvider = Provider<GuideRepository>((ref) => GuideRepository());

/// Issue guides for a language code (`vi`, `en`, `ko`).
final issueGuidesProvider = FutureProvider.family<Map<IssueId, IssueGuide>, String>(
    (ref, lang) => ref.watch(guideRepositoryProvider).guides(lang));

final analysisRepositoryProvider = Provider<AnalysisRepository>((ref) =>
    AnalysisRepository(ref.watch(databaseProvider), ref.watch(videoStoreProvider),
        ref.watch(poseEngineProvider), ref.watch(guideRepositoryProvider)));

/// Latest analysis of a swing with its issue observations.
final analysisProvider = StreamProvider.family<AnalysisResult?, String>(
    (ref, swingId) => ref.watch(analysisRepositoryProvider).watchResult(swingId));

/// The user's answer to "was this helpful?" for one observation.
final feedbackProvider = StreamProvider.family<FeedbackValue?, String>(
    (ref, observationId) => ref.watch(analysisRepositoryProvider).watchFeedback(observationId));

/// Keypoints of an analysis (for the skeleton overlay). Data classes from
/// drift compare by value, so the row works as a family key.
final keypointsProvider = FutureProvider.family<KeypointSequence?, SwingAnalysis>(
    (ref, row) => ref.watch(analysisRepositoryProvider).loadKeypoints(row));
