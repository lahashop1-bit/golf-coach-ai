# Acceptance Criteria

## 1. Onboarding
- Người dùng có thể chọn vi-VN, en hoặc ko-KR.
- Có thể đổi ngôn ngữ sau onboarding.
- Chọn tay thuận và trình độ.
- Không bắt buộc hoàn thành trường không thiết yếu.
- Văn bản không bị cắt ở kích thước chữ trợ năng lớn.

## 2. Camera setup
- Có giải thích dễ hiểu cho Face-on và DTL.
- Hình hướng dẫn chỉ rõ người chơi, bóng, mục tiêu và tripod.
- Người dùng chọn được loại gậy và tay thuận.
- FPS chỉ hiển thị tùy chọn thiết bị hỗ trợ.
- Có thông báo nếu chưa cấp quyền camera.
- Có cảnh báo vị trí tripod an toàn.

## 3. Recording
- Có thể bắt đầu và dừng quay.
- Có trạng thái đang quay rõ ràng.
- Có thể xem lại video.
- Có thể quay lại, lưu hoặc xóa.
- Xử lý được camera interruption và app background.
- Video không tự upload nếu chưa có consent.

## 4. Analysis
- Mỗi kết quả gắn modelVersion và schemaVersion.
- Video không đủ chất lượng không tạo kết luận kỹ thuật mạnh.
- Mỗi nhận xét có bằng chứng, confidence và giới hạn.
- Không hiển thị số liệu không đo được.
- Có trạng thái processing, completed, insufficient quality và failed.

## 5. Coaching content
- Mỗi drill có mục tiêu, chuẩn bị, bước thực hiện, số lần, cảm giác, lỗi thường gặp và cách tự kiểm tra.
- Nội dung beginner dùng câu ngắn và dễ hiểu.
- Có cảnh báo dừng nếu đau/khó chịu.
- Drill kỹ thuật phải được review trước khi xuất bản.

## 6. Localization
- Không còn chuỗi UI hard-code trong SwiftUI.
- Các màn hình MVP có vi-VN, en, ko-KR.
- Tiếng Việt được biên tập, không chỉ machine translate.
- Đổi locale không làm mất dữ liệu.
- Ngày giờ và số được format đúng locale.
- Có fallback khi thiếu bản dịch.

## 7. Privacy
- Có giải thích trước khi upload video.
- Người dùng có thể xóa video và dữ liệu liên quan.
- Không có secrets trong source control.
- Video và API được bảo vệ bằng cơ chế xác thực/ủy quyền phù hợp.
- Có chính sách retention rõ ràng trước production.

## 8. Release gate
Không phát hành phân tích AI như tính năng thật cho tới khi:
- Model được đánh giá trên tập dữ liệu có quyền sử dụng.
- Có đánh giá chuyên môn.
- Đã đo false positives/false negatives.
- Các giới hạn được thể hiện trong UI.
- Có cơ chế báo lỗi và tắt tính năng nếu model gặp sự cố.
