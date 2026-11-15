# Golf Features Specification

Tên trường và enum theo [DATABASE_SCHEMA.md](DATABASE_SCHEMA.md). Thuật ngữ theo [VIETNAMESE_GOLF_GLOSSARY.md](VIETNAMESE_GOLF_GLOSSARY.md).

## 1. Hồ sơ golfer

- Tay thuận: phải / trái.
- Trình độ: mới bắt đầu, cơ bản, trung cấp, nâng cao.
- Gậy thường tập: driver, wood, hybrid, iron (3–9), wedge, putter.
- Mục tiêu: tiếp xúc bóng, hướng bóng, khoảng cách, nhịp, ổn định, kỹ thuật cụ thể.
- Lịch sử chấn thương không thu thập ở MVP.
- MVP không cần tài khoản; hồ sơ lưu trên máy.

## 2. Thu video

### 2.1 Mô hình ghi hình (MVP)
- **Một phiên** = một lần mở màn quay hoặc một lần nhập; gồm một hoặc nhiều cú.
- **Một cú swing = một clip video** (entity `Swing`).
- Phase 1: mỗi cú được ghi bằng **bấm Quay → Dừng**, hoặc **hẹn giờ đếm ngược + tự dừng sau thời lượng tối đa** (người dùng chỉnh; giá trị mặc định chốt khi thử nghiệm). Sau mỗi cú, app tự sẵn sàng cho cú tiếp theo cho tới khi đủ số cú hoặc người dùng kết thúc sớm.
- Phase 3 (thử nghiệm): quay liên tục, tự phát hiện và cắt thành từng cú. Chỉ bật khi đủ ổn định.

### 2.2 Camera
- Plugin `capture`: AVFoundation (iOS), CameraX (Android); xem [PLATFORM_DECISION.md](PLATFORM_DECISION.md).
- Xin quyền camera đúng lúc và giải thích mục đích; không xin micro nếu không ghi âm.
- Chọn camera sau/trước nếu thiết bị hỗ trợ.
- Chỉ hiển thị FPS thiết bị hỗ trợ; luôn ghi `actualFps` từ file.
- Hẹn giờ; đếm số cú ở mức UI.
- Lưu video vào vùng lưu trữ riêng của app; lưu ra thư viện ảnh chỉ khi người dùng chọn.
- Xử lý gián đoạn (cuộc gọi, app vào nền, thiếu dung lượng, máy nóng).
- Giữ nguyên video gốc; bản cắt/đánh dấu là bản dẫn xuất.

### 2.3 Nhập video
- Trình chọn hệ thống (PHPicker trên iOS, Photo Picker trên Android).
- Người dùng chọn hoặc xác nhận góc quay, gậy, tay thuận, swing của ai.
- Video nhập qua cùng bước kiểm tra chất lượng như video tự quay.

### 2.4 Kiểm tra chất lượng
- Phase 1 (không cần pose): thời lượng, độ phân giải, FPS, độ sáng (lấy mẫu khung hình), rung (chênh lệch giữa các khung).
- Phase 3 (có pose): thấy toàn thân, che khuất, người chơi trong khung.

## 3. Góc quay

- Chính diện (Face-on) và dọc đường mục tiêu (DTL) là hai góc hỗ trợ.
- Mỗi phiên/cú có `cameraAngle`.
- Không so sánh video Face-on với DTL.
- Hướng dẫn đặt máy phải xét tay thuận.
- Cảnh báo an toàn: chân máy ngoài vùng vung gậy và lối đi.

## 4. Chế độ phiên

### Phân tích có hướng dẫn (`guided_analysis`)
Chọn số cú (mặc định 3 cho người mới), chọn nhận xét sau mỗi cú hay cuối phiên, thời lượng hiển thị nhận xét. Cho phép kết thúc sớm.

### Tự quay (`self_record`)
Chỉ quay và lưu; không tự phân tích. Người dùng có thể yêu cầu phân tích sau cho từng cú.

