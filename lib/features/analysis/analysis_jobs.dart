import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';

/// Progress of queued/running analyses by swing id (0–1; queued = 0).
///
/// Runs one analysis at a time: pose inference is heavy, and doing two in
/// parallel only makes both slower and the phone hotter.
class AnalysisJobs extends Notifier<Map<String, double>> {
  final _queue = Queue<String>();
  String? _running;

  @override
  Map<String, double> build() => const {};

  bool isActive(String swingId) => state.containsKey(swingId);

  void enqueue(String swingId) {
    if (isActive(swingId)) return;
    _queue.add(swingId);
    state = {...state, swingId: 0};
    _pump();
  }

  Future<void> cancel(String swingId) async {
    if (_running == swingId) {
      await ref.read(analysisRepositoryProvider).cancel(swingId);
    } else if (_queue.remove(swingId)) {
      state = {...state}..remove(swingId);
    }
  }

  Future<void> _pump() async {
    if (_running != null || _queue.isEmpty) return;
    final id = _running = _queue.removeFirst();
    try {
      await ref.read(analysisRepositoryProvider).run(id, onProgress: (p) {
        if (state.containsKey(id)) state = {...state, id: p};
      });
    } catch (_) {
      // Cancellation removes the row; other failures are recorded on the
      // analysis row by the repository and shown from there.
    } finally {
      _running = null;
      state = {...state}..remove(id);
      _pump();
    }
  }
}

final analysisJobsProvider =
    NotifierProvider<AnalysisJobs, Map<String, double>>(AnalysisJobs.new);
