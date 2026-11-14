# Internationalization & Localization Specification

## 1. Ngôn ngữ phát hành

- `vi-VN`: ngôn ngữ ưu tiên, phải được biên tập tự nhiên.
- `en`: English.
- `ko-KR`: Korean.

Thiết kế cho phép thêm locale mà không sửa logic nghiệp vụ.

## 2. Nguyên tắc

- Không ghép câu bằng cách nối các mảnh dịch.
- Dùng localization key ổn định.
- Hỗ trợ pluralization, gender-neutral phrasing và format ngày/giờ/số theo locale.
- Không nhúng chữ vào ảnh; nếu cần chú thích hình, cung cấp layer text bản địa hóa.
- Không dùng cờ quốc gia làm lựa chọn ngôn ngữ duy nhất.
- Người dùng có thể đổi ngôn ngữ trong Settings mà không cần đổi ngôn ngữ iPhone.
- Lưu locale đã chọn.
- Hỗ trợ fallback có kiểm soát; không để lộ localization key ra UI.

## 3. Quy chuẩn tiếng Việt

Giọng điệu:
- Thân thiện, điềm tĩnh, tôn trọng.
- Như HLV đang hướng dẫn người mới.
- Ngắn gọn, cụ thể, không phán xét.
- Ưu tiên động từ hành động.
- Giải thích thuật ngữ lần đầu, sau đó dùng nhất quán.

Mẫu câu:
- “Hãy thử…”
- “Bạn có thể cảm nhận…”
- “Ở video này, AI quan sát thấy…”
- “Điều này có thể…”
- “Nếu thấy đau hoặc khó chịu, hãy dừng lại.”

Tránh:
- “Bạn chắc chắn bị lỗi…”
- “Đầu phải bất động tuyệt đối.”
- Dịch sát tiếng Anh gây tối nghĩa.
- Lạm dụng “tối ưu hóa”, “cơ sinh học”, “động học” khi người mới không cần.

## 4. Thuật ngữ hiển thị

- Lần đầu: “Pha hạ gậy (downswing)”.
- Sau đó: “pha hạ gậy”.
- Có mục “Xem thuật ngữ tiếng Anh” cho người muốn học.

Xem glossary làm nguồn chuẩn duy nhất.

## 5. Ví dụ localization

| Key | vi-VN | en | ko-KR |
|---|---|---|---|
| camera.face_on | Chính diện (Face-on) | Face-on | 정면 촬영 |
| camera.down_the_line | Dọc theo đường mục tiêu (DTL) | Down-the-line (DTL) | 타깃 라인 후방 촬영 |
| recording.start | Bắt đầu quay | Start recording | 촬영 시작 |
| recording.stop | Dừng quay | Stop recording | 촬영 중지 |
| club.iron | Gậy sắt | Iron | 아이언 |
| club.driver | Gậy driver | Driver | 드라이버 |
| mode.guided_analysis | Phân tích có hướng dẫn | Guided analysis | 가이드 분석 |
| mode.self_record | Tự quay | Self recording | 직접 촬영 |
| feedback.after_each | Nhận nhận xét sau mỗi cú | Feedback after each swing | 스윙마다 피드백 받기 |
| action.ready | Sẵn sàng | Ready | 준비 완료 |

Bản tiếng Hàn cần được người bản ngữ/biên tập viên golf kiểm tra trước phát hành; bảng trên là bản dịch khởi đầu.

## 6. Quy trình kiểm duyệt

1. Người viết nội dung tạo bản tiếng Việt chuẩn.
2. Biên tập viên kiểm tra độ tự nhiên và đúng kỹ thuật.
3. Dịch sang English/Korean.
4. Người bản ngữ kiểm tra thuật ngữ và sắc thái.
5. Kiểm tra trên thiết bị thật, gồm text expansion, Dynamic Type và dark mode.
6. Thu thập phản hồi người dùng và cập nhật glossary.

## 7. Localization trong code

- Dùng String Catalog (.xcstrings) hoặc giải pháp native tương đương.
- Không hard-code string trong SwiftUI.
- Nội dung bài tập dài nên lưu dạng structured content theo locale, có version.
- Phân biệt nội dung UI ngắn với nội dung huấn luyện cần biên tập.
- Không dùng machine translation trực tiếp để xuất bản nội dung kỹ thuật mà chưa review.