## 5. Quản lý cú swing

Mỗi cú có: video, ngày giờ, góc quay, gậy, tay thuận lúc ghi, FPS thật, độ phân giải, ghi chú, yêu thích, công tắc "tính vào thống kê", swing của ai, trạng thái và phiên bản phân tích.

- Swing của người khác: mặc định không tính vào thống kê; đổi được từng cú.
- Tập không gậy (`clubType = none`): chỉ chạy các lỗi áp dụng được.
- Nhật ký nhóm cú theo phiên; thẻ phiên hiển thị ngày, gậy, góc, số cú, lỗi chính.
- Lọc theo gậy, góc, ngày, lỗi.
- So sánh hai cú **cùng góc**.
- Xóa cú/phiên theo quy tắc ở DATABASE_SCHEMA mục 13.

## 6. Tám pha swing

Tư thế vào bóng → khởi động đưa gậy → pha đưa gậy lên → đỉnh swing → pha hạ gậy → thời điểm tiếp xúc bóng → pha theo đà → tư thế kết thúc.

- Nút nhảy tới từng pha trong trình phát (nhãn ngắn theo glossary).
- Chỉ đánh dấu pha khi đủ dữ liệu; pha thiếu dữ liệu ghi "Chưa đủ dữ liệu".
- Người dùng kéo để chỉnh mốc pha (`userAdjusted`).
- "Diễn biến theo pha": mỗi pha một mức theo AI_ANALYSIS_SPEC mục 5.

## 7. Phân tích và phản hồi

- Khung xương/keypoints hiển thị khi confidence đủ; bật/tắt được.
- Chỉ đưa ra lỗi có bằng chứng quan sát được.
- Mỗi cú: nổi bật **1–2 lỗi ưu tiên**; các lỗi khác ở "Xem thêm"; kèm **một điều nên thử**.
- Bài tập gắn với lỗi cụ thể.
- Người dùng đánh dấu "hữu ích", "không hiểu", "không phù hợp".
- Chi tiết: [AI_ANALYSIS_SPEC.md](AI_ANALYSIS_SPEC.md).

## 8. Chi tiết một cú swing (3 tab)

1. **Tư thế:** lỗi ưu tiên, lỗi khác, bài tập trọng tâm, độ khó sửa, tần suất gần đây, diễn biến theo pha.
2. **Toàn bộ swing:** video, tua, tốc độ 0.25x/0.5x/1x, từng khung hình, nút pha, lớp phủ khung xương và đường tham chiếu, thông tin cú (góc, gậy, thời điểm phân tích, tay thuận, có tính vào thống kê).
3. **Nhịp:** thời gian đưa gậy lên / dừng ở đỉnh / hạ gậy, tỷ lệ nhịp, so với các cú khác của chính người dùng, gợi ý ngắn.

Thanh thao tác: ghi chú, chia sẻ (sau khi xác nhận quyền riêng tư), yêu thích, thêm.

Theo phase: tab Toàn bộ swing (không có lớp phủ) có từ Phase 1; tab Tư thế và Nhịp có dữ liệu từ Phase 3–4. Trước đó hiển thị trạng thái rỗng giải thích rõ.

## 9. Danh mục lỗi và hướng dẫn sửa

Danh mục và mức sẵn sàng: [AI_ANALYSIS_SPEC.md](AI_ANALYSIS_SPEC.md) mục 10. Mỗi lỗi có một IssueGuide đã duyệt (DATABASE_SCHEMA mục 7):
- Tên thân thiện tiếng Việt; giải thích lần đầu, thuật ngữ Anh trong ngoặc.
- Điều quan sát thấy; vì sao có thể quan trọng; một điều nên thử; cảm giác nên tìm; cách tự kiểm tra; lỗi thường gặp.
- Bài tập liên quan, độ khó sửa (1–3), góc quay nên dùng, gậy áp dụng, thứ tự ưu tiên biên tập.
- Cảnh báo an toàn; không chẩn đoán.

