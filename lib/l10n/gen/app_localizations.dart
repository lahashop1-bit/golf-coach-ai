import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Golf Coach AI'**
  String get appTitle;

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabRecord.
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get tabRecord;

  /// No description provided for @tabLog.
  ///
  /// In en, this message translates to:
  /// **'Log'**
  String get tabLog;

  /// No description provided for @tabPractice.
  ///
  /// In en, this message translates to:
  /// **'Practice'**
  String get tabPractice;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionRetry.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get actionRetry;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get onboardingTitle;

  /// No description provided for @onboardingIntro.
  ///
  /// In en, this message translates to:
  /// **'Record your swing, replay it in slow motion and keep track of your practice.'**
  String get onboardingIntro;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @languageSystem.
  ///
  /// In en, this message translates to:
  /// **'Same as phone'**
  String get languageSystem;

  /// No description provided for @onboardingHandedness.
  ///
  /// In en, this message translates to:
  /// **'Which way do you swing?'**
  String get onboardingHandedness;

  /// No description provided for @handednessRight.
  ///
  /// In en, this message translates to:
  /// **'Right-handed'**
  String get handednessRight;

  /// No description provided for @handednessLeft.
  ///
  /// In en, this message translates to:
  /// **'Left-handed'**
  String get handednessLeft;

  /// No description provided for @onboardingSkill.
  ///
  /// In en, this message translates to:
  /// **'Your level (optional)'**
  String get onboardingSkill;

  /// No description provided for @skillBeginner.
  ///
  /// In en, this message translates to:
  /// **'Just starting'**
  String get skillBeginner;

  /// No description provided for @skillBasic.
  ///
  /// In en, this message translates to:
  /// **'Basic'**
  String get skillBasic;

  /// No description provided for @skillIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get skillIntermediate;

  /// No description provided for @skillAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get skillAdvanced;

  /// No description provided for @privacyLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Your videos stay on this phone. The app never uploads them.'**
  String get privacyLocalOnly;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingStart;

  /// No description provided for @homeGreeting.
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get homeGreeting;

  /// No description provided for @homeRecordCta.
  ///
  /// In en, this message translates to:
  /// **'Record a swing'**
  String get homeRecordCta;

  /// No description provided for @homeRecentSessions.
  ///
  /// In en, this message translates to:
  /// **'Recent sessions'**
  String get homeRecentSessions;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See all'**
  String get seeAll;

  /// No description provided for @emptySwings.
  ///
  /// In en, this message translates to:
  /// **'You have no swings yet. Record your first one.'**
  String get emptySwings;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @modeGuided.
  ///
  /// In en, this message translates to:
  /// **'Guided analysis'**
  String get modeGuided;

  /// No description provided for @modeGuidedDesc.
  ///
  /// In en, this message translates to:
  /// **'Record a few swings with camera setup tips. Automatic analysis is still in development.'**
  String get modeGuidedDesc;

  /// No description provided for @modeRecommended.
  ///
  /// In en, this message translates to:
  /// **'Recommended'**
  String get modeRecommended;

  /// No description provided for @modeSelf.
  ///
  /// In en, this message translates to:
  /// **'Self record'**
  String get modeSelf;

  /// No description provided for @modeSelfDesc.
  ///
  /// In en, this message translates to:
  /// **'Just record and save to watch later.'**
  String get modeSelfDesc;

  /// No description provided for @importVideo.
  ///
  /// In en, this message translates to:
  /// **'Import a video'**
  String get importVideo;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'Setup'**
  String get setupTitle;

  /// No description provided for @cameraAngleLabel.
  ///
  /// In en, this message translates to:
  /// **'Camera angle'**
  String get cameraAngleLabel;

  /// No description provided for @angleFaceOn.
  ///
  /// In en, this message translates to:
  /// **'Face-on'**
  String get angleFaceOn;

  /// No description provided for @angleDtl.
  ///
  /// In en, this message translates to:
  /// **'DTL'**
  String get angleDtl;

  /// No description provided for @angleFaceOnFull.
  ///
  /// In en, this message translates to:
  /// **'Face-on view'**
  String get angleFaceOnFull;

  /// No description provided for @angleDtlFull.
  ///
  /// In en, this message translates to:
  /// **'Down-the-line view (DTL)'**
  String get angleDtlFull;

  /// No description provided for @clubLabel.
  ///
  /// In en, this message translates to:
  /// **'Club'**
  String get clubLabel;

  /// No description provided for @clubHint.
  ///
  /// In en, this message translates to:
  /// **'Iron, hybrid, or no club'**
  String get clubHint;

  /// No description provided for @clubDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get clubDriver;

  /// No description provided for @clubWood.
  ///
  /// In en, this message translates to:
  /// **'Wood'**
  String get clubWood;

  /// No description provided for @clubHybrid.
  ///
  /// In en, this message translates to:
  /// **'Hybrid'**
  String get clubHybrid;

  /// No description provided for @clubIron.
  ///
  /// In en, this message translates to:
  /// **'Iron'**
  String get clubIron;

  /// No description provided for @clubWedge.
  ///
  /// In en, this message translates to:
  /// **'Wedge'**
  String get clubWedge;

  /// No description provided for @clubPutter.
  ///
  /// In en, this message translates to:
  /// **'Putter'**
  String get clubPutter;

  /// No description provided for @clubNone.
  ///
  /// In en, this message translates to:
  /// **'No club'**
  String get clubNone;

  /// No description provided for @clubNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Club number'**
  String get clubNumberLabel;

  /// No description provided for @clubWithNumber.
  ///
  /// In en, this message translates to:
  /// **'{club} {number}'**
  String clubWithNumber(String club, int number);

  /// No description provided for @swingCountLabel.
  ///
  /// In en, this message translates to:
  /// **'Number of swings'**
  String get swingCountLabel;

  /// No description provided for @feedbackLabel.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get feedbackLabel;

  /// No description provided for @feedbackAfterEach.
  ///
  /// In en, this message translates to:
  /// **'After each swing'**
  String get feedbackAfterEach;

  /// No description provided for @feedbackEnd.
  ///
  /// In en, this message translates to:
  /// **'At the end'**
  String get feedbackEnd;

  /// No description provided for @subjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Whose swing'**
  String get subjectLabel;

  /// No description provided for @subjectSelf.
  ///
  /// In en, this message translates to:
  /// **'Mine'**
  String get subjectSelf;

  /// No description provided for @subjectOther.
  ///
  /// In en, this message translates to:
  /// **'Someone else\'s'**
  String get subjectOther;

  /// No description provided for @timerLabel.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timerLabel;

  /// No description provided for @timerOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get timerOff;

  /// No description provided for @timerSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s'**
  String timerSeconds(int seconds);

  /// No description provided for @readyButton.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get readyButton;

  /// No description provided for @placementTitle.
  ///
  /// In en, this message translates to:
  /// **'Placing the phone'**
  String get placementTitle;

  /// No description provided for @placementFaceOn.
  ///
  /// In en, this message translates to:
  /// **'Place the phone in front of you at hip height, facing you square to the target line. Your whole body and the club head must be in the frame.'**
  String get placementFaceOn;

  /// No description provided for @placementDtl.
  ///
  /// In en, this message translates to:
  /// **'Place the phone behind you, looking down the target line, at hand height. Your whole body and the club head must be in the frame.'**
  String get placementDtl;

  /// No description provided for @placementSafety.
  ///
  /// In en, this message translates to:
  /// **'Keep the phone and stand out of your swing path and walkways.'**
  String get placementSafety;

  /// No description provided for @placementLeftHanded.
  ///
  /// In en, this message translates to:
  /// **'You swing left-handed, so mirror this setup.'**
  String get placementLeftHanded;

  /// No description provided for @cameraPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'The app has no camera access. Allow it in your phone\'s Settings to record swings.'**
  String get cameraPermissionDenied;

  /// No description provided for @cameraUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No camera found on this device. You can still import a video.'**
  String get cameraUnavailable;

  /// No description provided for @startRecording.
  ///
  /// In en, this message translates to:
  /// **'Start recording'**
  String get startRecording;

  /// No description provided for @stopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopRecording;

  /// No description provided for @recordingLabel.
  ///
  /// In en, this message translates to:
  /// **'Recording'**
  String get recordingLabel;

  /// No description provided for @swingProgress.
  ///
  /// In en, this message translates to:
  /// **'Swing {current}/{total}'**
  String swingProgress(int current, int total);

  /// No description provided for @swingNumber.
  ///
  /// In en, this message translates to:
  /// **'Swing {number}'**
  String swingNumber(int number);

  /// No description provided for @finishSession.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finishSession;

  /// No description provided for @flipCamera.
  ///
  /// In en, this message translates to:
  /// **'Switch camera'**
  String get flipCamera;

  /// No description provided for @leaveRecordingTitle.
  ///
  /// In en, this message translates to:
  /// **'Stop this session?'**
  String get leaveRecordingTitle;

  /// No description provided for @leaveRecordingBody.
  ///
  /// In en, this message translates to:
  /// **'Swings you kept are saved.'**
  String get leaveRecordingBody;

  /// No description provided for @savingSwing.
  ///
  /// In en, this message translates to:
  /// **'Saving…'**
  String get savingSwing;

  /// No description provided for @keepSwing.
  ///
  /// In en, this message translates to:
  /// **'Keep'**
  String get keepSwing;

  /// No description provided for @retakeSwing.
  ///
  /// In en, this message translates to:
  /// **'Retake'**
  String get retakeSwing;

  /// No description provided for @qualityGood.
  ///
  /// In en, this message translates to:
  /// **'This video is good for replay.'**
  String get qualityGood;

  /// No description provided for @qualityTooShort.
  ///
  /// In en, this message translates to:
  /// **'The video is too short. Record from address to finish.'**
  String get qualityTooShort;

  /// No description provided for @qualityLowFps.
  ///
  /// In en, this message translates to:
  /// **'Low frame rate ({fps} fps). Slow motion will look choppy.'**
  String qualityLowFps(String fps);

  /// No description provided for @importConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'About this video'**
  String get importConfirmTitle;

  /// No description provided for @importSave.
  ///
  /// In en, this message translates to:
  /// **'Save video'**
  String get importSave;

  /// No description provided for @importing.
  ///
  /// In en, this message translates to:
  /// **'Importing video…'**
  String get importing;

  /// No description provided for @importFailed.
  ///
  /// In en, this message translates to:
  /// **'This video can\'t be read. Try another one.'**
  String get importFailed;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get filterFavorites;

  /// No description provided for @favoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No favorites yet. Tap the star on a swing to save it here.'**
  String get favoritesEmpty;

  /// No description provided for @swingCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 swing} other{{count} swings}}'**
  String swingCount(int count);

  /// No description provided for @sourceImported.
  ///
  /// In en, this message translates to:
  /// **'Imported'**
  String get sourceImported;

  /// No description provided for @deleteSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this session?'**
  String get deleteSessionTitle;

  /// No description provided for @deleteSessionBody.
  ///
  /// In en, this message translates to:
  /// **'All swings and videos in it will be removed from this phone.'**
  String get deleteSessionBody;

  /// No description provided for @tabPosture.
  ///
  /// In en, this message translates to:
  /// **'Posture'**
  String get tabPosture;

  /// No description provided for @tabFullSwing.
  ///
  /// In en, this message translates to:
  /// **'Full swing'**
  String get tabFullSwing;

  /// No description provided for @tabTempo.
  ///
  /// In en, this message translates to:
  /// **'Tempo'**
  String get tabTempo;

  /// No description provided for @speedLabel.
  ///
  /// In en, this message translates to:
  /// **'Speed'**
  String get speedLabel;

  /// No description provided for @prevFrame.
  ///
  /// In en, this message translates to:
  /// **'Previous frame'**
  String get prevFrame;

  /// No description provided for @nextFrame.
  ///
  /// In en, this message translates to:
  /// **'Next frame'**
  String get nextFrame;

  /// No description provided for @play.
  ///
  /// In en, this message translates to:
  /// **'Play'**
  String get play;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @favoriteAdd.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get favoriteAdd;

  /// No description provided for @favoriteRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get favoriteRemove;

  /// No description provided for @noteLabel.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteLabel;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. tried standing closer to the ball today'**
  String get noteHint;

  /// No description provided for @noteAdd.
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get noteAdd;

  /// No description provided for @includeInStats.
  ///
  /// In en, this message translates to:
  /// **'Count in my stats'**
  String get includeInStats;

  /// No description provided for @swingInfo.
  ///
  /// In en, this message translates to:
  /// **'Swing details'**
  String get swingInfo;

  /// No description provided for @fpsValue.
  ///
  /// In en, this message translates to:
  /// **'{fps} fps'**
  String fpsValue(String fps);

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Length'**
  String get durationLabel;

  /// No description provided for @durationSeconds.
  ///
  /// In en, this message translates to:
  /// **'{seconds} s'**
  String durationSeconds(String seconds);

  /// No description provided for @recordedAtLabel.
  ///
  /// In en, this message translates to:
  /// **'Recorded'**
  String get recordedAtLabel;

  /// No description provided for @handednessLabel.
  ///
  /// In en, this message translates to:
  /// **'Handedness'**
  String get handednessLabel;

  /// No description provided for @frameRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Frame rate'**
  String get frameRateLabel;

  /// No description provided for @deleteSwingTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this swing?'**
  String get deleteSwingTitle;

  /// No description provided for @deleteSwingBody.
  ///
  /// In en, this message translates to:
  /// **'Its video and note will be removed from this phone.'**
  String get deleteSwingBody;

  /// No description provided for @videoMissing.
  ///
  /// In en, this message translates to:
  /// **'Video file not found.'**
  String get videoMissing;

  /// No description provided for @swingThumbnail.
  ///
  /// In en, this message translates to:
  /// **'Swing {number} thumbnail'**
  String swingThumbnail(int number);

  /// No description provided for @practiceEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Drills are being written'**
  String get practiceEmptyTitle;

  /// No description provided for @practiceEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Drills will appear after a coach reviews them. Meanwhile, record and replay your swings.'**
  String get practiceEmptyBody;

  /// No description provided for @profileLabel.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileLabel;

  /// No description provided for @privacyLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyLabel;

  /// No description provided for @deleteAllData.
  ///
  /// In en, this message translates to:
  /// **'Delete all data'**
  String get deleteAllData;

  /// No description provided for @deleteAllTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete all data?'**
  String get deleteAllTitle;

  /// No description provided for @deleteAllBody.
  ///
  /// In en, this message translates to:
  /// **'Every video, swing and your profile on this phone will be deleted. This can\'t be undone.'**
  String get deleteAllBody;

  /// No description provided for @phaseAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get phaseAddress;

  /// No description provided for @phaseTakeaway.
  ///
  /// In en, this message translates to:
  /// **'Takeaway'**
  String get phaseTakeaway;

  /// No description provided for @phaseBackswing.
  ///
  /// In en, this message translates to:
  /// **'Backswing'**
  String get phaseBackswing;

  /// No description provided for @phaseTop.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get phaseTop;

  /// No description provided for @phaseDownswing.
  ///
  /// In en, this message translates to:
  /// **'Downswing'**
  String get phaseDownswing;

  /// No description provided for @phaseImpact.
  ///
  /// In en, this message translates to:
  /// **'Impact'**
  String get phaseImpact;

  /// No description provided for @phaseFollowThrough.
  ///
  /// In en, this message translates to:
  /// **'Follow-through'**
  String get phaseFollowThrough;

  /// No description provided for @phaseFinish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get phaseFinish;

  /// No description provided for @analyzeSwing.
  ///
  /// In en, this message translates to:
  /// **'Analyze this swing'**
  String get analyzeSwing;

  /// No description provided for @analyzeAgain.
  ///
  /// In en, this message translates to:
  /// **'Analyze again'**
  String get analyzeAgain;

  /// No description provided for @analyzingLabel.
  ///
  /// In en, this message translates to:
  /// **'Analyzing…'**
  String get analyzingLabel;

  /// No description provided for @analysisQueued.
  ///
  /// In en, this message translates to:
  /// **'Waiting to analyze…'**
  String get analysisQueued;

  /// No description provided for @analysisFailed.
  ///
  /// In en, this message translates to:
  /// **'This swing couldn\'t be analyzed. Please try again.'**
  String get analysisFailed;

  /// No description provided for @analysisUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Analysis isn\'t available on this device yet.'**
  String get analysisUnsupported;

  /// No description provided for @analysisNoSwing.
  ///
  /// In en, this message translates to:
  /// **'No full swing was found. Record from address to finish with your whole body in the frame.'**
  String get analysisNoSwing;

  /// No description provided for @skeletonToggle.
  ///
  /// In en, this message translates to:
  /// **'Skeleton'**
  String get skeletonToggle;

  /// No description provided for @tempoBackswing.
  ///
  /// In en, this message translates to:
  /// **'Backswing'**
  String get tempoBackswing;

  /// No description provided for @tempoTopPause.
  ///
  /// In en, this message translates to:
  /// **'Pause at the top'**
  String get tempoTopPause;

  /// No description provided for @tempoDownswing.
  ///
  /// In en, this message translates to:
  /// **'Downswing'**
  String get tempoDownswing;

  /// No description provided for @tempoRatio.
  ///
  /// In en, this message translates to:
  /// **'Rhythm ratio'**
  String get tempoRatio;

  /// No description provided for @tempoRatioValue.
  ///
  /// In en, this message translates to:
  /// **'{ratio} : 1'**
  String tempoRatioValue(String ratio);

  /// No description provided for @tempoRatioHint.
  ///
  /// In en, this message translates to:
  /// **'Backswing time divided by downswing time.'**
  String get tempoRatioHint;

  /// No description provided for @tempoEstimate.
  ///
  /// In en, this message translates to:
  /// **'Estimated from video ({fps} fps). Accuracy depends on the frame rate.'**
  String tempoEstimate(String fps);

  /// No description provided for @tempoMaybe.
  ///
  /// In en, this message translates to:
  /// **'These numbers may be off: the frame rate or hand visibility is limited.'**
  String get tempoMaybe;

  /// No description provided for @tempoInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Not enough data to measure the tempo of this swing.'**
  String get tempoInsufficient;

  /// No description provided for @levelInsufficientData.
  ///
  /// In en, this message translates to:
  /// **'Not enough data'**
  String get levelInsufficientData;

  /// No description provided for @phasesTitle.
  ///
  /// In en, this message translates to:
  /// **'Swing phases'**
  String get phasesTitle;

  /// No description provided for @phaseFound.
  ///
  /// In en, this message translates to:
  /// **'Found'**
  String get phaseFound;

  /// No description provided for @postureTrialTitle.
  ///
  /// In en, this message translates to:
  /// **'Posture feedback is being tested'**
  String get postureTrialTitle;

  /// No description provided for @postureTrialBody.
  ///
  /// In en, this message translates to:
  /// **'The swing phases are found. Comments on posture come in a later version.'**
  String get postureTrialBody;

  /// No description provided for @limitSingle2dView.
  ///
  /// In en, this message translates to:
  /// **'A 2D video cannot show all 3D movement.'**
  String get limitSingle2dView;

  /// No description provided for @limitLowFps.
  ///
  /// In en, this message translates to:
  /// **'Low frame rate: phase times are approximate.'**
  String get limitLowFps;

  /// No description provided for @experimentalLabel.
  ///
  /// In en, this message translates to:
  /// **'Experimental'**
  String get experimentalLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
