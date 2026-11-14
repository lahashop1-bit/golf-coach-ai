# UI/UX Specification

## 1. Hướng thiết kế

Thiết kế iOS riêng, rõ ràng, tối giản, tương phản tốt khi dùng ở sân tập. Không sao chép pixel, icon, màu nhận diện hoặc bố cục độc quyền từ GolfFix. Dùng ngôn ngữ hình ảnh thể thao hiện đại, dễ đọc ngoài trời.

Ưu tiên:
- Nút lớn, thao tác được bằng một tay.
- Ít bước trước khi quay.
- Hướng dẫn bằng hình minh họa do dự án tự tạo hoặc có giấy phép.
- Văn bản tiếng Việt ngắn, không tràn dòng khó đọc.
- Trạng thái camera và quyền riêng tư luôn rõ ràng.

## 2. Luồng quay video tham chiếu

Người dùng đã cung cấp ảnh GolfFix thể hiện các lựa chọn sau. Đây là danh sách nhu cầu cần xem xét, không phải yêu cầu sao chép UI:

### Screen A — Thiết lập ghi hình
- Chế độ: Phiên phân tích có hướng dẫn / Tự quay.
- Góc camera:
  - Face-on: quay chính diện người chơi, camera nhìn ngang qua người chơi.
  - DTL (Down-the-line): camera đặt phía sau người chơi, nhìn dọc theo đường ngắm về mục tiêu.
- Loại gậy: Gậy sắt / Driver; thiết kế dữ liệu cho phép thêm hybrid, wedge, putter.
- Tay thuận: Phải / Trái.
- Tốc độ khung hình: chọn các mức thiết bị thực sự hỗ trợ; không hiển thị 60 FPS nếu camera không hỗ trợ cấu hình đó.
- Hẹn giờ: tắt / bật và chọn thời gian đếm ngược.
- Đối tượng: cú swing của tôi / cú swing của người khác.
- Hướng dẫn đặt máy.
- Đổi camera trước/sau khi thiết bị hỗ trợ.
- Nút chính: “Bắt đầu quay”.

### Screen B — Cấu hình phiên phân tích
- Chế độ “Phân tích có hướng dẫn” hoặc “Tự quay”.
- Số cú swing cần ghi.
- Phản hồi ngay sau mỗi cú: bật/tắt.
- Thời lượng xem phản hồi có thể tùy chỉnh nếu sản phẩm hỗ trợ.
- Nút “Sẵn sàng”.

Mặc định MVP đề xuất:
- Người mới: 3 cú swing.
- Phản hồi ngay sau từng cú: bật, nhưng cho phép tắt.
- Nếu người dùng tắt, hiển thị tổng kết sau phiên.
- Không ép người dùng phải ghi đủ số cú nếu muốn kết thúc sớm.

## 3. Màn hình và hành vi

### 3.1 Onboarding
- Chọn ngôn ngữ (mặc định theo hệ thống, cho phép đổi).
- Chọn tay thuận.
- Chọn trình độ.
- Chọn mục tiêu luyện tập.
- Giải thích ngắn quyền camera và cách xử lý video.
- Có thể bỏ qua câu hỏi không bắt buộc.

### 3.2 Home
- Lời chào ngắn.
- Mục tiêu/bài tập gần nhất.
- Nút nổi bật “Quay cú swing”.
- Buổi tập gần đây.
- Tiến bộ tuần này, không gây áp lực thành tích.

### 3.3 Camera setup
- Chọn Face-on hoặc DTL.
- Hình minh họa vị trí tripod và đường mục tiêu.
- Cảnh báo không đặt camera trong vùng người/gậy có thể va chạm.
- Hướng dẫn đặt điện thoại ổn định, thấy toàn bộ cơ thể và đầu gậy.
- Kiểm tra khung hình trước khi quay.
- Chọn gậy, tay thuận, FPS, timer.
- Có nút lật camera nếu thiết bị hỗ trợ.

### 3.4 Recording
- Khung xem camera lớn.
- Hiển thị rõ đang quay, thời lượng và số cú đã ghi.
- Nút dừng dễ chạm.
- Không phủ quá nhiều chữ lên video.
- Sau khi dừng: xem lại, dùng video, quay lại hoặc xóa.

### 3.5 Review / chọn video
- Phát video, tua, chọn khung hình.
- Chọn góc quay và loại gậy.
- Ghi chú tùy chọn.
- Người dùng xác nhận trước khi gửi video lên dịch vụ cloud.

### 3.6 Analysis
- Trạng thái: đang xử lý, hoàn tất, không đủ chất lượng, lỗi.
- Nếu chất lượng không đạt: chỉ rõ lý do và hướng dẫn quay lại.
- Không hiển thị phần trăm độ chính xác giả.
- Kết quả chia thành:
  1. Điều AI quan sát được.
  2. Điều đó có thể ảnh hưởng thế nào.
  3. Một điểm nên thử ở lần tập tới.
  4. Mức tin cậy: thấp / vừa / cao, kèm giải thích.
- Cho phép xem khung hình minh họa có đánh dấu.

### 3.7 Drill detail
- Tên bài tập tiếng Việt dễ hiểu.
- Mục tiêu.
- Chuẩn bị.
- Từng bước thực hiện.
- Số lần/hiệp/thời gian.
- Cảm giác đúng nên tìm.
- Lỗi thường gặp.
- Cách tự kiểm tra.
- Điều kiện dừng nếu đau hoặc khó chịu.

### 3.8 Session summary
- Số video/cú đã ghi.
- Những nhận xét chính.
- Bài tập tiếp theo.
- Ghi chú người dùng.
- Nút lưu phiên và xem lịch sử.

### 3.9 History / Progress
- Lọc theo ngày, gậy, góc quay, lỗi/mục tiêu.
- So sánh video cùng góc và điều kiện tương tự.
- Không kết luận tiến bộ chỉ dựa trên một video.

### 3.10 Settings
- Ngôn ngữ.
- Tay thuận và hồ sơ.
- Đơn vị đo.
- Quyền riêng tư, quản lý video, xóa dữ liệu.
- Gói đăng ký nếu có.
- Trợ giúp và phản hồi.

## 4. Định nghĩa góc quay

### Face-on
Camera đặt ở phía trước người chơi, nhìn ngang qua cơ thể, vuông góc tương đối với đường mục tiêu. Khung hình nên thấy đầu, thân, chân, tay và toàn bộ gậy.

### DTL
Camera đặt phía sau người chơi, nhìn dọc theo đường mục tiêu. Cần hướng dẫn căn máy để tránh đặt quá gần hoặc quá xa đường tay; vị trí chính xác cần minh họa theo tay thuận và bố trí sân tập.

Không dùng hướng dẫn “camera phía sau” một cách mơ hồ. Dùng hình sơ đồ, chỉ rõ người chơi, bóng, đường mục tiêu và chân máy.

## 5. Khả năng tiếp cận

- Dynamic Type và VoiceOver.
- Màu không phải tín hiệu duy nhất.
- Nút có nhãn rõ ràng.
- Hỗ trợ giảm chuyển động.
- Phụ đề cho nội dung video hướng dẫn.
- Bản dịch không bị cắt ở tiếng Việt và tiếng Hàn.

## 6. Ảnh tham chiếu gốc

Hai ảnh người dùng cung cấp trong cuộc trò chuyện cần được lưu vào repository chỉ khi có file ảnh thực tế và người dùng đồng ý. Hiện tài liệu này ghi lại nội dung quan sát được; không giả định ảnh đã được commit vào repo.
