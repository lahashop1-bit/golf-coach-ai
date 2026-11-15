import 'package:capture/capture.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/db/database.dart';
import '../data/profile_repository.dart';
import '../data/swing_repository.dart';
import '../data/video_store.dart';

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
