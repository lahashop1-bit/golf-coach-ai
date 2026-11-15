import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path_provider/path_provider.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'data/db/database.dart';
import 'data/video_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  final docs = await getApplicationDocumentsDirectory();
  final container = ProviderContainer(overrides: [
    databaseProvider.overrideWithValue(AppDatabase()),
    videoStoreProvider.overrideWithValue(VideoStore(docs)),
  ]);
  await container.read(swingRepositoryProvider).recoverInterruptedSessions();
  runApp(UncontrolledProviderScope(
    container: container,
    child: const GolfCoachApp(),
  ));
}
