# ADR-001 — Nền tảng: iOS và Android

- Trạng thái: **Đã chấp nhận** (chủ dự án xác nhận 2026-11-15)
- Ngày: 2026-11-15
- Thay thế: quyết định cũ "Ưu tiên native iOS (Swift/SwiftUI)"

## 1. Bối cảnh

Chủ dự án yêu cầu app chạy trên **cả iPhone và Android**. Trọng tâm MVP là quay video → phân tích tư thế và cú swing trên máy → nêu lỗi → hướng dẫn sửa (PRD mục 5.1). Hai phần khó nhất là **camera** (FPS cao, ổn định) và **pose estimation** (nhanh, kết quả giống nhau trên hai nền tảng).

## 2. Quyết định

**Flutter cho giao diện, domain và dữ liệu; module native (Swift trên iOS, Kotlin trên Android) cho camera và pose estimation; toàn bộ logic phân tích lỗi viết bằng Dart dùng chung.**

```
┌──────────────────────── Flutter (Dart) ────────────────────────┐
│ UI · điều hướng · localization · state · DB local              │
│ Analysis core (Dart thuần): QualityRules · PhaseDetector ·      │
│ TempoCalculator · IssueDetector · FocusSelector · Report        │
└───────────────┬───────────────────────────────┬────────────────┘
                │ Pigeon (kênh có kiểu)          │
     ┌──────────▼──────────┐          ┌─────────▼──────────┐
     │ capture plugin       │          │ pose plugin         │
     │ iOS: AVFoundation    │          │ Cùng một model pose │
     │ Android: CameraX     │          │ trên cả hai nền tảng│
     └──────────────────────┘          └────────────────────┘
```

### Lý do
1. **Một codebase UI** cho hai nền tảng; đội nhỏ vẫn làm được.
2. **Logic phân tích bằng Dart dùng chung** → cùng một video cho cùng một kết quả trên iPhone và Android; chỉ cần kiểm thử và đánh giá một lần.
3. **Cùng một model pose trên hai nền tảng**, không dùng Apple Vision cho iOS và ML Kit cho Android, vì hai model có keypoint khác nhau sẽ làm kết quả lệch theo nền tảng.
4. Máy phát triển đã có Flutter, JDK, Android SDK; có dự án Flutter khác để tham khảo cấu hình.
5. Phần cần hiệu năng thật (camera, inference) vẫn native.

### Các phương án đã cân nhắc

| Phương án | Ưu | Nhược | Kết luận |
|---|---|---|---|
| Hai app native (SwiftUI + Jetpack Compose) | Hiệu năng, trải nghiệm hệ thống tốt nhất | Gấp đôi công UI và logic; khó giữ kết quả phân tích giống nhau | Không chọn |
| React Native | Hệ sinh thái camera tốt | Chưa có toolchain trên máy; vẫn cần native cho inference | Không chọn |
| Kotlin Multiplatform + UI native | Chia sẻ logic | Vẫn hai UI; tooling iOS phức tạp hơn | Không chọn ở MVP |
| **Flutter + module native** | Một UI, logic chung, native khi cần | Cần viết và bảo trì plugin native | **Chọn** |

## 3. Chi tiết kỹ thuật

### 3.1 Camera (plugin `capture`)
- Đánh giá plugin `camera` chính thức trước. Nếu không kiểm soát được FPS cao (120/240 khi thiết bị hỗ trợ), độ ổn định hoặc timestamp khung hình → viết plugin native riêng:
  - iOS: AVFoundation (AVCaptureSession, chọn format theo FPS thực tế thiết bị hỗ trợ).
  - Android: CameraX; kiểm tra high-speed capture qua Camera2 interop khi cần.
- Plugin trả về: đường dẫn file video, FPS thật, độ phân giải, hướng xoay, danh sách FPS khả dụng.
- Chỉ hiển thị tùy chọn FPS thiết bị hỗ trợ (như spec hiện tại).

