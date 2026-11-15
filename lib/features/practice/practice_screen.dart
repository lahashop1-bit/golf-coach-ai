import 'package:flutter/material.dart';

import '../../app/labels.dart';
import '../../widgets/common.dart';

/// Drill content arrives in Phase 2 after coach review; until then this tab
/// says so honestly instead of showing placeholder drills.
class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.tabPractice)),
      body: EmptyState(
        icon: Icons.menu_book_outlined,
        title: l.practiceEmptyTitle,
        message: l.practiceEmptyBody,
      ),
    );
  }
}
