import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/labels.dart';
import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../data/swing_repository.dart';
import '../../domain/enums.dart';
import '../../widgets/common.dart';
import 'setup_fields.dart';

/// Session setup + phone placement (UI_UX_SPEC §4.2–4.4).
class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key, required this.guided});

  final bool guided;

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _draft = SetupDraft();
  int _swingCount = 3; // beginner default (GOLF_FEATURES §4)
  FeedbackTiming _feedback = FeedbackTiming.afterEach;
  int _timer = 0;

  void _ready() {
    context.pushReplacement('/camera',
        extra: SessionSetup(
          mode: widget.guided ? SessionMode.guidedAnalysis : SessionMode.selfRecord,
          cameraAngle: _draft.angle,
          clubType: _draft.club,
          clubNumber: _draft.clubNumber,
          subject: _draft.subject,
          plannedSwingCount: widget.guided ? _swingCount : null,
          feedbackTiming: _feedback,
          timerSeconds: _timer,
        ));
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final handedness =
        ref.watch(profileProvider).value?.handedness ?? Handedness.right;
    return Scaffold(
      appBar: AppBar(title: Text(widget.guided ? l.modeGuided : l.modeSelf)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(Gap.m),
          children: [
            SetupFields(draft: _draft, onChanged: () => setState(() {})),
            if (widget.guided)
              ChoiceGroup<int>(
                label: l.swingCountLabel,
                values: const [1, 3, 5, 10],
                selected: _swingCount,
                labelOf: (v) => '$v',
                onSelected: (v) => setState(() => _swingCount = v),
              ),
            ChoiceGroup<FeedbackTiming>(
              label: l.feedbackLabel,
              values: FeedbackTiming.values,
              selected: _feedback,
              labelOf: (v) => v == FeedbackTiming.afterEach
                  ? l.feedbackAfterEach
                  : l.feedbackEnd,
              onSelected: (v) => setState(() => _feedback = v),
            ),
            ChoiceGroup<int>(
              label: l.timerLabel,
              values: const [0, 3, 5, 10],
              selected: _timer,
              labelOf: (v) => v == 0 ? l.timerOff : l.timerSeconds(v),
              onSelected: (v) => setState(() => _timer = v),
            ),
            PlacementGuide(angle: _draft.angle, handedness: handedness),
            const SizedBox(height: Gap.l),
            FilledButton(onPressed: _ready, child: Text(l.readyButton)),
          ],
        ),
      ),
    );
  }
}
