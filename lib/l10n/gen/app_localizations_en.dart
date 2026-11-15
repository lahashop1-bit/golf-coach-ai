// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Golf Coach AI';

  @override
  String get tabHome => 'Home';

  @override
  String get tabRecord => 'Record';

  @override
  String get tabLog => 'Log';

  @override
  String get tabPractice => 'Practice';

  @override
  String get actionCancel => 'Cancel';

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionSave => 'Save';

  @override
  String get actionRetry => 'Try again';

  @override
  String get actionClose => 'Close';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get onboardingTitle => 'Welcome';

  @override
  String get onboardingIntro =>
      'Record your swing, replay it in slow motion and keep track of your practice.';

  @override
  String get languageLabel => 'Language';

  @override
  String get languageSystem => 'Same as phone';

  @override
  String get onboardingHandedness => 'Which way do you swing?';

  @override
  String get handednessRight => 'Right-handed';

  @override
  String get handednessLeft => 'Left-handed';

  @override
  String get onboardingSkill => 'Your level (optional)';

  @override
  String get skillBeginner => 'Just starting';

  @override
  String get skillBasic => 'Basic';

  @override
  String get skillIntermediate => 'Intermediate';

  @override
  String get skillAdvanced => 'Advanced';

  @override
  String get privacyLocalOnly =>
      'Your videos stay on this phone. The app never uploads them.';

  @override
  String get onboardingStart => 'Get started';

  @override
  String get homeGreeting => 'Hello!';

  @override
  String get homeRecordCta => 'Record a swing';

  @override
  String get homeRecentSessions => 'Recent sessions';

  @override
  String get seeAll => 'See all';

  @override
  String get emptySwings => 'You have no swings yet. Record your first one.';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get modeGuided => 'Guided analysis';

  @override
  String get modeGuidedDesc =>
      'Record a few swings with camera setup tips. Automatic analysis is still in development.';

  @override
  String get modeRecommended => 'Recommended';

  @override
  String get modeSelf => 'Self record';

  @override
  String get modeSelfDesc => 'Just record and save to watch later.';

  @override
  String get importVideo => 'Import a video';

  @override
  String get setupTitle => 'Setup';

  @override
  String get cameraAngleLabel => 'Camera angle';

  @override
  String get angleFaceOn => 'Face-on';

  @override
  String get angleDtl => 'DTL';

  @override
  String get angleFaceOnFull => 'Face-on view';

  @override
  String get angleDtlFull => 'Down-the-line view (DTL)';

  @override
  String get clubLabel => 'Club';

  @override
  String get clubHint => 'Iron, hybrid, or no club';

  @override
  String get clubDriver => 'Driver';

  @override
  String get clubWood => 'Wood';

  @override
  String get clubHybrid => 'Hybrid';

  @override
  String get clubIron => 'Iron';

  @override
  String get clubWedge => 'Wedge';

  @override
  String get clubPutter => 'Putter';

  @override
  String get clubNone => 'No club';

  @override
  String get clubNumberLabel => 'Club number';

  @override
  String clubWithNumber(String club, int number) {
    return '$club $number';
  }

  @override
  String get swingCountLabel => 'Number of swings';

  @override
  String get feedbackLabel => 'Review';

  @override
  String get feedbackAfterEach => 'After each swing';

  @override
  String get feedbackEnd => 'At the end';

  @override
  String get subjectLabel => 'Whose swing';

  @override
  String get subjectSelf => 'Mine';

  @override
  String get subjectOther => 'Someone else\'s';

  @override
  String get timerLabel => 'Timer';

  @override
  String get timerOff => 'Off';

  @override
  String timerSeconds(int seconds) {
    return '$seconds s';
  }

  @override
  String get readyButton => 'Ready';

  @override
  String get placementTitle => 'Placing the phone';

  @override
  String get placementFaceOn =>
      'Place the phone in front of you at hip height, facing you square to the target line. Your whole body and the club head must be in the frame.';

  @override
  String get placementDtl =>
      'Place the phone behind you, looking down the target line, at hand height. Your whole body and the club head must be in the frame.';

  @override
  String get placementSafety =>
      'Keep the phone and stand out of your swing path and walkways.';

  @override
  String get placementLeftHanded =>
      'You swing left-handed, so mirror this setup.';

  @override
  String get cameraPermissionDenied =>
      'The app has no camera access. Allow it in your phone\'s Settings to record swings.';

  @override
  String get cameraUnavailable =>
      'No camera found on this device. You can still import a video.';

  @override
  String get startRecording => 'Start recording';

  @override
  String get stopRecording => 'Stop';

  @override
  String get recordingLabel => 'Recording';

  @override
  String swingProgress(int current, int total) {
    return 'Swing $current/$total';
  }

  @override
  String swingNumber(int number) {
    return 'Swing $number';
  }

  @override
  String get finishSession => 'Finish';

  @override
  String get flipCamera => 'Switch camera';

  @override
  String get leaveRecordingTitle => 'Stop this session?';

  @override
  String get leaveRecordingBody => 'Swings you kept are saved.';

  @override
  String get savingSwing => 'Saving…';

  @override
  String get keepSwing => 'Keep';

  @override
  String get retakeSwing => 'Retake';

  @override
  String get qualityGood => 'This video is good for replay.';

  @override
  String get qualityTooShort =>
      'The video is too short. Record from address to finish.';

  @override
  String qualityLowFps(String fps) {
    return 'Low frame rate ($fps fps). Slow motion will look choppy.';
  }

  @override
  String get importConfirmTitle => 'About this video';

  @override
  String get importSave => 'Save video';

  @override
  String get importing => 'Importing video…';

  @override
  String get importFailed => 'This video can\'t be read. Try another one.';

  @override
  String get filterAll => 'All';

  @override
  String get filterFavorites => 'Favorites';

  @override
  String get favoritesEmpty =>
      'No favorites yet. Tap the star on a swing to save it here.';

  @override
  String swingCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count swings',
      one: '1 swing',
    );
    return '$_temp0';
  }

  @override
  String get sourceImported => 'Imported';

  @override
  String get deleteSessionTitle => 'Delete this session?';

  @override
  String get deleteSessionBody =>
      'All swings and videos in it will be removed from this phone.';

  @override
  String get tabPosture => 'Posture';

  @override
  String get tabFullSwing => 'Full swing';

  @override
  String get tabTempo => 'Tempo';

  @override
  String get notAnalyzedTitle => 'Not analyzed yet';

  @override
  String get notAnalyzedBody =>
      'Posture and tempo analysis is still in development. When it is ready, results for this swing will show here.';

  @override
  String get speedLabel => 'Speed';

  @override
  String get prevFrame => 'Previous frame';

  @override
  String get nextFrame => 'Next frame';

  @override
  String get play => 'Play';

  @override
  String get pause => 'Pause';

  @override
  String get favoriteAdd => 'Add to favorites';

  @override
  String get favoriteRemove => 'Remove from favorites';

  @override
  String get noteLabel => 'Note';

  @override
  String get noteHint => 'e.g. tried standing closer to the ball today';

  @override
  String get noteAdd => 'Add a note';

  @override
  String get includeInStats => 'Count in my stats';

  @override
  String get swingInfo => 'Swing details';

  @override
  String fpsValue(String fps) {
    return '$fps fps';
  }

  @override
  String get durationLabel => 'Length';

  @override
  String durationSeconds(String seconds) {
    return '$seconds s';
  }

  @override
  String get recordedAtLabel => 'Recorded';

  @override
  String get handednessLabel => 'Handedness';

  @override
  String get frameRateLabel => 'Frame rate';

  @override
  String get deleteSwingTitle => 'Delete this swing?';

  @override
  String get deleteSwingBody =>
      'Its video and note will be removed from this phone.';

  @override
  String get videoMissing => 'Video file not found.';

  @override
  String swingThumbnail(int number) {
    return 'Swing $number thumbnail';
  }

  @override
  String get practiceEmptyTitle => 'Drills are being written';

  @override
  String get practiceEmptyBody =>
      'Drills will appear after a coach reviews them. Meanwhile, record and replay your swings.';

  @override
  String get profileLabel => 'Profile';

  @override
  String get privacyLabel => 'Privacy';

  @override
  String get deleteAllData => 'Delete all data';

  @override
  String get deleteAllTitle => 'Delete all data?';

  @override
  String get deleteAllBody =>
      'Every video, swing and your profile on this phone will be deleted. This can\'t be undone.';
}
