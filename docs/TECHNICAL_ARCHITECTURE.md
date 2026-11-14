# Technical Architecture

## 1. Nguyên tắc kiến trúc

MVP ưu tiên iOS native để tận dụng camera, hiệu năng và trải nghiệm hệ thống. Tách rõ client, domain, data, video processing và AI backend. Tránh khóa sản phẩm vào một nhà cung cấp AI duy nhất.

## 2. Stack đề xuất

### iOS
- Swift + SwiftUI.
- AVFoundation cho camera và recording.
- PhotosUI cho import/chọn video.
- AVKit cho playback.
- Vision/Core ML để thử nghiệm pose estimation on-device.
- SwiftData hoặc Core Data cho dữ liệu local; chọn một sau khi kiểm tra deployment target và nhu cầu migration.
- String Catalog (.xcstrings) cho UI localization.

### Backend (khi cần cloud analysis)
- API service có xác thực.
- Object storage riêng tư cho video.
- Job queue cho phân tích video dài.
- Worker inference tách biệt khỏi API.
- Database quan hệ cho user/session/analysis metadata.
- Signed URL có thời hạn; không public bucket.
- Observability không ghi nội dung video hoặc secrets vào log.

Không chốt framework backend trước khi có prototype và ước tính chi phí. Có thể chọn Swift/Vapor, TypeScript hoặc Python tùy đội ngũ và inference stack.

## 3. Module gợi ý

- AppShell: navigation, theme, localization.
- Onboarding: golfer profile.
- Camera: permissions, preview, capture.
- VideoLibrary: import, storage, playback.
- SwingSession: session lifecycle.
- Analysis: API client, local inference, result models.
- DrillLibrary: curated drills.
- Progress: history and comparisons.
- Settings: language, privacy, units.
- SharedDesignSystem: buttons, cards, typography, spacing.

## 4. Luồng dữ liệu

1. User tạo swing session.
2. Camera ghi video local.
3. App kiểm tra video metadata và quality cơ bản.
4. User xem lại và đồng ý phân tích.
5. Nếu on-device: xử lý local.
6. Nếu cloud: hiển thị rõ thông tin upload, xin consent, upload qua signed URL.
7. Backend tạo job và trả trạng thái.
8. Client nhận kết quả có version, confidence và limitations.
9. App hiển thị nội dung theo locale.
10. User lưu, xóa hoặc phản hồi kết quả.

## 5. API khái niệm

- POST /v1/sessions
- POST /v1/videos/upload-intents
- POST /v1/analyses
- GET /v1/analyses/{analysisId}
- GET /v1/drills?locale=vi-VN
- GET /v1/sessions
- DELETE /v1/videos/{videoId}
- DELETE /v1/users/me/data

Đây là endpoint đề xuất, chưa phải API đã triển khai. Cần xác định auth, schema, rate limits và idempotency trước production.

## 6. Bảo mật

- Không commit token, private key, service account hay .env thật.
- HTTPS bắt buộc.
- Mã hóa video at rest và in transit.
- Signed URL có TTL ngắn.
- Authorization kiểm tra ownership ở mọi endpoint.
- Giới hạn kích thước, định dạng và thời lượng video.
- Xóa dữ liệu theo yêu cầu và có quy trình xóa backup theo retention policy.
- Không log URL ký, token hoặc dữ liệu nhạy cảm.
- Có privacy policy và consent rõ ràng trước cloud processing.

## 7. Offline-first

- Camera, xem video, ghi chú và thư viện drill cơ bản nên hoạt động offline.
- Phân tích cloud hiển thị trạng thái “Cần kết nối mạng”.
- Đồng bộ không ghi đè dữ liệu mới hơn.
- Cho phép người dùng chọn thời điểm upload.

## 8. Kiểm thử

- Unit test cho session state, localization fallback, schema validation.
- Camera tests trên thiết bị thật.
- UI tests cho onboarding → record → review → analyze → result → drill.
- Test video hỏng, dung lượng thấp, quyền camera bị từ chối, mất mạng và app background.
- Kiểm tra hiệu năng, nhiệt độ và pin khi xử lý video.
