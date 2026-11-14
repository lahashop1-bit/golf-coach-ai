# Development Roadmap

## Phase 0 — Product foundation
- [ ] Đọc và xác nhận tài liệu sản phẩm.
- [ ] Chọn tên sản phẩm chính thức sau nghiên cứu thương hiệu.
- [ ] Chốt deployment target và cấu hình Xcode.
- [ ] Tạo app SwiftUI chạy được.
- [ ] Thiết lập localization vi-VN, en, ko-KR.
- [ ] Tạo design system tối thiểu.
- [ ] CI build và unit test cơ bản.

## Phase 1 — Recording MVP
- [ ] Onboarding hồ sơ golfer.
- [ ] Home.
- [ ] Hướng dẫn Face-on / DTL.
- [ ] Camera preview và recording.
- [ ] Chọn iron/driver và tay thuận.
- [ ] Timer và FPS theo khả năng thiết bị.
- [ ] Playback, lưu, xóa video.
- [ ] Swing session history local.

## Phase 2 — Coaching content
- [ ] Drill library có nội dung đã duyệt.
- [ ] Bài tập cho beginner 7-iron.
- [ ] Màn hình chi tiết bài tập.
- [ ] Nhật ký buổi tập.
- [ ] Tiếng Việt được biên tập và kiểm thử với người dùng.

## Phase 3 — Analysis prototype
- [ ] Thử pose estimation trên thiết bị.
- [ ] Đánh giá chất lượng video.
- [ ] Xác định pha swing với confidence.
- [ ] Prototype phân tích Face-on.
- [ ] Prototype phân tích DTL.
- [ ] So sánh với nhãn của HLV/golfer chuyên môn.
- [ ] Chỉ bật các nhận xét đã đạt ngưỡng chất lượng.

## Phase 4 — AI coaching
- [ ] Analysis result schema.
- [ ] Backend job processing nếu cần.
- [ ] AI diễn giải theo locale dựa trên dữ liệu có cấu trúc.
- [ ] Drill recommendation có kiểm soát.
- [ ] Feedback ngay sau từng cú / cuối phiên.
- [ ] User feedback và model monitoring.

## Phase 5 — Progress and release
- [ ] So sánh video cùng góc.
- [ ] Báo cáo tiến bộ.
- [ ] Privacy controls và export/delete.
- [ ] TestFlight beta.
- [ ] Kiểm thử tiếng Việt, tiếng Anh, tiếng Hàn.
- [ ] Accessibility, performance, crash testing.
- [ ] App Store preparation.

## Nguyên tắc ưu tiên

Không xây AI phức tạp trước khi camera, quay video, hướng dẫn góc quay và thư viện bài tập hoạt động tốt. MVP phải tạo giá trị ngay cả khi AI chưa sẵn sàng: người dùng vẫn quay, xem lại, ghi chú và tập theo bài tập đáng tin cậy.