### 3.2 Pose estimation (plugin `pose`)
- Phân tích **sau khi quay** (offline trên file video), không cần real-time ở MVP → đơn giản và ổn định hơn.
- Ứng viên: MediaPipe Pose Landmarker (có bản cho cả iOS và Android). **Phải kiểm tra giấy phép model và điều khoản trước khi dùng** (AI_ANALYSIS_SPEC mục 2). Ứng viên khác được so sánh ở Phase 3 trên cùng bộ video.
- Plugin nhận đường dẫn video, trả về **đường dẫn tệp keypoints** (nhị phân gọn) thay vì đẩy dữ liệu lớn qua kênh.
- Ưu tiên GPU/Neural Engine; tự rơi về CPU khi không hỗ trợ.

### 3.3 Dart dùng chung
- Analysis core thuần Dart, không phụ thuộc Flutter UI → unit test bằng keypoints mẫu.
- State management: Riverpod (đề xuất; chốt khi tạo skeleton).
- DB local: drift (SQLite), có migration version.
- Video lưu trong vùng riêng của app; playback bằng `video_player`. Tua từng khung hình: thử `seekTo` theo bước 1/FPS ở Phase 1; nếu không chính xác trên một nền tảng thì thêm player native trong plugin `capture`.
- Điều hướng: `go_router`.
- Nhập video: trình chọn ảnh/video hệ thống (PHPicker trên iOS, Photo Picker trên Android) qua plugin.
- Localization: ARB + `flutter gen-l10n`.
- Kênh native: Pigeon để có kiểu dữ liệu an toàn.

### 3.4 Phiên bản hệ điều hành
- **Đã chốt (2026-11-15): iOS 15+ và Android 8.0 (API 26)+.** Sẽ xem lại nếu model pose chọn ở Phase 3 đòi hỏi bản cao hơn.
- iOS dùng Swift Package Manager (Flutter mặc định); không cần CocoaPods.

### 3.5 Thiết kế giao diện đa nền tảng
- Một design system riêng của dự án (không sao chép GolfFix), dựa trên Material 3 và điều chỉnh theo nền tảng:
  - Điều hướng quay lại: vuốt cạnh trên iOS, nút/cử chỉ Back trên Android.
  - Hộp thoại xin quyền, share sheet, trình chọn ảnh, thông báo: dùng của hệ thống.
  - Font hệ thống; hỗ trợ text scaling (Dynamic Type / font scale Android), VoiceOver và TalkBack (Semantics).
- Không dùng hai bộ UI riêng ở MVP.

### 3.6 Phân phối
- iOS: TestFlight → App Store.
- Android: Google Play Internal testing → Closed testing → Production.
- Chính sách quyền riêng tư và khai báo dữ liệu cho cả App Store (Privacy Nutrition Label) và Google Play (Data safety).

## 4. Rủi ro

| Rủi ro | Giảm thiểu |
|---|---|
| Android đa dạng thiết bị, hiệu năng inference khác nhau | Ma trận thiết bị thử nghiệm; đo thời gian phân tích; giới hạn thời lượng video; rơi về CPU |
| FPS cao không có trên nhiều máy Android | Phân tích chấp nhận 30/60 FPS; ghi FPS thật; giảm mức tin cậy cho đo nhịp khi FPS thấp |
| Plugin native tăng chi phí bảo trì | Giữ API plugin nhỏ; test tích hợp trên thiết bị thật cả hai nền tảng |
| Kết quả lệch giữa nền tảng | Cùng model, cùng logic Dart; bộ video regression chạy trên cả hai |
| Build Android native trên Apple Silicon | Build với `--target-platform android-arm64` (NDK `yasm` là binary Intel) |

## 5. Tác động lên tài liệu

Đã cập nhật: CLAUDE.md, README, PRD, UI/UX, Golf Features, AI Analysis, Architecture, I18N, Acceptance, Roadmap, Database.
