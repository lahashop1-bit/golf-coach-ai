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
- Người dùng có thể đổi ngôn ngữ trong Settings mà không cần đổi ngôn ngữ của điện thoại (iOS hoặc Android).
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
| camera.face_on | Góc chính diện (Face-on) | Face-on | 정면 촬영 |
| camera.down_the_line | Góc dọc đường mục tiêu (DTL) | Down-the-line (DTL) | 타깃 라인 후방 촬영 |
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
5. Kiểm tra trên thiết bị thật iOS và Android, gồm text expansion, cỡ chữ hệ thống (Dynamic Type / font scale), VoiceOver/TalkBack và dark mode.
6. Thu thập phản hồi người dùng và cập nhật glossary.

## 7. Localization trong code

- Dùng ARB + `flutter gen-l10n` cho chuỗi UI Flutter.
- Chuỗi bắt buộc ở tầng native (mô tả quyền camera/thư viện ảnh: `InfoPlist.strings` trên iOS, `strings.xml` trên Android) cũng phải có đủ vi/en/ko.
- Không hard-code string trong code Flutter hoặc native.
- Nội dung bài tập dài nên lưu dạng structured content theo locale, có version.
- Phân biệt nội dung UI ngắn với nội dung huấn luyện cần biên tập.
- Không dùng machine translation trực tiếp để xuất bản nội dung kỹ thuật mà chưa review.

## 8. Khóa localization cho phân tích (bổ sung)

Quy ước đặt tên:
- `issue.<issue_id>.title`, `.what_we_see`, `.why_it_matters`, `.one_thing_to_try`, `.feel`, `.self_check`, `.common_mistakes`.
- `level.ok`, `level.attention`, `level.review`, `level.insufficient_data`.
- `confidence.low|medium|high`.
- `phase.address|takeaway|backswing|top|downswing|impact|follow_through|finish`.
- `tempo.backswing`, `tempo.top_pause`, `tempo.downswing`, `tempo.ratio`.
- `analysis.limit.*` cho các dòng giới hạn.

| Key | vi-VN | en |
|---|---|---|
| level.ok | Ổn | Looks fine |
| level.attention | Nên chú ý | Worth a look |
| level.review | Cần xem lại | Needs review |
| level.insufficient_data | Chưa đủ dữ liệu | Not enough data |
| phase.takeaway | Khởi động đưa gậy | Takeaway |
| phase.top | Đỉnh swing | Top of swing |
| tempo.ratio | Tỷ lệ nhịp | Rhythm ratio |
| analysis.limit.single_2d_view | Video 2D chưa phản ánh đủ chuyển động 3D. | A 2D video cannot show all 3D movement. |

Bản ko-KR điền khi có biên tập viên.

Nguồn chữ:
- Nhãn ngắn (pha, góc quay, chế độ, mức): bảng "Nhãn ngắn trên giao diện" trong glossary — đã chuẩn.
- Tên lỗi: bảng "Lỗi tư thế" trong glossary — bản nháp, dùng được trong bản nội bộ, phải được HLV duyệt trước bản công khai.

Hai loại nội dung, hai cơ chế:
- **Chuỗi UI ngắn** (nhãn, nút, trạng thái, tên lỗi, `level.*`, `phase.*`, `tempo.*`, `analysis.limit.*`): ARB.
- **Nội dung hướng dẫn dài** (IssueGuide, Drill, ShotTroubleGuide): file JSON có version theo locale trong assets (DATABASE_SCHEMA mục 7). Khóa `issue.<issue_id>.*` ở trên là trường trong file JSON này, không phải ARB.
- `evidence_key` trong kết quả phân tích trỏ tới `issue.<issue_id>.what_we_see` hoặc biến thể của nó.

Hiện thực (lát 2b): tên lỗi lấy từ trường `title` của IssueGuide JSON (`assets/content/issue_guides_<vi|en|ko>.json`) thay vì ARB, để một lỗi chỉ có một nguồn tên. Các file này là bản nháp (`reviewed_by: null`), giao diện ghi "Nội dung nháp, đang chờ huấn luyện viên duyệt".

Không dịch máy nội dung kỹ thuật khi chưa review.
