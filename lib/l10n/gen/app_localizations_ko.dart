// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Golf Coach AI';

  @override
  String get tabHome => '홈';

  @override
  String get tabRecord => '촬영';

  @override
  String get tabLog => '기록';

  @override
  String get tabPractice => '연습';

  @override
  String get actionCancel => '취소';

  @override
  String get actionDelete => '삭제';

  @override
  String get actionSave => '저장';

  @override
  String get actionRetry => '다시 시도';

  @override
  String get actionClose => '닫기';

  @override
  String get errorGeneric => '문제가 발생했습니다. 다시 시도해 주세요.';

  @override
  String get onboardingTitle => '환영합니다';

  @override
  String get onboardingIntro => '스윙을 촬영하고, 느리게 다시 보고, 연습 기록을 관리하세요.';

  @override
  String get languageLabel => '언어';

  @override
  String get languageSystem => '휴대폰 설정과 같게';

  @override
  String get onboardingHandedness => '어느 쪽으로 스윙하나요?';

  @override
  String get handednessRight => '오른손잡이';

  @override
  String get handednessLeft => '왼손잡이';

  @override
  String get onboardingSkill => '실력 (선택)';

  @override
  String get skillBeginner => '입문';

  @override
  String get skillBasic => '초급';

  @override
  String get skillIntermediate => '중급';

  @override
  String get skillAdvanced => '상급';

  @override
  String get privacyLocalOnly => '영상은 이 휴대폰에만 저장됩니다. 앱이 영상을 업로드하지 않습니다.';

  @override
  String get onboardingStart => '시작하기';

  @override
  String get homeGreeting => '안녕하세요!';

  @override
  String get homeRecordCta => '스윙 촬영';

  @override
  String get homeRecentSessions => '최근 연습';

  @override
  String get seeAll => '모두 보기';

  @override
  String get emptySwings => '아직 스윙이 없습니다. 첫 스윙을 촬영해 보세요.';

  @override
  String get settingsTitle => '설정';

  @override
  String get modeGuided => '가이드 분석';

  @override
  String get modeGuidedDesc =>
      '카메라 설치 안내에 따라 몇 번 스윙을 촬영합니다. 자동 분석은 아직 개발 중입니다.';

  @override
  String get modeRecommended => '추천';

  @override
  String get modeSelf => '자유 촬영';

  @override
  String get modeSelfDesc => '촬영하고 저장만 합니다. 나중에 볼 수 있습니다.';

  @override
  String get importVideo => '영상 가져오기';

  @override
  String get setupTitle => '설정';

  @override
  String get cameraAngleLabel => '촬영 각도';

  @override
  String get angleFaceOn => '정면';

  @override
  String get angleDtl => 'DTL';

  @override
  String get angleFaceOnFull => '정면 (Face-on)';

  @override
  String get angleDtlFull => '타깃 라인 후방 (DTL)';

  @override
  String get clubLabel => '클럽';

  @override
  String get clubHint => '아이언, 하이브리드 또는 클럽 없이';

  @override
  String get clubDriver => '드라이버';

  @override
  String get clubWood => '우드';

  @override
  String get clubHybrid => '하이브리드';

  @override
  String get clubIron => '아이언';

  @override
  String get clubWedge => '웨지';

  @override
  String get clubPutter => '퍼터';

  @override
  String get clubNone => '클럽 없음';

  @override
  String get clubNumberLabel => '클럽 번호';

  @override
  String clubWithNumber(String club, int number) {
    return '$number번 $club';
  }

  @override
  String get swingCountLabel => '스윙 횟수';

  @override
  String get feedbackLabel => '다시 보기';

  @override
  String get feedbackAfterEach => '매 스윙 후';

  @override
  String get feedbackEnd => '마지막에';

  @override
  String get subjectLabel => '누구의 스윙';

  @override
  String get subjectSelf => '내 스윙';

  @override
  String get subjectOther => '다른 사람';

  @override
  String get timerLabel => '타이머';

  @override
  String get timerOff => '끄기';

  @override
  String timerSeconds(int seconds) {
    return '$seconds초';
  }

  @override
  String get readyButton => '준비 완료';

  @override
  String get placementTitle => '휴대폰 놓기';

  @override
  String get placementFaceOn =>
      '휴대폰을 정면, 엉덩이 높이에 타깃 라인과 직각으로 놓으세요. 몸 전체와 클럽 헤드가 화면에 보여야 합니다.';

  @override
  String get placementDtl =>
      '휴대폰을 뒤쪽, 손 높이에 타깃 라인 방향으로 놓으세요. 몸 전체와 클럽 헤드가 화면에 보여야 합니다.';

  @override
  String get placementSafety => '휴대폰과 거치대는 스윙 범위와 통로 밖에 두세요.';

  @override
  String get placementLeftHanded => '왼손잡이이므로 반대 방향으로 놓으세요.';

  @override
  String get cameraPermissionDenied =>
      '카메라 권한이 없습니다. 스윙을 촬영하려면 휴대폰 설정에서 허용해 주세요.';

  @override
  String get cameraUnavailable => '이 기기에서 카메라를 찾을 수 없습니다. 영상을 가져올 수는 있습니다.';

  @override
  String get startRecording => '촬영 시작';

  @override
  String get stopRecording => '정지';

  @override
  String get recordingLabel => '촬영 중';

  @override
  String swingProgress(int current, int total) {
    return '스윙 $current/$total';
  }

  @override
  String swingNumber(int number) {
    return '스윙 $number';
  }

  @override
  String get finishSession => '종료';

  @override
  String get flipCamera => '카메라 전환';

  @override
  String get leaveRecordingTitle => '촬영을 끝낼까요?';

  @override
  String get leaveRecordingBody => '저장한 스윙은 유지됩니다.';

  @override
  String get savingSwing => '저장 중…';

  @override
  String get keepSwing => '저장';

  @override
  String get retakeSwing => '다시 찍기';

  @override
  String get qualityGood => '다시 보기에 충분한 영상입니다.';

  @override
  String get qualityTooShort => '영상이 너무 짧습니다. 어드레스부터 피니시까지 촬영하세요.';

  @override
  String qualityLowFps(String fps) {
    return '프레임 속도가 낮습니다 ($fps fps). 느린 재생이 끊겨 보일 수 있습니다.';
  }

  @override
  String get importConfirmTitle => '영상 정보';

  @override
  String get importSave => '영상 저장';

  @override
  String get importing => '영상 가져오는 중…';

  @override
  String get importFailed => '이 영상을 읽을 수 없습니다. 다른 영상을 선택해 주세요.';

  @override
  String get filterAll => '전체';

  @override
  String get filterFavorites => '즐겨찾기';

  @override
  String get favoritesEmpty => '즐겨찾기가 없습니다. 스윙의 별을 눌러 여기에 저장하세요.';

  @override
  String swingCount(int count) {
    return '스윙 $count회';
  }

  @override
  String get sourceImported => '가져온 영상';

  @override
  String get deleteSessionTitle => '이 연습을 삭제할까요?';

  @override
  String get deleteSessionBody => '연습에 포함된 모든 스윙과 영상이 휴대폰에서 삭제됩니다.';

  @override
  String get tabPosture => '자세';

  @override
  String get tabFullSwing => '전체 스윙';

  @override
  String get tabTempo => '템포';

  @override
  String get notAnalyzedTitle => '아직 분석되지 않음';

  @override
  String get notAnalyzedBody =>
      '자세와 템포 분석은 아직 개발 중입니다. 준비되면 이 스윙의 결과가 여기에 표시됩니다.';

  @override
  String get speedLabel => '속도';

  @override
  String get prevFrame => '이전 프레임';

  @override
  String get nextFrame => '다음 프레임';

  @override
  String get play => '재생';

  @override
  String get pause => '일시 정지';

  @override
  String get favoriteAdd => '즐겨찾기에 추가';

  @override
  String get favoriteRemove => '즐겨찾기에서 제거';

  @override
  String get noteLabel => '메모';

  @override
  String get noteHint => '예: 오늘은 공에 더 가까이 서 봄';

  @override
  String get noteAdd => '메모 추가';

  @override
  String get includeInStats => '내 통계에 포함';

  @override
  String get swingInfo => '스윙 정보';

  @override
  String fpsValue(String fps) {
    return '$fps fps';
  }

  @override
  String get durationLabel => '길이';

  @override
  String durationSeconds(String seconds) {
    return '$seconds초';
  }

  @override
  String get recordedAtLabel => '촬영일';

  @override
  String get handednessLabel => '주 사용 손';

  @override
  String get frameRateLabel => '프레임 속도';

  @override
  String get deleteSwingTitle => '이 스윙을 삭제할까요?';

  @override
  String get deleteSwingBody => '영상과 메모가 휴대폰에서 삭제됩니다.';

  @override
  String get videoMissing => '영상 파일을 찾을 수 없습니다.';

  @override
  String swingThumbnail(int number) {
    return '스윙 $number 미리보기';
  }

  @override
  String get practiceEmptyTitle => '연습 프로그램 준비 중';

  @override
  String get practiceEmptyBody =>
      '코치 검토 후 연습 프로그램이 제공됩니다. 그동안 스윙을 촬영하고 다시 보세요.';

  @override
  String get profileLabel => '프로필';

  @override
  String get privacyLabel => '개인정보';

  @override
  String get deleteAllData => '모든 데이터 삭제';

  @override
  String get deleteAllTitle => '모든 데이터를 삭제할까요?';

  @override
  String get deleteAllBody => '이 휴대폰의 모든 영상, 스윙, 프로필이 삭제됩니다. 되돌릴 수 없습니다.';
}
