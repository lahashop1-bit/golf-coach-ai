// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Golf Coach AI';

  @override
  String get tabHome => 'Trang chủ';

  @override
  String get tabRecord => 'Quay';

  @override
  String get tabLog => 'Nhật ký';

  @override
  String get tabPractice => 'Luyện tập';

  @override
  String get actionCancel => 'Hủy';

  @override
  String get actionDelete => 'Xóa';

  @override
  String get actionSave => 'Lưu';

  @override
  String get actionRetry => 'Thử lại';

  @override
  String get actionClose => 'Đóng';

  @override
  String get errorGeneric => 'Đã có lỗi. Bạn thử lại nhé.';

  @override
  String get onboardingTitle => 'Chào mừng bạn';

  @override
  String get onboardingIntro =>
      'Quay cú swing, xem lại chậm và theo dõi buổi tập của bạn.';

  @override
  String get languageLabel => 'Ngôn ngữ';

  @override
  String get languageSystem => 'Theo điện thoại';

  @override
  String get onboardingHandedness => 'Bạn đánh bóng thuận tay nào?';

  @override
  String get handednessRight => 'Thuận tay phải';

  @override
  String get handednessLeft => 'Thuận tay trái';

  @override
  String get onboardingSkill => 'Trình độ (không bắt buộc)';

  @override
  String get skillBeginner => 'Mới bắt đầu';

  @override
  String get skillBasic => 'Cơ bản';

  @override
  String get skillIntermediate => 'Trung cấp';

  @override
  String get skillAdvanced => 'Nâng cao';

  @override
  String get privacyLocalOnly =>
      'Video chỉ lưu trên điện thoại này. App không tải video của bạn lên mạng.';

  @override
  String get onboardingStart => 'Bắt đầu';

  @override
  String get homeGreeting => 'Chào bạn!';

  @override
  String get homeRecordCta => 'Quay cú swing';

  @override
  String get homeRecentSessions => 'Buổi tập gần đây';

  @override
  String get seeAll => 'Xem tất cả';

  @override
  String get emptySwings => 'Bạn chưa có cú swing nào. Hãy quay cú đầu tiên.';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get modeGuided => 'Phân tích có hướng dẫn';

  @override
  String get modeGuidedDesc =>
      'Quay vài cú theo hướng dẫn đặt máy. Phần tự động phân tích đang được phát triển.';

  @override
  String get modeRecommended => 'Khuyên dùng';

  @override
  String get modeSelf => 'Tự quay';

  @override
  String get modeSelfDesc => 'Chỉ quay và lưu lại để xem sau.';

  @override
  String get importVideo => 'Nhập video';

  @override
  String get setupTitle => 'Thiết lập';

  @override
  String get cameraAngleLabel => 'Góc quay';

  @override
  String get angleFaceOn => 'Chính diện';

  @override
  String get angleDtl => 'DTL';

  @override
  String get angleFaceOnFull => 'Góc chính diện (Face-on)';

  @override
  String get angleDtlFull => 'Góc dọc đường mục tiêu (DTL)';

  @override
  String get clubLabel => 'Gậy';

  @override
  String get clubHint => 'Gậy sắt, hybrid, hoặc tập không gậy';

  @override
  String get clubDriver => 'Driver';

  @override
  String get clubWood => 'Gậy gỗ';

  @override
  String get clubHybrid => 'Hybrid';

  @override
  String get clubIron => 'Gậy sắt';

  @override
  String get clubWedge => 'Wedge';

  @override
  String get clubPutter => 'Putter';

  @override
  String get clubNone => 'Không gậy';

  @override
  String get clubNumberLabel => 'Số gậy';

  @override
  String clubWithNumber(String club, int number) {
    return '$club số $number';
  }

  @override
  String get swingCountLabel => 'Số cú';

  @override
  String get feedbackLabel => 'Xem lại';

  @override
  String get feedbackAfterEach => 'Sau mỗi cú';

  @override
  String get feedbackEnd => 'Cuối buổi';

  @override
  String get subjectLabel => 'Swing của ai';

  @override
  String get subjectSelf => 'Của tôi';

  @override
  String get subjectOther => 'Của người khác';

  @override
  String get timerLabel => 'Hẹn giờ';

  @override
  String get timerOff => 'Tắt';

  @override
  String timerSeconds(int seconds) {
    return '$seconds giây';
  }

  @override
  String get readyButton => 'Sẵn sàng';

  @override
  String get placementTitle => 'Đặt điện thoại';

  @override
  String get placementFaceOn =>
      'Đặt điện thoại trước mặt bạn, cao ngang hông, vuông góc với đường mục tiêu. Khung hình phải thấy cả người và đầu gậy.';

  @override
  String get placementDtl =>
      'Đặt điện thoại phía sau bạn, nhìn dọc theo đường mục tiêu, cao ngang tay. Khung hình phải thấy cả người và đầu gậy.';

  @override
  String get placementSafety =>
      'Đặt điện thoại và chân máy ngoài vùng vung gậy và lối đi.';

  @override
  String get placementLeftHanded =>
      'Bạn thuận tay trái nên đặt máy theo hướng ngược lại.';

  @override
  String get cameraPermissionDenied =>
      'App chưa có quyền dùng camera. Hãy cho phép trong Cài đặt của điện thoại để quay cú swing.';

  @override
  String get cameraUnavailable =>
      'Không tìm thấy camera trên máy này. Bạn vẫn có thể nhập video.';

  @override
  String get startRecording => 'Bắt đầu quay';

  @override
  String get stopRecording => 'Dừng';

  @override
  String get recordingLabel => 'Đang quay';

  @override
  String swingProgress(int current, int total) {
    return 'Cú $current/$total';
  }

  @override
  String swingNumber(int number) {
    return 'Cú $number';
  }

  @override
  String get finishSession => 'Kết thúc';

  @override
  String get flipCamera => 'Đổi camera';

  @override
  String get leaveRecordingTitle => 'Dừng buổi quay?';

  @override
  String get leaveRecordingBody => 'Các cú bạn đã giữ vẫn được lưu.';

  @override
  String get savingSwing => 'Đang lưu…';

  @override
  String get keepSwing => 'Giữ';

  @override
  String get retakeSwing => 'Quay lại';

  @override
  String get qualityGood => 'Video đủ tốt để xem lại.';

  @override
  String get qualityTooShort =>
      'Video quá ngắn. Hãy quay từ lúc vào bóng tới tư thế kết thúc.';

  @override
  String qualityLowFps(String fps) {
    return 'Tốc độ khung hình thấp ($fps khung/giây). Xem chậm sẽ bị giật.';
  }

  @override
  String get importConfirmTitle => 'Thông tin video';

  @override
  String get importSave => 'Lưu video';

  @override
  String get importing => 'Đang nhập video…';

  @override
  String get importFailed =>
      'Không đọc được video này. Bạn thử video khác nhé.';

  @override
  String get filterAll => 'Tất cả';

  @override
  String get filterFavorites => 'Yêu thích';

  @override
  String get favoritesEmpty =>
      'Chưa có cú yêu thích. Chạm ngôi sao ở một cú để lưu vào đây.';

  @override
  String swingCount(int count) {
    return '$count cú';
  }

  @override
  String get sourceImported => 'Video nhập';

  @override
  String get deleteSessionTitle => 'Xóa buổi tập này?';

  @override
  String get deleteSessionBody =>
      'Mọi cú và video trong buổi sẽ bị xóa khỏi điện thoại.';

  @override
  String get tabPosture => 'Tư thế';

  @override
  String get tabFullSwing => 'Toàn bộ swing';

  @override
  String get tabTempo => 'Nhịp';

  @override
  String get notAnalyzedTitle => 'Chưa phân tích';

  @override
  String get notAnalyzedBody =>
      'Phần phân tích tư thế và nhịp đang được phát triển. Khi sẵn sàng, kết quả của cú này sẽ hiện ở đây.';

  @override
  String get speedLabel => 'Tốc độ';

  @override
  String get prevFrame => 'Khung hình trước';

  @override
  String get nextFrame => 'Khung hình sau';

  @override
  String get play => 'Phát';

  @override
  String get pause => 'Tạm dừng';

  @override
  String get favoriteAdd => 'Thêm vào yêu thích';

  @override
  String get favoriteRemove => 'Bỏ khỏi yêu thích';

  @override
  String get noteLabel => 'Ghi chú';

  @override
  String get noteHint => 'Ví dụ: hôm nay thử đứng gần bóng hơn';

  @override
  String get noteAdd => 'Thêm ghi chú';

  @override
  String get includeInStats => 'Tính vào thống kê của tôi';

  @override
  String get swingInfo => 'Thông tin cú';

  @override
  String fpsValue(String fps) {
    return '$fps khung/giây';
  }

  @override
  String get durationLabel => 'Thời lượng';

  @override
  String durationSeconds(String seconds) {
    return '$seconds giây';
  }

  @override
  String get recordedAtLabel => 'Ngày quay';

  @override
  String get handednessLabel => 'Tay thuận';

  @override
  String get frameRateLabel => 'Tốc độ khung hình';

  @override
  String get deleteSwingTitle => 'Xóa cú này?';

  @override
  String get deleteSwingBody =>
      'Video và ghi chú của cú này sẽ bị xóa khỏi điện thoại.';

  @override
  String get videoMissing => 'Không tìm thấy file video.';

  @override
  String swingThumbnail(int number) {
    return 'Ảnh bìa cú $number';
  }

  @override
  String get practiceEmptyTitle => 'Bài tập đang được biên soạn';

  @override
  String get practiceEmptyBody =>
      'Bài tập sẽ có sau khi huấn luyện viên duyệt. Trong lúc chờ, bạn cứ quay và xem lại cú swing của mình.';

  @override
  String get profileLabel => 'Hồ sơ';

  @override
  String get privacyLabel => 'Quyền riêng tư';

  @override
  String get deleteAllData => 'Xóa toàn bộ dữ liệu';

  @override
  String get deleteAllTitle => 'Xóa toàn bộ dữ liệu?';

  @override
  String get deleteAllBody =>
      'Mọi video, cú swing và hồ sơ trên điện thoại này sẽ bị xóa. Không thể khôi phục.';
}
