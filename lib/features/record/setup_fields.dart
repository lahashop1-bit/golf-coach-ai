import 'package:flutter/material.dart';

import '../../app/labels.dart';
import '../../app/theme.dart';
import '../../domain/enums.dart';
import '../../widgets/common.dart';

/// Mutable draft for the fields shared by the record setup and the import
/// confirmation (UI_UX_SPEC §4.4, §4.6).
class SetupDraft {
  CameraAngle angle = CameraAngle.faceOn;
  ClubType club = ClubType.iron;
  int clubNumber = 7;
  Subject subject = Subject.self;
}

const _clubNumbers = {
  ClubType.iron: [3, 4, 5, 6, 7, 8, 9],
  ClubType.wood: [3, 5, 7],
  ClubType.hybrid: [2, 3, 4, 5, 6],
};

class SetupFields extends StatelessWidget {
  const SetupFields({super.key, required this.draft, required this.onChanged});

  final SetupDraft draft;
  final VoidCallback onChanged;

  void _set(void Function() f) {
    f();
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final numbers = _clubNumbers[draft.club];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChoiceGroup<CameraAngle>(
          label: l.cameraAngleLabel,
          values: CameraAngle.values,
          selected: draft.angle,
          labelOf: (v) => v.fullLabel(l),
          onSelected: (v) => _set(() => draft.angle = v),
        ),
        ChoiceGroup<ClubType>(
          label: l.clubLabel,
          hint: l.clubHint,
          values: ClubType.values,
          selected: draft.club,
          labelOf: (v) => v.label(l),
          onSelected: (v) => _set(() {
            draft.club = v;
            final n = _clubNumbers[v];
            if (n != null && !n.contains(draft.clubNumber)) {
              draft.clubNumber = n.first;
            }
          }),
        ),
        if (numbers != null)
          ChoiceGroup<int>(
            label: l.clubNumberLabel,
            values: numbers,
            selected: draft.clubNumber,
            labelOf: (v) => '$v',
            onSelected: (v) => _set(() => draft.clubNumber = v),
          ),
        ChoiceGroup<Subject>(
          label: l.subjectLabel,
          values: Subject.values,
          selected: draft.subject,
          labelOf: (v) => v.label(l),
          onSelected: (v) => _set(() => draft.subject = v),
        ),
      ],
    );
  }
}

/// Text guide for phone placement. A drawn diagram replaces this in Phase 1.
class PlacementGuide extends StatelessWidget {
  const PlacementGuide({super.key, required this.angle, required this.handedness});

  final CameraAngle angle;
  final Handedness handedness;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(Gap.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l.placementTitle, style: theme.textTheme.titleMedium),
            const SizedBox(height: Gap.s),
            Text(angle == CameraAngle.faceOn ? l.placementFaceOn : l.placementDtl),
            if (handedness == Handedness.left) ...[
              const SizedBox(height: Gap.s),
              Text(l.placementLeftHanded),
            ],
            const SizedBox(height: Gap.s),
            Row(children: [
              const Icon(Icons.warning_amber_rounded, size: 20),
              const SizedBox(width: Gap.s),
              Expanded(child: Text(l.placementSafety)),
            ]),
          ],
        ),
      ),
    );
  }
}