### Nội dung ví dụ: ngẩng đầu lúc tiếp xúc bóng (`head_lift_at_impact`)

Giải thích mẫu:
"Ở pha hạ gậy, đầu và phần thân trên của bạn có vẻ ngẩng lên trước khi gậy chạm bóng. Điều này có thể làm thay đổi khoảng cách giữa cơ thể và bóng, khiến điểm tiếp xúc thiếu ổn định. Video hiện tại chỉ cho thấy dấu hiệu này; cần xem thêm vài cú ở cùng góc để đánh giá chắc hơn."

Gợi ý mẫu:
"Thử tập cú swing nửa vòng với lực nhẹ. Đưa gậy xuống chậm, giữ tư thế cúi người tự nhiên khi gậy đi qua bóng. Sau đó để đầu xoay theo cú đánh. Không ghì đầu xuống và không khóa cứng cổ."

Không tuyên bố "đầu phải giữ yên tuyệt đối". Chuyển động đầu tự nhiên có thể xuất hiện trong swing; mục tiêu là tránh ngẩng/dựng người quá sớm nếu đó thực sự là vấn đề.

## 10. Thư viện bài tập

Mỗi bài tập cần:
- ID ổn định; tên và mô tả theo locale.
- Trình độ, gậy, góc quay áp dụng; các lỗi liên quan (`issueIds`).
- Mục tiêu kỹ thuật; dụng cụ; hướng dẫn từng bước; số lần/hiệp/thời gian.
- Cảm giác nên tìm; lỗi thường gặp; cách tự kiểm tra; cảnh báo an toàn.
- Người kiểm duyệt và ngày cập nhật.

Độ khó sửa thuộc về **lỗi** (IssueGuide), không thuộc về bài tập.

Trung tâm bài tập: tab Đề xuất (theo lỗi gần đây) / Chính diện / DTL; lọc theo gậy; gợi ý góc quay phù hợp hơn. Chế độ tập có đếm lần và quay kiểm tra ở Phase 5.

Không xuất bản bài tập kỹ thuật như lời khuyên chuyên môn đã xác nhận nếu chưa qua kiểm duyệt của người có chuyên môn golf.

## 11. Hồ sơ beginner: gậy sắt số 7

Hồ sơ dùng để kiểm thử trải nghiệm, không phải giới hạn sản phẩm: thuận tay phải, mới bắt đầu, gậy sắt số 7; ưu tiên tư thế vào bóng, tiếp xúc bóng, nhịp và ổn định; cần lời giải thích đơn giản.

## 12. Sửa cú đánh (Shot Fix) — Should have, Phase 5

Người dùng chọn lỗi bóng: bóng cong trái (hook), bóng cong phải (slice), bóng đi thẳng lệch trái (pull), bóng đi thẳng lệch phải (push), mất cự ly, bóng bay quá cao (skying, chỉ driver), đánh dày, đánh đỉnh bóng, bóng bật ra cổ gậy (shank), bóng chạm mũi gậy.

Luồng: chọn lỗi → vài câu hỏi ngắn (gậy, tay thuận, mức thường xuyên) → nguyên nhân thường gặp → bài tập đã duyệt → gợi ý quay video để kiểm tra tư thế.

- Nội dung biên soạn; không suy ra đường bóng từ video.
- Ngôn ngữ xác suất ("thường do", "có thể"); HLV duyệt.
- Hướng trái/phải xét tay thuận.

## 13. Mục tiêu luyện tập — Should have, Phase 5

- Do người dùng tự đặt (số lần phân tích, bài tập, luyện nhịp), theo ngày/tuần; **mặc định không có mục tiêu nào**.
- Không phạt khi bỏ lỡ; không khuyến khích tập quá sức; huy hiệu tối thiểu.
